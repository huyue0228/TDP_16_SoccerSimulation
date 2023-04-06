function [players,playerOriginalPosition] = PlayersInitialPositions(formation1,formation2,attributes,kickoffTeam)

nPlayers=sum(formation1)+sum(formation2)+2;
epsillon=1/10;
nAttributes=size(attributes,2);

players = {zeros(nPlayers,2),zeros(nPlayers,2),zeros(nPlayers,nAttributes)};
playerOriginalPosition=zeros(nPlayers,2);

% Starting Positions team red 0 below
players{1}(1,:)=[-25 0];
players{1}(2,:)=[10 12];
players{1}(3,:)=[10 -12];
players{1}(4,:)=[-42 0]; %the goalie

playerOriginalPosition(1:nPlayers/2,1)=players{1}(1:nPlayers/2,1);
playerOriginalPosition(1:nPlayers/2,2)=players{1}(1:nPlayers/2,2);

% Starting Position team blue 1 below
players{1}(5,:)=[25 0];
players{1}(6,:)=[-10 12];
players{1}(7,:)=[-10 -12];
players{1}(8,:)=[42 0]; %the goalie

playerOriginalPosition(nPlayers/2+1:nPlayers,1)=players{1}(nPlayers/2+1:nPlayers,1);
playerOriginalPosition(nPlayers/2+1:nPlayers,2)=players{1}(nPlayers/2+1:nPlayers,2);

players{1}(nPlayers/2+1:nPlayers,2)=players{1}(nPlayers/2+1:nPlayers,2)+epsillon;

% players{1}=[players{1}(1:nPlayers/2,:); -players{1}(1:nPlayers/2,:)];
if kickoffTeam==0
    players{1}(nPlayers/2-1,:)=[-2 0]; %striker has index 10
elseif kickoffTeam==1
    players{1}(nPlayers-1,:)=[2 0];
end

%Fixing angles, velocities=0.03 in the begining
players{2}(nPlayers/2+1:end,2)=pi;
players{2}(:,1)=0;

%attributes
players{3}=attributes;
        
end

