function [players, ball] = SimulationSync(players, ball, timeSync, timeDelta, playerOriginalPosition, goalsTeam0, goalsTeam1)
% Main function for syncing the updates of the states of all players and the ball in the game simulation 

% Call the UpdatePlayers helper function to update player and ball states
[updatedPlayers, updatedBall] = UpdatePlayersAndBall(players, ball, timeDelta, playerOriginalPosition, goalsTeam0, goalsTeam1);

% Wait for a specified amount of time for synchronization
pause(timeSync);

% Update the main variables with the new player and ball states
players = updatedPlayers;
ball = updatedBall;

end
