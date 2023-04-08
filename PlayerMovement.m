function [updatedPlayer] = PlayerMovement(players, indexOfPlayer, ball, timeDelta, playerOriginalPosition, strikerCoefficient,defenderCoefficient)
% Red team tied with blue team

nPlayers=length(players{1});
playerTeam=players{3}(indexOfPlayer);
actionPlayerDistance = 15; % 12-15 seems good
a = 1; % coefficient about position
error = 1; % set an error to limit shacking

playerPosition = players{1}(indexOfPlayer,:);
playerVelocity = players{2}(indexOfPlayer,:);
playerPositions = players{1}(playerTeam*nPlayers/2+(1:nPlayers/2),:);

ballPosition = ball(1,:);
distanceToBall = norm(ballPosition-playerPosition);
distanceToBallForAllTeamMates = vecnorm((ballPosition-playerPositions)');
[~,indexOfPlayerThatWillGoForTheBall]=min(distanceToBallForAllTeamMates);
distanceToOriginalPosition = norm(playerOriginalPosition(indexOfPlayer,:)-playerPosition);


% GoalKeeper
if indexOfPlayer==nPlayers/2 || indexOfPlayer==nPlayers 
    if (distanceToBall < 1.0*actionPlayerDistance && 1.0*distanceToOriginalPosition < actionPlayerDistance)...
            || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
        playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
    elseif distanceToOriginalPosition <= error
        a = 0;
        playerDirection = players{2}(indexOfPlayer,2);
    else
        playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
    end
% striker1
elseif indexOfPlayer==1 || indexOfPlayer==5 
    if (distanceToBall < 2.0*strikerCoefficient*actionPlayerDistance && distanceToOriginalPosition < 2.0*strikerCoefficient*actionPlayerDistance)...
            || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
        playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
    elseif distanceToOriginalPosition <= error
        a = 0;
        playerDirection = players{2}(indexOfPlayer,2);
    else
        playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
    end
% striker2
elseif indexOfPlayer==2 || indexOfPlayer==6 
    if (distanceToBall < 1.0*strikerCoefficient*actionPlayerDistance && distanceToOriginalPosition < 1.0*strikerCoefficient*actionPlayerDistance)...
            || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
        playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
    elseif distanceToOriginalPosition <= error
        a = 0;
        playerDirection = players{2}(indexOfPlayer,2);
    else
        playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
    end
% defender 
else 
    if (distanceToBall < defenderCoefficient*actionPlayerDistance && distanceToOriginalPosition < defenderCoefficient*actionPlayerDistance)...
            || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
        playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
    elseif distanceToOriginalPosition <= error
        a = 0;
        playerDirection = players{2}(indexOfPlayer,2);
    else
        playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
    end
end



player{1}(indexOfPlayer,1) = playerPosition(1) + a*cos(playerDirection) * playerVelocity(1) * timeDelta;
player{1}(indexOfPlayer,2) = playerPosition(2) + a*sin(playerDirection) * playerVelocity(1) * timeDelta;
player{2}(indexOfPlayer,1) = 0.5;
player{2}(indexOfPlayer,2) = playerDirection;
player{3} = players{3}(indexOfPlayer,:);

updatedPlayer = player;

end

