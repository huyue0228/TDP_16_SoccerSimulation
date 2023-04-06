function targetPosition = LookForTeammates(players, indexOfPlayer, markedDistance)
% This function chooses a player to pass to based on the distances between players and the availability of a pass.
% Inputs:
%   - players: a 3xN cell array where the first row contains the coordinates of the players, the second row contains the velocities of the players, and the third row contains the team affiliations of the players (0 for team A, 1 for team B).
%   - indexOfPlayer: the index of the player who has the ball.
%   - markedDistance: the maximum distance between the target player and the nearest opponent.
% Output:
%   - targetPosition: the coordinates of the player to pass the ball to.

minPassLength = 5; % Minimum length for a pass to be considered
nPlayers = length(players{1}); % The total number of players on the field
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
            return;
        end
        
        % If no unmarked players are left, return the current target position
        if sum(isnan(distanceToTeamMates)) == nPlayers/2
            return;
        end
        
        % Find the index of the next closest target player
        [~, indexOfTarget] = min(distanceToTeamMates);
        
        % Check if the target player is marked
        isMarked = MarkedPlayers(players, indexOfTarget, playerTeam, markedDistance);
        
        % If the target player is unmarked, set the target position to their position and return it
        if ~isMarked
            targetPosition = players{1}(indexOfTarget + playerTeam*nPlayers/2, :);
            return;
        else
            % Otherwise, exclude the marked player from being a potential target and continue the loop
            distanceToTeamMates(indexOfTarget) = NaN;
        end
    end
end