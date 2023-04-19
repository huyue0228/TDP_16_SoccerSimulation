function [updatedPlayer, updatedBall] = UpdatePlayerState(players, ball, indexOfPlayer, timeDelta, playerStickPosition, goalsTeam0, goalsTeam1)
% This function updates the state of a player and the ball based on the actions/status of the players. 
% It takes the current positions of all the players and the ball, the index of the player to update, the time since the last update, and the player's original position. 
% It returns the updated state of the player and the ball. The function uses a global variable to keep track of which team is currently in possession of the ball.

% Declaring some global variables that hold the game statistics
global lastTeamBallPossession; global totalPossession; global playerKicksBlue1; global playerKicksBlue2; global playerKicksBlue3; global playerKicksBlue4; global playerPossessionBlue1; global playerPossessionBlue2; global playerPossessionBlue3; global playerPossessionBlue4; global teamKicksBlue; global teamPossessionBlue; global playerKicksRed1; global playerKicksRed2; global playerKicksRed3; global playerKicksRed4; global playerPossessionRed1; global playerPossessionRed2; global playerPossessionRed3; global playerPossessionRed4; global teamKicksRed; global teamPossessionRed; global leadingTeam; global fallBehindTeam; global KickCounterForAudioCues;


% Defines various constants and coefficients that are used in the function.
nPlayers=length(players{1});                                                    % The total number of players on the field.
kickBallSigma = 1/200;                                                          % A constant which represents the standard deviation of the noise added to the kick direction.
passBallSigma = 1/200;                                                          % A constant which represents the standard deviation of the noise added to the pass direction.
passBallAcceleration = 0.5;                                                     % A constant which represents the acceleration of the ball after being passed.
shootBallCoefficient = 4;                                                       % A constant which determines the strength of the kick towards the goal.
passBallCoefficient = 0.1;                                                      % A constant which determines the strength of the pass towards the target player.
moveForwardCoefficient = 0.2;                                                   % A constant which determines how much a player moves forward when they have the ball.
actionBallDistance = 4;                                                         % The distance within which a player can perform an action with the ball, such as passing or shooting.
actionPlayerDistance = 15;                                                      % The distance within which a player can receive a pass.
actionGoalDistance = 10;                                                        % The distance within which a player is close enough to the goal to consider shooting towards it.
AvailabilityDistance = actionPlayerDistance * 0.7;                              % The distance within which a player is considered far from an opponent player and available to recieve a pass. % 70% of actionPlayerDistance = 15 * 0.7 = 10.5. 
striker1Coefficient = 1;
striker2Coefficient = 1;
defenderCoefficient = 1;

% Sets the goalPosition based on the player's team.
% If the player's team is 0 (Red Team), the goal is on the positive x-axis.
% If the player's team is 1 (Blue Team), the goal is on the negative x-axis.
if ball(1,1) >= 35 && (ball(1,2) > 25 || ball(1,2) < -25)
    if players{3}(indexOfPlayer)==0
        goalPosition = [+38 randi([-20 20], 1)];
    else
        goalPosition = [-43 randi([-20 20], 1)];
    end
elseif ball(1,1) <= -35 && (ball(1,2) > 25 || ball(1,2) < -25)
    if players{3}(indexOfPlayer)==0
        goalPosition = [+43 randi([-20 20], 1)];
    else
        goalPosition = [-38 randi([-20 20], 1)];
    end
else
    if players{3}(indexOfPlayer)==0
        goalPosition = [+43 randi([-20 20], 1)];
    else
        goalPosition = [-43 randi([-20 20], 1)];
    end
end 


if goalsTeam0 > goalsTeam1
   leadingTeam = 0;
   fallBehindTeam = 1;
elseif goalsTeam0 < goalsTeam1
   leadingTeam = 1;
   fallBehindTeam = 0;
else
   leadingTeam = NaN;
   fallBehindTeam = NaN;
end

if players{3}(indexOfPlayer) == leadingTeam    
    striker2Coefficient = 0.5;
    defenderCoefficient = 1.5;
elseif players{3}(indexOfPlayer) == fallBehindTeam
    striker1Coefficient = 2;
    striker2Coefficient = 1.5;
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
    lastTeamBallPossession = players{3}(indexOfPlayer);

    if lastTeamBallPossession == 0
        totalPossession = totalPossession + 1;
        teamPossessionRed = teamPossessionRed + 1;
        if indexOfPlayer == 1
            playerPossessionRed1 = playerPossessionRed1 + 1;
        elseif indexOfPlayer == 2
            playerPossessionRed2 = playerPossessionRed2 + 1;
        elseif indexOfPlayer == 3
            playerPossessionRed3 = playerPossessionRed3 + 1;
        elseif indexOfPlayer == 4
            playerPossessionRed4 = playerPossessionRed4 + 1;
        end        
    elseif lastTeamBallPossession == 1
        totalPossession = totalPossession + 1;
        teamPossessionBlue = teamPossessionBlue + 1;
        if indexOfPlayer == 5
            playerPossessionBlue1 = playerPossessionBlue1 + 1;
        elseif indexOfPlayer == 6
            playerPossessionBlue2 = playerPossessionBlue2 + 1;
        elseif indexOfPlayer == 7
            playerPossessionBlue3 = playerPossessionBlue3 + 1;
        elseif indexOfPlayer == 8
            playerPossessionBlue4 = playerPossessionBlue4 + 1;
        end
    end

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
        updatedBall(1,:) = updatedBall(1,:) * timeDelta;
        ball = updatedBall;

        KickCounterForAudioCues = KickCounterForAudioCues + 1;

        if KickCounterForAudioCues == 60
            KickCounterForAudioCues = 0;
            FansChant = randi([0,2]);
            if FansChant == 0
                [x,fs] = audioread('FansChanting1.wav');
                sound(x, fs)
            elseif FansChant == 1
                [x,fs] = audioread('FansChanting2.wav');
                sound(x, fs)
            elseif FansChant == 2
                [x,fs] = audioread('FansChanting3.wav');
                sound(x, fs)
            end
        end

        Kick = randi([0,4]);
        if Kick == 0
            [x,fs] = audioread('Kick2.wav');
            sound(x, fs)
        elseif Kick == 1
            [x,fs] = audioread('Kick3.wav');
            sound(x, fs)
        elseif Kick == 2
            [x,fs] = audioread('Kick4.wav');
            sound(x, fs)
        elseif Kick == 3
            [x,fs] = audioread('Kick5.wav');
            sound(x, fs)
        end
        if lastTeamBallPossession == 0
            teamKicksRed = teamKicksRed + 1;
            if indexOfPlayer == 1
                playerKicksRed1 = playerKicksRed1 + 1;
            elseif indexOfPlayer == 2
                playerKicksRed2 = playerKicksRed2 + 1;
            elseif indexOfPlayer == 3
                playerKicksRed3 = playerKicksRed3 + 1;
            elseif indexOfPlayer == 4
                playerKicksRed4 = playerKicksRed4 + 1;
            end        
        elseif lastTeamBallPossession == 1 
            teamKicksBlue = teamKicksBlue + 1;
            if indexOfPlayer == 5
                playerKicksBlue1 = playerKicksBlue1 + 1;
            elseif indexOfPlayer == 6
                playerKicksBlue2 = playerKicksBlue2 + 1;
            elseif indexOfPlayer == 7
                playerKicksBlue3 = playerKicksBlue3 + 1;
            elseif indexOfPlayer == 8
                playerKicksBlue4 = playerKicksBlue4 + 1;
            end
        end       

    elseif whatTodo == 0.5 % If the number given to the whatTodo action variable equals 0.5 (passing the ball to a teammate)
        
        NotAvailable=true; % Initialize the flag NotAvailable as true
        d = pdist(players{1}); % Compute the pairwise distances between the players
        z = squareform(d); % Convert the distance vector to a square, symmetric distance matrix
        z(indexOfPlayer,indexOfPlayer)=inf; % Set the distance of the target player to itself to infinity
        
        % Check if the minimum distance to a player from the opposite team is greater than the Availability distance
        if min(z(indexOfPlayer,(1-players{3}(indexOfPlayer))*nPlayers/2+(1:nPlayers/2))) > AvailabilityDistance
            NotAvailable=false; % If condition is true, set NotAvailable to false
        end

        if NotAvailable || mod(indexOfPlayer,nPlayers/2)==0 % If the player is NotAvailable or that player is the goalie
            % Pass the ball to a teammate if the player is not far from an opponent player within the availability distance, or if the player is the goalkeeper
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

            % Loop until an availabile player is found or there are no players left to pass to
            while true
                % Find the index of the closest opponent to the target player
                [~, closestOpponentIndex] = min(distanceToOpponents);
                
                % Check if the closest opponent is within the availability distance
                if distanceToOpponents(closestOpponentIndex) < AvailabilityDistance
                    % If the opponent is too close, exclude the target player from being a potential target and continue the loop
                    distanceToTeamMates(indexOfTarget) = NaN;
                else
                    % If the opponent is far enough away, set the target position to the position of the target player and return it
                    targetPosition = players{1}(indexOfTarget + playerTeam*nPlayers/2, :);
                    break;
                end
                
                % If no available players are left, return the current target position
                if sum(isnan(distanceToTeamMates)) == nPlayers/2
                    break;
                end
                
                % Find the index of the next closest target player
                [~, indexOfTarget] = min(distanceToTeamMates);
                
                % Check if the target player is available               
                NotAvailable=true; % Initialize the flag NotAvailable as true
                d = pdist(players{1}); % Compute the pairwise distances between the players
                z = squareform(d); % Convert the distance vector to a square, symmetric distance matrix
                z(indexOfTarget,indexOfTarget)=inf; % Set the distance of the target player to itself to infinity
                
                % Check if the minimum distance to a player from the opposite team is greater than the availability distance
                if min(z(indexOfTarget,(1-playerTeam)*nPlayers/2+(1:nPlayers/2))) > AvailabilityDistance
                    NotAvailable=false; % If condition is true, set NotAvailable to false
                end
        
                % If the target player is available, set the target position to their position and return it
                if ~NotAvailable
                    targetPosition = players{1}(indexOfTarget + playerTeam*nPlayers/2, :);
                    break;
                else
                    % Otherwise, exclude the non-available player from being a potential target and continue the loop
                    distanceToTeamMates(indexOfTarget) = NaN;
                end
            end
                
            dampingFactor = 0.95; % Define a damping factor to account for deceleration (e.g., due to air resistance or friction)
            maxPassLength = 10; % Define the maximum pass length
            
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
            updatedBall(1,:) = updatedBall(1,:) * timeDelta;
            
            ball = updatedBall;
            
            KickCounterForAudioCues = KickCounterForAudioCues + 1;

            if KickCounterForAudioCues == 60
                KickCounterForAudioCues = 0;
                FansChant = randi([0,2]);
                if FansChant == 0
                    [x,fs] = audioread('FansChanting1.wav');
                    sound(x, fs)
                elseif FansChant == 1
                    [x,fs] = audioread('FansChanting2.wav');
                    sound(x, fs)
                elseif FansChant == 2
                    [x,fs] = audioread('FansChanting3.wav');
                    sound(x, fs)
                end
            end

            Pass = randi([0,4]);
            if Pass == 0
                [x,fs] = audioread('Kick2.wav');
                sound(x, fs)
            elseif Pass == 1
                [x,fs] = audioread('Kick3.wav');
                sound(x, fs)
            elseif Pass == 2
                [x,fs] = audioread('Kick4.wav');
                sound(x, fs)
            elseif Pass == 3
                [x,fs] = audioread('Kick5.wav');
                sound(x, fs)
            end
        end

    else % If the player is free (available) and can go forward with the ball
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
        updatedBall(1,:) = updatedBall(1,:) * timeDelta;
        ball = updatedBall;
        KickCounterForAudioCues = KickCounterForAudioCues + 1;

        if KickCounterForAudioCues == 60
            KickCounterForAudioCues = 0;
            FansChant = randi([0,2]);
            if FansChant == 0
                [x,fs] = audioread('FansChanting1.wav');
                sound(x, fs)
            elseif FansChant == 1
                [x,fs] = audioread('FansChanting2.wav');
                sound(x, fs)
            elseif FansChant == 2
                [x,fs] = audioread('FansChanting3.wav');
                sound(x, fs)
            end
        end
        
        Kick = randi([0,4]);
        if Kick == 0
            [x,fs] = audioread('Kick2.wav');
            sound(x, fs)
        elseif Kick == 1
            [x,fs] = audioread('Kick3.wav');
            sound(x, fs)
        elseif Kick == 2
            [x,fs] = audioread('Kick4.wav');
            sound(x, fs)
        elseif Kick == 3
            [x,fs] = audioread('Kick5.wav');
            sound(x, fs)
        end
    end
end

updatedBall = ball; % Set updated ball to the current ball state
updatedPlayer = PlayerMovement(players, indexOfPlayer, updatedBall, timeDelta, playerStickPosition,striker1Coefficient,striker2Coefficient,defenderCoefficient); % Update player state by moving to new position

end