function [updatedPlayer, updatedBall] = UpdatePlayerState(players, ball, indexOfPlayer, timeDelta, playerOriginalPosition, goalsTeam0, goalsTeam1)
% This function updates the state of a player and the ball based on the actions/status of the players. 
% It takes the current positions of all the players and the ball, the index of the player to update, the time since the last update, and the player's original position. 
% It returns the updated state of the player and the ball. The function uses a global variable to keep track of which team is currently in possession of the ball.

% Declares a global variable that keeps track of the last team that had possession of the ball.
global lastTeamBallPossession;

% Defines various constants and coefficients that are used in the function.
nPlayers=length(players{1});                                                    % The total number of players on the field.
kickBallSigma = 1/200;                                                          % A constant which represents the standard deviation of the noise added to the kick direction.
passBallSigma = 1/200;                                                          % A constant which represents the standard deviation of the noise added to the pass direction.
passBallAcceleration = 0.5;                                                     % A constant which represents the acceleration of the ball after being passed.
shootBallCoefficient = 3;                                                       % A constant which determines the strength of the kick towards the goal.
passBallCoefficient = 0.1;                                                      % A constant which determines the strength of the pass towards the target player.
moveForwardCoefficient = 0.2;                                                   % A constant which determines how much a player moves forward when they have the ball.
actionBallDistance = 4;                                                         % The distance within which a player can perform an action with the ball, such as passing or shooting.
actionPlayerDistance = 15;                                                      % The distance within which a player can receive a pass.
actionGoalDistance = 10;                                                        % The distance within which a player is close enough to the goal to consider shooting towards it.
markedDistance = actionPlayerDistance * 0.7;                                    % The distance within which a player is considered marked by an opponent player. % Between 10-15 seems optimal. % 70% of actionPlayerDistance = 15 * 0.7 = 10.5. 

% Sets the goalPosition based on the player's team.
% If the player's team is 0 (Red Team), the goal is on the positive x-axis.
% If the player's team is 1 (Blue Team), the goal is on the negative x-axis.
if players{3}(indexOfPlayer)==0
    goalPosition = [+60 randi([-13 13], 1)];
else
    goalPosition = [-60 randi([-13 13], 1)];
end

% Gets the player's position, the ball's position, and the distances between the player and the ball, and the player and the goal.
playerPosition = players{1}(indexOfPlayer,:);
ballPosition = ball(1,:);
distanceToBall = sqrt((ballPosition(1) - playerPosition(1))^2 + (ballPosition(2) - playerPosition(2))^2);
distanceToGoal = sqrt((goalPosition(1) - playerPosition(1)).^2 + (goalPosition(2) - playerPosition(2)).^2);

% Calculate distances to teammates and opponents
teammateIndices = players{3} == players{3}(indexOfPlayer);
opponentIndices = players{3} ~= players{3}(indexOfPlayer);
teammateDistances = pdist2(playerPosition, players{1}(teammateIndices, :));
opponentDistances = pdist2(playerPosition, players{1}(opponentIndices, :));

% Calculate distances to the closest teammate and opponent
minTeammateDistance = min(teammateDistances);
minOpponentDistance = min(opponentDistances);

% Calculate a ratio of distances to the closest opponent and teammate
distanceRatio = minOpponentDistance / (minTeammateDistance + minOpponentDistance);

% Set a threshold for deciding whether to shoot, pass or move forward
shootThreshold = 0.7;
passThreshold = 0.3;

% If the player is close enough to the ball, the player can perform an action.
if distanceToBall < actionBallDistance
    
    % Updates the last team that had possession of the ball to the player's team.
    lastTeamBallPossession=players{3}(indexOfPlayer);

    % Update whatTodo based on the distance ratio and thresholds
    if distanceRatio >= shootThreshold
        whatTodo = 0; % Shoot
    elseif distanceRatio >= passThreshold && distanceRatio < shootThreshold
        whatTodo = 0.5; % Pass
    else
        whatTodo = 1; % Move forward
    end

    % Determine the action based on the number given to the whatTodo action variable
    if  whatTodo == 0 || distanceToGoal < actionGoalDistance  % If the number given to the whatTodo action variable equals 0 (shooting the ball towards the goal) or the player is close to the goal
        targetPosition = goalPosition;  % Set the target position as the goal
        
        updatedBall = ball;
        
        % Set an error; error range:[-0.15,0.15]
        error = 0.3 * rand() - 0.15;
        
        distanceError = targetPosition - ballPosition;
        distance = norm(distanceError);
        direction = distanceError / distance;
        
        % Add random noise to the kick direction
        kickDirection = direction + error;
        kickDirection(1) = kickDirection(1) + normrnd(0, kickBallSigma); % Add random noise to the x-component of the kick direction
        kickDirection(2) = kickDirection(2) + normrnd(0, kickBallSigma); % Add random noise to the y-component of the kick direction
        
        % Update the speed of the ball
        updatedBall(2,:) = updatedBall(2,:) + shootBallCoefficient * kickDirection;
        
        % Apply a damping factor to account for deceleration (e.g., due to air resistance or friction)
        dampingFactor = 0.95;
        updatedBall(2,:) = dampingFactor * updatedBall(2,:);
        
        % Update the position of the ball based on the updated velocity and timeDelta
        updatedBall(1,:) = updatedBall(1,:) + updatedBall(2,:) * timeDelta;
        ball = updatedBall;
        
    elseif whatTodo == 0.5 % If the number given to the whatTodo action variable equals 0.5 (passing the ball to a teammate)
        
        Marked=true; % Initialize the flag Marked as true
        d = pdist(players{1}); % Compute the pairwise distances between the players
        z = squareform(d); % Convert the distance vector to a square, symmetric distance matrix
        z(indexOfPlayer,indexOfPlayer)=inf; % Set the distance of the target player to itself to infinity
        
        % Check if the minimum distance to a player from the opposite team is greater than the marked distance
        if min(z(indexOfPlayer,(1-players{3}(indexOfPlayer))*nPlayers/2+(1:nPlayers/2))) > markedDistance
            Marked=false; % If condition is true, set Marked to false
        end

        if Marked || mod(indexOfPlayer,nPlayers/2)==0 % If the player is marked or is the goalie
            % Pass the ball to a teammate if the player is marked by an opponent player within the marked distance, or if the player is the goalkeeper
            minPassLength = 5; % Minimum length for a pass to be considered
            playerTeam = players{3}(indexOfPlayer); % The team number of the player with the ball
            
            % Initialize the target position to be the same as the current player's position with an offset in the x direction based on the team number. If the team number is 0 (Red Team), the offset is -1, and if the team number is 1 (Blue Team), the offset is 1.
            targetPosition = [players{1}(indexOfPlayer, 1) + sign(1/2 - playerTeam) players{1}(indexOfPlayer, 2)];
            
            % Compute the pairwise distances between all players on the field
            d = pdist(players{1});
            z = squareform(d);
            
            % Depending on the team of the player with the ball, select the distances to team mates and opponents.
            if playerTeam == 0 % Red Team 
                distanceToTeamMates = z(indexOfPlayer,1:nPlayers/2);
                distanceToOpponents = z(indexOfPlayer,nPlayers/2+1:nPlayers);
            elseif playerTeam == 1 % Blue Team
                distanceToTeamMates = z(indexOfPlayer,nPlayers/2+1:nPlayers);
                distanceToOpponents = z(indexOfPlayer,1:nPlayers/2);
            end
            
            % Exclude the goalie from being a potential target to pass to
            distanceToTeamMates(nPlayers/2) = NaN; 
            
            % Exclude players who are too close to the current player to be viable targets
            distanceToTeamMates(distanceToTeamMates < minPassLength) = NaN; 
            
            % Initialize the index of the target player
            indexOfTarget = 1;

            % Loop until an unmarked player is found or there are no players left to pass to
            while true
                % Find the index of the closest opponent to the target player
                [~, closestOpponentIndex] = min(distanceToOpponents);
                
                % Check if the closest opponent is within the marked distance
                if distanceToOpponents(closestOpponentIndex) < markedDistance
                    % If the opponent is too close, exclude the target player from being a potential target and continue the loop
                    distanceToTeamMates(indexOfTarget) = NaN;
                else
                    % If the opponent is far enough away, set the target position to the position of the target player and return it
                    targetPosition = players{1}(indexOfTarget + playerTeam*nPlayers/2, :);
                    break;
                end
                
                % If no unmarked players are left, return the current target position
                if sum(isnan(distanceToTeamMates)) == nPlayers/2
                    break;
                end
                
                % Find the index of the next closest target player
                [~, indexOfTarget] = min(distanceToTeamMates);
                
                % Check if the target player is marked               
                Marked=true; % Initialize the flag Marked as true
                d = pdist(players{1}); % Compute the pairwise distances between the players
                z = squareform(d); % Convert the distance vector to a square, symmetric distance matrix
                z(indexOfTarget,indexOfTarget)=inf; % Set the distance of the target player to itself to infinity
                
                % Check if the minimum distance to a player from the opposite team is greater than the marked distance
                if min(z(indexOfTarget,(1-playerTeam)*nPlayers/2+(1:nPlayers/2))) > markedDistance
                    Marked=false; % If condition is true, set Marked to false
                end
        
                % If the target player is unmarked, set the target position to their position and return it
                if ~Marked
                    targetPosition = players{1}(indexOfTarget + playerTeam*nPlayers/2, :);
                    break;
                else
                    % Otherwise, exclude the marked player from being a potential target and continue the loop
                    distanceToTeamMates(indexOfTarget) = NaN;
                end
            end
                
            dampingFactor = 0.95; % Define a damping factor to account for deceleration (e.g., due to air resistance or friction)
            maxPassLength = 20; % Define the maximum pass length
            
            ballPosition = ball(1,:); % Extract the current ball position from the input ball variable
            updatedBall = ball; % Initialize the updatedBall variable with the current ball values
            passLength = norm(targetPosition - ballPosition); % Calculate the length of the pass
            scaledPassLength = min(passLength, maxPassLength); % Limit the pass length to the defined maximum
            
            passBallCoefficient = (passBallCoefficient * scaledPassLength / passLength) * normrnd(1, 0.1); % Scale the passBallCoefficient based on the scaled pass length and a random factor with mean 1 and standard deviation 0.1
            
            kickDirection = (targetPosition - ballPosition) / passLength; % Calculate the unit vector representing the direction of the pass
            kickDirection(1) = kickDirection(1) + normrnd(0, passBallSigma); % Add random noise to the x-component of the kick direction
            kickDirection(2) = kickDirection(2) + normrnd(0, passBallSigma); % Add random noise to the y-component of the kick direction
            
            % Update the velocity of the ball based on the calculated kick direction, scaled pass length, and acceleration
            updatedBall(2,:) = updatedBall(2,:) + passBallCoefficient * passLength * kickDirection + passBallAcceleration * timeDelta * kickDirection;
            
            % Apply the damping factor to the updated velocity
            updatedBall(2,:) = dampingFactor * updatedBall(2,:);
            
            % Update the position of the ball based on the updated velocity and timeDelta
            updatedBall(1,:) = updatedBall(1,:) + updatedBall(2,:) * timeDelta;
            
            ball = updatedBall;
        end 
    else % If the player is not marked and can go forward with the ball
        targetPosition = [goalPosition(1)+sign(players{3}(indexOfPlayer)-1/2) players{1}(indexOfPlayer,2)];  % Set the target position as forward of the player
        
        updatedBall = ball;
        
        % Set an error; error range:[-0.15,0.15]
        error = 0.3 * rand() - 0.15;
        
        distanceError = targetPosition - ballPosition;
        distance = norm(distanceError);
        direction = distanceError / distance;
        
        % Add random noise to the kick direction
        kickDirection = direction + error;
        kickDirection(1) = kickDirection(1) + normrnd(0, kickBallSigma); % Add random noise to the x-component of the kick direction
        kickDirection(2) = kickDirection(2) + normrnd(0, kickBallSigma); % Add random noise to the y-component of the kick direction
        
        % Update the speed of the ball
        updatedBall(2,:) = updatedBall(2,:) + moveForwardCoefficient * kickDirection;
        
        % Apply a damping factor to account for deceleration (e.g., due to air resistance or friction)
        dampingFactor = 0.95;
        updatedBall(2,:) = dampingFactor * updatedBall(2,:);
        
        % Update the position of the ball based on the updated velocity and timeDelta
        updatedBall(1,:) = updatedBall(1,:) + updatedBall(2,:) * timeDelta;
        ball = updatedBall;
    end
end

updatedBall = ball; % Set updated ball to the current ball state
updatedPlayer = PlayerMovement(players, indexOfPlayer, updatedBall, timeDelta, playerOriginalPosition, goalsTeam0, goalsTeam1); % Update player state by moving to new position

end
