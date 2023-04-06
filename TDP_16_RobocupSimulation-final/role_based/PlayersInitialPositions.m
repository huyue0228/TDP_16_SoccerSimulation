function [players,playerOriginalPosition] = PlayersInitialPositions(formation1,formation2,attributes,kickoffTeam,goalsTeam0,goalsTeam1)

nPlayers=sum(formation1)+sum(formation2)+2;
nAttributes=size(attributes,2);

players = {zeros(nPlayers,2),zeros(nPlayers,2),zeros(nPlayers,nAttributes)};
playerOriginalPosition=zeros(nPlayers,2);

if goalsTeam0==goalsTeam1 % Red team tied with blue team
    % Starting Positions team red 0 below
    players{1}(1,:)=[10 -12];
    players{1}(2,:)=[10 12];
    players{1}(3,:)=[-25 0];
    players{1}(4,:)=[-42 0]; %the goalie
    
    playerOriginalPosition(1:nPlayers/2,1)=players{1}(1:nPlayers/2,1);
    playerOriginalPosition(1:nPlayers/2,2)=players{1}(1:nPlayers/2,2);
    
    % Starting Position team blue 1 below
    players{1}(5,:)=[-10 12];
    players{1}(6,:)=[-10 -12];
    players{1}(7,:)=[25 0];
    players{1}(8,:)=[42 0]; %the goalie
    
    playerOriginalPosition(nPlayers/2+1:nPlayers,1)=players{1}(nPlayers/2+1:nPlayers,1);
    playerOriginalPosition(nPlayers/2+1:nPlayers,2)=players{1}(nPlayers/2+1:nPlayers,2);
elseif goalsTeam0>goalsTeam1 % Red team leads blue team
    % Starting Positions team red 0 below
    players{1}(1,:)=[-12 0];
    players{1}(2,:)=[-25 12];
    players{1}(3,:)=[-25 -12];
    players{1}(4,:)=[-42 0]; %the goalie
    
    playerOriginalPosition(1:nPlayers/2,1)=players{1}(1:nPlayers/2,1);
    playerOriginalPosition(1:nPlayers/2,2)=players{1}(1:nPlayers/2,2);
    
    % Starting Position team blue 1 below
    players{1}(5,:)=[-10 12];
    players{1}(6,:)=[-10 -12];
    players{1}(7,:)=[25 0];
    players{1}(8,:)=[42 0]; %the goalie
    
    playerOriginalPosition(nPlayers/2+1:nPlayers,1)=players{1}(nPlayers/2+1:nPlayers,1);
    playerOriginalPosition(nPlayers/2+1:nPlayers,2)=players{1}(nPlayers/2+1:nPlayers,2);
else % Blue team leads red team
    % Starting Positions team red 0 below
    players{1}(1,:)=[10 -12];
    players{1}(2,:)=[10 12];
    players{1}(3,:)=[-25 0];
    players{1}(4,:)=[-42 0]; %the goalie
    
    playerOriginalPosition(1:nPlayers/2,1)=players{1}(1:nPlayers/2,1);
    playerOriginalPosition(1:nPlayers/2,2)=players{1}(1:nPlayers/2,2);
    
    % Starting Position team blue 1 below
    players{1}(5,:)=[12 0];
    players{1}(6,:)=[25 12];
    players{1}(7,:)=[25 -12];
    players{1}(8,:)=[42 0]; %the goalie
    
    playerOriginalPosition(nPlayers/2+1:nPlayers,1)=players{1}(nPlayers/2+1:nPlayers,1);
    playerOriginalPosition(nPlayers/2+1:nPlayers,2)=players{1}(nPlayers/2+1:nPlayers,2);
end

if kickoffTeam==0
    players{1}(nPlayers/2-1,:)=[-2 0]; %striker has index 10
elseif kickoffTeam==1
    players{1}(nPlayers-1,:)=[2 0];
end

%Fixing angles, velocities=0.3 in the begining
players{2}(nPlayers/2+1:end,2)=pi;
players{2}(:,1)=1;

%attributes
players{3}=attributes;
        

end

