function [updatedPlayer] = TiedMovement(players, indexOfPlayer, ball, timeDelta, playerOriginalPosition)
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

if indexOfPlayer==nPlayers/2 || indexOfPlayer==nPlayers % goalie
    if (distanceToBall < 1.0*actionPlayerDistance && 1.0*distanceToOriginalPosition < actionPlayerDistance)...
            || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
        playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
    elseif distanceToOriginalPosition <= error
        a = 0;
        playerDirection = players{2}(indexOfPlayer,2);
    else
        playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
    end

elseif indexOfPlayer==1 || indexOfPlayer==5 % striker1
    if (distanceToBall < 2.0*actionPlayerDistance && distanceToOriginalPosition < 2.0*actionPlayerDistance)...
            || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
        playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
    elseif distanceToOriginalPosition <= error
        a = 0;
        playerDirection = players{2}(indexOfPlayer,2);
    else
        playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
    end

elseif indexOfPlayer==2 || indexOfPlayer==6 % striker2
    if (distanceToBall < 1.0*actionPlayerDistance && distanceToOriginalPosition < 1.0*actionPlayerDistance)...
            || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
        playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
    elseif distanceToOriginalPosition <= error
        a = 0;
        playerDirection = players{2}(indexOfPlayer,2);
    else
        playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
    end
 
else % defender
    if (distanceToBall < 1.0*actionPlayerDistance && distanceToOriginalPosition < 1.0*actionPlayerDistance)...
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
player{2}(indexOfPlayer,1) = 1;
player{2}(indexOfPlayer,2) = playerDirection;
player{3} = players{3}(indexOfPlayer,:);

updatedPlayer = player;

end

