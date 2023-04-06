function isMarked = MarkedPlayers(players,indexOfTarget,playerTeam,markedDistance)
% This function determines if a target player is marked by an opponent based on the input markedDistance threshold

% Inputs:
%   players - Cell array containing the (x, y) coordinates of the players on the field.
%             players{1} is a 2-column matrix with rows representing individual players.
%   indexOfTarget - Integer value representing the index of the target player in the players{1} matrix.
%   playerTeam - Integer value indicating the team of the target player (0 or 1).
%   markedDistance - Numeric value representing the distance threshold to consider a player as marked.
%
% Outputs:
%   isMarked - A logical value (true or false) indicating whether the target player is marked by an opponent.

isMarked=true; % Initialize isMarked as true
nPlayers=length(players{1}); % Get the number of players
d = pdist(players{1}); % Compute the pairwise distances between the players
z = squareform(d); % Convert the distance vector to a square, symmetric distance matrix
z(indexOfTarget,indexOfTarget)=inf; % Set the distance of the target player to itself to infinity

% Check if the minimum distance to a player from the opposite team is greater than the marked distance
if min(z(indexOfTarget,(1-playerTeam)*nPlayers/2+(1:nPlayers/2))) > markedDistance
    isMarked=false; % If condition is true, set isMarked to false
end

end
