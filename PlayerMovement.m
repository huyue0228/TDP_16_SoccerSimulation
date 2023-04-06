function [updatedPlayer] = PlayerMovement(players, indexOfPlayer, ball, timeDelta, playerOriginalPosition, goalsTeam0, goalsTeam1)
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

if goalsTeam0==goalsTeam1 % tied 
    % goalie
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
        if (distanceToBall < 2.0*actionPlayerDistance && distanceToOriginalPosition < 2.0*actionPlayerDistance)...
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
        if (distanceToBall < 1.0*actionPlayerDistance && distanceToOriginalPosition < 1.0*actionPlayerDistance)...
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

% blue team leads red team
elseif goalsTeam0>goalsTeam1
    % goalie
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
    % red team
    % striker1
    elseif indexOfPlayer==1 
        if (distanceToBall < 2.0*actionPlayerDistance && distanceToOriginalPosition < 2.0*actionPlayerDistance)...
                || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
            playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
        elseif distanceToOriginalPosition <= error
            a = 0;
            playerDirection = players{2}(indexOfPlayer,2);
        else
            playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
        end
    % striker2
    elseif indexOfPlayer==2 
        if (distanceToBall < 2.0*actionPlayerDistance && distanceToOriginalPosition < 2.0*actionPlayerDistance)...
                || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
            playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
        elseif distanceToOriginalPosition <= error
            a = 0;
            playerDirection = players{2}(indexOfPlayer,2);
        else
            playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
        end
    % defender
    elseif indexOfPlayer==3 
        if (distanceToBall < 1.0*actionPlayerDistance && distanceToOriginalPosition < 1.0*actionPlayerDistance)...
                || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
            playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
        elseif distanceToOriginalPosition <= error
            a = 0;
            playerDirection = players{2}(indexOfPlayer,2);
        else
            playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
        end
    
    % blue team
    % striker1
    elseif indexOfPlayer==5 
        if (distanceToBall < 2.0*actionPlayerDistance && distanceToOriginalPosition < 1.0*actionPlayerDistance)...
                || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
            playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
        elseif distanceToOriginalPosition <= error
            a = 0;
            playerDirection = players{2}(indexOfPlayer,2);
        else
            playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
        end
    % striker2
    elseif indexOfPlayer==6 
        if (distanceToBall < 1.0*actionPlayerDistance && distanceToOriginalPosition < 1.0*actionPlayerDistance)...
                || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
            playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
        elseif distanceToOriginalPosition <= error
            a = 0;
            playerDirection = players{2}(indexOfPlayer,2);
        else
            playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
        end
    % defender 
    elseif indexOfPlayer==7 
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
% red team leads blue team
else 
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
    % red team
    % striker1
    elseif indexOfPlayer==1 
        if (distanceToBall < 1.5*actionPlayerDistance && distanceToOriginalPosition < 1.5*actionPlayerDistance)...
                || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
            playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
        elseif distanceToOriginalPosition <= error
            a = 0;
            playerDirection = players{2}(indexOfPlayer,2);
        else
            playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
        end
    % striker2
    elseif indexOfPlayer==2 
        if (distanceToBall < 3.0*actionPlayerDistance && distanceToOriginalPosition < 3.0*actionPlayerDistance)...
                || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
            playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
        elseif distanceToOriginalPosition <= error
            a = 0;
            playerDirection = players{2}(indexOfPlayer,2);
        else
            playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
        end
    % defender 
    elseif indexOfPlayer==3 
        if (distanceToBall < 1.0*actionPlayerDistance && distanceToOriginalPosition < 1.0*actionPlayerDistance)...
                || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
            playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
        elseif distanceToOriginalPosition <= error
            a = 0;
            playerDirection = players{2}(indexOfPlayer,2);
        else
            playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
        end
        
    % blue team
    % striker1
    elseif indexOfPlayer==5 
        if (distanceToBall < 1.5*actionPlayerDistance && distanceToOriginalPosition < 1.5*actionPlayerDistance)...
                || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
            playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
        elseif distanceToOriginalPosition <= error
            a = 0;
            playerDirection = players{2}(indexOfPlayer,2);
        else
            playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
        end
    % striker2
    elseif indexOfPlayer==6 
        if (distanceToBall < 3.0*actionPlayerDistance && distanceToOriginalPosition < 3.0*actionPlayerDistance)...
                || indexOfPlayer==(indexOfPlayerThatWillGoForTheBall+playerTeam*nPlayers/2)
            playerDirection = atan2(ballPosition(2) - playerPosition(2),ballPosition(1) - playerPosition(1));
        elseif distanceToOriginalPosition <= error
            a = 0;
            playerDirection = players{2}(indexOfPlayer,2);
        else
            playerDirection = atan2(playerOriginalPosition(indexOfPlayer,2) - playerPosition(2),playerOriginalPosition(indexOfPlayer,1) - playerPosition(1));
        end
    % defender 
    elseif indexOfPlayer==7 
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
end

player{1}(indexOfPlayer,1) = playerPosition(1) + a*cos(playerDirection) * playerVelocity(1) * timeDelta;
player{1}(indexOfPlayer,2) = playerPosition(2) + a*sin(playerDirection) * playerVelocity(1) * timeDelta;
player{2}(indexOfPlayer,1) = 0.5;
player{2}(indexOfPlayer,2) = playerDirection;
player{3} = players{3}(indexOfPlayer,:);

updatedPlayer = player;

end

