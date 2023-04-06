function [isGoal,goalsTeam1,goalsTeam2,kickoffTeam] = Scoring(ball,goalsTeam1,goalsTeam2)

isGoal=false;
kickoffTeam=0;

if ball(1,1)>=45 && ball(1,2)>-13 && ball(1,2)<13
    isGoal=true;
    goalsTeam1=goalsTeam1+1;
    kickoffTeam=1; %the other team will kickoff
elseif ball(1,1)<=-45 && ball(1,2)>-13 && ball(1,2)<13
    isGoal=true;
    goalsTeam2=goalsTeam2+1;
    kickoffTeam=0; %the other team will kickoff
end

end

