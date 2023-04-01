function [updatedPlayer, updatedBall] = UpdatePlayerState(players, ball, indexOfPlayer, timeDelta, playerOriginalPosition)
% This function updates the state of a player and the ball based on the action rules. 
% It takes the current positions of all the players and the ball, the index of the player to update, the time since the last update, and the player's original position. 
% It returns the updated state of the player and the ball. The function uses a global variable to keep track of which team is currently in possession of the ball.

% Declares a global variable that keeps track of the last team that had possession of the ball.
global lastTeamOnBall;

% Defines various constants and coefficients that are used in the function.
%nAttributes = size(players{3},2);                                               % The number of attributes that describe each player, such as their position and speed.
nPlayers=length(players{1});                                                    % The total number of players on the field.
kickBallSigma = 1/200;                                                          % A constant used in the KickBall function, which represents the standard deviation of the noise added to the kick direction.
passBallSigma = 1/200;                                                          % A constant used in the PassBall function, which represents the standard deviation of the noise added to the pass direction.
kickBallAcceleration = 0.5;                                                     % A constant used in the KickBall function, which represents the acceleration of the ball after being kicked.
passBallAcceleration = 0.5;                                                     % A constant used in the PassBall function, which represents the acceleration of the ball after being passed.
shootBallCoefficient = 5;                                                       % A constant used in the KickBall function, which determines the strength of the kick towards the goal. Renamed as "kickBallCoefficient" in KickBall function.
kickBallCoefficient = 5;                                                       % A constant used in the KickBall function, which determines the strength of the kick towards the goal. Renamed as "kickBallCoefficient" in KickBall function.
passBallCoefficient = 0.2;                                                      % A constant used in the PassBall function, which determines the strength of the pass towards the target player.
moveForwardCoefficient = 0.5;                                                   % A constant used in the Move function, which determines how much a player moves forward when they have the ball.
kickBallProbabilityCoefficient = 24;                                            % A constant used in the calculation of the likelihood of kicking the ball towards the goal.
actionBallDistance = 4;                                                         % The distance within which a player can perform an action with the ball, such as passing or shooting.
actionPlayerDistance = 15;                                                      % The distance within which a player can receive a pass.
actionGoalDistance = 10;                                                        % The distance within which a player is close enough to the goal to consider shooting towards it.
markedDistance = actionPlayerDistance * 0.7;                                    % The distance within which a player is considered marked by an opponent player. % Between 10-15 seems optimal. % 70% of actionPlayerDistance = 15 * 0.7 = 10.5. 

% Sets the goalPosition based on the player's team.
% If the player's team is 0 (Red Team), the goal is on the positive x-axis.
% If the player's team is 1 (Blue Team), the goal is on the negative x-axis.
if players{3}(indexOfPlayer)==0
    goalPosition = [+60 0];
else
    goalPosition = [-60 0];
end

% Initializes likelihoods for different actions.
% kickBallLikelihood, passBallLikelihood, and doNothingWithBallLikelihood all sum up to 1.
kickBallLikelihood = 0.0;
passBallLikelihood = 0.5;
doNothingWithBallLikelihood = 0.5;

% Calculates the sum of all likelihoods and throws an error if it's not equal to 1.
sumOfLikelihoods = kickBallLikelihood + passBallLikelihood + doNothingWithBallLikelihood;
if sumOfLikelihoods ~= 1
    ME = MException('The sum of the likelyhoods has to equal 1. They are currently summed to %s',sumOfLikelihoods);
    throw(ME)
end

% Gets the player's position, the ball's position, and the distances between the player and the ball, and the player and the goal.
playerPosition = players{1}(indexOfPlayer,:);
ballPosition = ball(1,:);
distanceToBall = sqrt((ballPosition(1) - playerPosition(1))^2 + (ballPosition(2) - playerPosition(2))^2);
distanceToGoal = sqrt((goalPosition(1) - playerPosition(1)).^2 + (goalPosition(2) - playerPosition(2)).^2);

% % Calculate the total number of teammates within the "actionPlayerDistance":
% teammatesWithinActionPlayerDistance = sum(sqrt(sum((players{1}(players{3} == players{3}(indexOfPlayer),:) - playerPosition).^2, 2)) <= actionPlayerDistance);
% disp(['Number of teammates within action player distance: ', num2str(teammatesWithinActionPlayerDistance)]);

% If the player is close enough to the ball, the player can perform an action.
if distanceToBall < actionBallDistance
    
    % Updates the last team that had possession of the ball to the player's team.
    lastTeamOnBall=players{3}(indexOfPlayer);
    
    % Calculates the likelihood of kicking the ball towards the goal.
    kickBallLikelihood=exp(-distanceToGoal/kickBallProbabilityCoefficient);
    
    % Randomly selects an action based on the likelihoods of different actions. 
    % If the player is close enough to the goal or the likelihood of kicking is higher than the likelihood of passing, the player kicks the ball towards the goal.
    % Otherwise, the player passes the ball to another player if they are marked or if the player is the goalie. 
    % If neither of these conditions are met, the player moves forward with the ball. 
    % Finally, the function updates the ball's position and then calls the Move function to update the player's position. 
    % The updated player and ball states are returned as output.

    whatTodo = rand();  % Generate a random number between 0 and 1
    kickLikeRange = kickBallLikelihood;  % Assign kick ball likelihood to kickLikeRange variable
    passLikeRange = kickBallLikelihood + passBallLikelihood; % Assign kick and pass ball likelihoods to passLikeRange variable
    
    % Determine the action based on the random number and likelihood ranges
    if  whatTodo <= kickLikeRange || distanceToGoal < actionGoalDistance  % If the random number falls within the range of kicking or the player is close to the goal
        % Kick the ball towards the goal if the random number generated is less than or equal to the kick likelihood range, or if the distance to the goal is less than the action goal distance
        targetPosition = goalPosition;  % Set the target position as the goal
        ball = BallKicking(ball, kickBallSigma, shootBallCoefficient, targetPosition, timeDelta);  % Kick the ball
    elseif (whatTodo > kickLikeRange) && (whatTodo <= passLikeRange) && MarkedPlayers(players,indexOfPlayer,players{3}(indexOfPlayer),markedDistance) || mod(indexOfPlayer,nPlayers/2)==0 % If the player is marked or is the goalie
        % Pass the ball to a teammate if the player is marked by an opponent player within the marked distance, or if the player is the goalkeeper
        targetPosition = LookForTeammates(players,indexOfPlayer,markedDistance);  % Look for another teammate to pass the ball to
        ball = BallPassing(ball, passBallSigma, passBallCoefficient, passBallAcceleration, targetPosition, timeDelta);  % Pass the ball
    else % If the player is not marked and can go forward with the ball
        targetPosition = [goalPosition(1)+sign(players{3}(indexOfPlayer)-1/2) players{1}(indexOfPlayer,2)];  % Set the target position as forward of the player
        ball = BallKicking(ball, kickBallSigma, moveForwardCoefficient, targetPosition, timeDelta);  % Kick the ball forward
    end
end

updatedBall = ball; % Set updated ball to the current ball state
updatedPlayer = PlayerMovement(players, indexOfPlayer, updatedBall, timeDelta, playerOriginalPosition); % Update player state by moving to new position

end
