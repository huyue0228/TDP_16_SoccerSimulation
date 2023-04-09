function [updatedPlayers, updatedBall] = UpdatePlayersAndBall(players, ball, timeDelta, playerOriginalPosition, goalsTeam0, goalsTeam1)
% This function updates the state of all the players and the ball

particleRadius = 2; % set the radius of the particle
nAttributes = size(players{3},2); % get the number of attributes of each player
nPlayers = size(players{1},1); % get the number of players
updatedPlayers = {zeros(nPlayers,2), zeros(nPlayers,2),  zeros(nPlayers,nAttributes)}; % create a cell array to store the updated state of each player

for indexOfPlayer = 1:nPlayers % iterate over each player
    [updatedPlayer, updatedBall] = UpdatePlayerState(players, ball, indexOfPlayer, timeDelta, playerOriginalPosition, goalsTeam0, goalsTeam1); % update the state of the current player
    updatedPlayers{1}(indexOfPlayer,:) = updatedPlayer{1}(indexOfPlayer,:); % store the updated position of the current player
    updatedPlayers{2}(indexOfPlayer,:) = updatedPlayer{2}(indexOfPlayer,:); % store the updated velocity of the current player
    updatedPlayers{3}(indexOfPlayer,:) = updatedPlayer{3}; % store the updated attributes of the current player
    ball=updatedBall; % update the state of the ball
end

% update the position of the ball based on its current state and velocity
frictionCoefficient=0.75; %less than 1

updatedBall(1,1)=ball(1,1)+ball(2,1)*timeDelta;     % Update the x axis position of the ball
updatedBall(1,2)=ball(1,2)+ball(2,2)*timeDelta;     % Update the y axis position of the ball 
updatedBall(2,1)=frictionCoefficient*ball(2,1);     % Update the x axis velocity of the ball with the added friction
updatedBall(2,2)=frictionCoefficient*ball(2,2);     % Update the x axis velocity of the ball with the added friction

[updatedPlayers{1}(:,1),updatedPlayers{1}(:,2),updatedBall] = PlayersAndBallCollisions(updatedPlayers{1}(:,1),updatedPlayers{1}(:,2),updatedBall,particleRadius); % update the positions of the players and ball after collisions
end
