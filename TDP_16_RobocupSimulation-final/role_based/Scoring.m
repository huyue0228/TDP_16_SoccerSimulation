function [isGoal,goalsTeam0,goalsTeam1,kickoffTeam] = Scoring(ball,goalsTeam0,goalsTeam1)

isGoal=false;
kickoffTeam=0;

if ball(1,1)>=45 && ball(1,2)>-13 && ball(1,2)<13
    isGoal=true;
    goalsTeam0=goalsTeam0+1;
    kickoffTeam=1; %the other team will kickoff
elseif ball(1,1)<=-45 && ball(1,2)>-13 && ball(1,2)<13
    isGoal=true;
    goalsTeam1=goalsTeam1+1;
    kickoffTeam=0; %the other team will kickoff
end

end

