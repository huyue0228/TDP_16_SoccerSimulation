function [updatedPlayer] = PlayerMovement(players, indexOfPlayer, ball, timeDelta, playerStickPosition, striker1Coefficient,striker2Coefficient,defenderCoefficient)
% Red team tied with blue team

nPlayers=length(players{1});
playerTeam=players{3}(indexOfPlayer);
actionPlayerDistance = 12; % 12-15 seems good
a = 1; % coefficient about position
error = 1; % set an error to limit shaking

playerPosition = players{1}(indexOfPlayer,:);
playerVelocity = players{2}(indexOfPlayer,:);
playerPositions = players{1}(playerTeam*nPlayers/2+(1:nPlayers/2),:);

ballPosition = ball(1,:);
distanceToBall = norm(ballPosition-playerPosition);
distanceToBallForAllTeamMates = vecnorm((ballPosition-playerPositions)');
[~,indexOfPlayerThatWillGoForTheBall]=min(distanceToBallForAllTeamMates);
distanceToOriginalPosition = norm(playerStickPosition(indexOfPlayer,:)-playerPosition);


% GoalKeeper
if indexOfPlayer==nPlayers/2 || indexOfPlayer==nPlayers 
    if (distanceToBall < 1.0*actionPlayerDistance && 1.0*distanceToOriginalPosition < actionPlayerDistance)...
            || indexOfPlayer==indexOfPlayerThatWillGoForTheBall
        playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
    elseif distanceToOriginalPosition <= error
        a = 0;
        playerDirection = players{2}(indexOfPlayer,2);
    else
        playerDirection = atan2(playerStickPosition(indexOfPlayer,2) - playerPosition(2),playerStickPosition(indexOfPlayer,1) - playerPosition(1));
    end
% striker1
elseif indexOfPlayer==1 || indexOfPlayer==5 
    if (distanceToBall < 2.0*striker1Coefficient*actionPlayerDistance && distanceToOriginalPosition < 2.0*striker1Coefficient*actionPlayerDistance)...
            || indexOfPlayer==indexOfPlayerThatWillGoForTheBall
        playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
    elseif distanceToOriginalPosition <= error
        a = 0;
        playerDirection = players{2}(indexOfPlayer,2);
    else
        playerDirection = atan2(playerStickPosition(indexOfPlayer,2) - playerPosition(2),playerStickPosition(indexOfPlayer,1) - playerPosition(1));
    end
% striker2
elseif indexOfPlayer==2 || indexOfPlayer==6 
    if (distanceToBall < 2.0*striker2Coefficient*actionPlayerDistance && distanceToOriginalPosition < 2.0*striker2Coefficient*actionPlayerDistance)...
            || indexOfPlayer==indexOfPlayerThatWillGoForTheBall
        playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
    elseif distanceToOriginalPosition <= error
        a = 0;
        playerDirection = players{2}(indexOfPlayer,2);
    else
        playerDirection = atan2(playerStickPosition(indexOfPlayer,2) - playerPosition(2),playerStickPosition(indexOfPlayer,1) - playerPosition(1));
    end
% defender 
else 
    if (distanceToBall < defenderCoefficient*actionPlayerDistance && distanceToOriginalPosition < defenderCoefficient*actionPlayerDistance)...
            || indexOfPlayer==indexOfPlayerThatWillGoForTheBall
        playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
    elseif distanceToOriginalPosition <= error
        a = 0;
        playerDirection = players{2}(indexOfPlayer,2);
    else
        playerDirection = atan2(playerStickPosition(indexOfPlayer,2) - playerPosition(2),playerStickPosition(indexOfPlayer,1) - playerPosition(1));
    end
end

player{1}(indexOfPlayer,1) = playerPosition(1) + a*cos(playerDirection) * playerVelocity(1) * timeDelta;
player{1}(indexOfPlayer,2) = playerPosition(2) + a*sin(playerDirection) * playerVelocity(1) * timeDelta;
player{2}(indexOfPlayer,1) = 0.5;
player{2}(indexOfPlayer,2) = playerDirection;
player{3} = players{3}(indexOfPlayer,:);

updatedPlayer = player;

end
