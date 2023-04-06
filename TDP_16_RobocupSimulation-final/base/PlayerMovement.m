function [updatedPlayer] = PlayerMovement(players, indexOfPlayer, ball, timeDelta, playerOriginalPosition)

% This is the function where you define the movment behavoir for a player
% This is an example of constant velocity while only chasing the ball
% The velocity is set by the norm of the initial values in the xVel and yVel in the player matrix.

nPlayers=length(players{1});
playerTeam=players{3}(indexOfPlayer);
actionPlayerDistance = 15; % 12-15 seems good

playerPosition = players{1}(indexOfPlayer,:);
playerVelocity = players{2}(indexOfPlayer,:);
playerPositions = players{1}(playerTeam*nPlayers/2+(1:nPlayers/2),:);

%set the acceleration
playerAcceleration = 0.5;

ballPosition = ball(1,:);
distanceToBall = norm(ballPosition-playerPosition);
distanceToBallForAllTeamMates = vecnorm((ballPosition-playerPositions)');
[~,indexOfPlayerThatWillGoForTheBall]=min(distanceToBallForAllTeamMates);
distanceToOriginalPosition = norm(playerOriginalPosition(indexOfPlayer,:)-playerPosition);

if indexOfPlayer==nPlayers/2 || indexOfPlayer==nPlayers %goalie
    if (distanceToBall<actionPlayerDistance && distanceToOriginalPosition < actionPlayerDistance)...
            || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
        playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
    else
        playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2)- playerPosition(2),playerOriginalPosition(indexOfPlayer,1)- playerPosition(1));
    end
else %players (not goalie)
    if (distanceToBall<actionPlayerDistance && distanceToOriginalPosition < 1.0*actionPlayerDistance)...
            || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
        playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
    else
        playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2)- playerPosition(2),playerOriginalPosition(indexOfPlayer,1)- playerPosition(1));
    end
end

player{1}(indexOfPlayer,1) = playerPosition(1) + cos(playerDirection) * playerVelocity(1) * timeDelta + 0 * playerAcceleration * cos(playerDirection) * timeDelta * timeDelta;
player{1}(indexOfPlayer,2) = playerPosition(2) + sin(playerDirection) * playerVelocity(1) * timeDelta + 0 * playerAcceleration * sin(playerDirection) * timeDelta * timeDelta;
player{2}(indexOfPlayer,1) = 1;
player{2}(indexOfPlayer,2) = playerDirection;
player{3} = players{3}(indexOfPlayer,:);

updatedPlayer = player;

end

