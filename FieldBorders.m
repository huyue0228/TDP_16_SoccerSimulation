function [ball, players, goal] = FieldBorders(ball, players)

    nPlayers=length(players{1});
    global lastTeamBallPossession;

    % Clamp the ball's position to the field limits
    ball(1,1) = max(min(ball(1,1), 46), -46);
    ball(1,2) = max(min(ball(1,2), 31), -31);

    % Define the cell arrays of messages for different scenarios
    goalMsgs = {'What a fantastic goal', 'Unbelievable goal', 'Amazing goal', 'Incredible goal', 'Spectacular goal', 'What a strike', 'Top-class goal', 'Sublime finish', 'A goal to remember', 'An absolute beauty', 'Stunning effort', 'A moment of brilliance', 'Goal of the season contender', 'Phenomenal goal', 'A screamer from distance'};
    ownGoalMsgs = {'oh no! An own goal', 'an unfortunate own goal', 'a terrible own goal', 'a disastrous own goal', 'a regrettable own goal', 'a heartbreaking own goal', 'an unlucky own goal', 'a painful own goal', 'a miserable own goal', 'a dreadful own goal', 'an embarrassing own goal', 'an unlucky bounce', 'a cruel twist of fate'};
    nearMissMsgs = {'Aww! So close!', 'That was a near miss!', 'Almost a goal!', 'The crowd holds their breath!', 'Just inches away!', 'So unlucky!', 'A narrow escape!', 'That was too close for comfort!', 'A whisker away from a goal!', 'A hair''s breadth from glory!', 'Rattling the woodwork!', 'A fingertip save!', 'Denied by the post!', 'Off the crossbar!', 'A great save by the goalkeeper!'};
    excitedGoal = {'Gooooooooal! ', 'Gooooal! ', 'Goooooal! ', 'Goooooooal! ', 'Gooooooal! ', 'Goooal! ', 'GOOOOOOOOOOOOAL! ', 'GOOOAL! ', 'GOOOOOAL! ', 'GOOOOAL! '};
    outOFBounds  = {'OUT!', 'Out of bounds!', 'The ball is out of the field!', 'The ball just left the field!', 'That is an out!', 'Aww! Out of bounds!'};
    commentators = {'Commentator 1: ', 'Commentator 2: ', 'Commentator 3: '};

    if (abs(ball(1,1))  > 45 || abs(ball(1,2))  > 30)
        if (abs(ball(1,2))  < 13)
                        
            if (ball(1,1) > 0) % Blue Team's goal area
                if (lastTeamBallPossession == 0)
                    MSG = commentators{randi(length(commentators))}+string(excitedGoal{randi(length(excitedGoal))})+string(goalMsgs{randi(length(goalMsgs))})+" by Red Team!"; % Red Team scored a goal
                    disp(MSG)
                    txt = {[sprintf(MSG)]};
                    text(0,-36,txt,'HorizontalAlignment','center')
                else
                    MSG = commentators{randi(length(commentators))}+"Oh man, "+string(ownGoalMsgs{randi(length(ownGoalMsgs))})+" by Blue team!"; % Blue Team accidentally scored a goal on themselves
                    disp(MSG)
                    txt = {[sprintf(MSG)]};
                    text(0,-36,txt,'HorizontalAlignment','center')
                end
            else % Red Team's goal area
                if (lastTeamBallPossession == 1)
                    MSG = commentators{randi(length(commentators))}+string(excitedGoal{randi(length(excitedGoal))})+string(goalMsgs{randi(length(goalMsgs))})+" by Blue Team!"; % Blue Team scored a goal
                    disp(MSG)
                    txt = {[sprintf(MSG)]};                   
                    text(0,-36,txt,'HorizontalAlignment','center')
                else
                    MSG = commentators{randi(length(commentators))}+"Oh man, "+string(ownGoalMsgs{randi(length(ownGoalMsgs))})+" by Red team!"; % Red Team accidentally scored a goal on themselves
                    disp(MSG)
                    txt = {[sprintf(MSG)]};                    
                    text(0,-36,txt,'HorizontalAlignment','center')
                end
            end
            
            %pause(1)
            goal = 1;
            return
        else
            if  ((ball(1,1) < -45) && (abs(ball(1,2)) <= 20) && (abs(ball(1,2)) > 13)) || ((ball(1,1) > 45) && (abs(ball(1,2)) <= 20) && (abs(ball(1,2)) > 13))
                MSG = commentators{randi(length(commentators))} + string(nearMissMsgs{randi(length(nearMissMsgs))}); % Ball is out of bounds close to the goal region but not a goal, show near miss message
                disp(MSG)
                txt = {[sprintf(MSG)]};            
                text(0,-36,txt,'HorizontalAlignment','center')
                %global lastTeamBallPossession;
                otherTeam = -sign(lastTeamBallPossession - 1);
                teamIndex = find(players{3}(:,1) == otherTeam);
                distanceToBall = vecnorm(players{1}(teamIndex,:) - ball(1,:), 2, 2);
                [~, closestPlayer] = min(distanceToBall);
                closestPlayer = teamIndex(closestPlayer);
                pause(1)
                
                if (ball(1,1) > 45)
                    ball(1,1) = 45;
                    if (otherTeam == 0)
                        ball(1,2) = sign(ball(1,2)) * 30;
                    else
                        ball(1,:) = [39.4,0];
                        for i = 1:nPlayers
                            if (players{3}(i,1) == lastTeamBallPossession && players{1}(i,1) > 30)
                                players{1}(i,1) = 30;
                            end
                        end
                    end
                end
                if (ball(1,1) < -45)
                    ball(1,1) = -45;
                    if (otherTeam == 1)
                        ball(1,2) = sign(ball(1,2)) * 30;
                    else
                        ball(1,:) = [-39.4,0];
                        for i = 1:nPlayers
                            if (players{3}(i,1) == lastTeamBallPossession && players{1}(i,1) < -30)
                                players{1}(i,1) = -30;
                            end
                        end
                    end
                end
                if (ball(1,2) > 30)
                    ball(1,2) = 30;
                end
                if (ball(1,2) < -30)
                    ball(1,2) = -30;
                end
                
                ball(2,:) = [0 0];
                ball(3,:) = [0 0];
                players{1}(closestPlayer,:) = ball(1,:);
            else
                MSG = commentators{randi(length(commentators))}+string(outOFBounds{randi(length(outOFBounds))}); % Out of bounds
                disp(MSG)
                txt = {[sprintf(MSG)]};            
                text(0,-36,txt,'HorizontalAlignment','center')
                %global lastTeamBallPossession;
                otherTeam = -sign(lastTeamBallPossession - 1);
                teamIndex = find(players{3}(:,1) == otherTeam);
                distanceToBall = vecnorm(players{1}(teamIndex,:) - ball(1,:), 2, 2);
                [~, closestPlayer] = min(distanceToBall);
                closestPlayer = teamIndex(closestPlayer);
                pause(1)
                
                if (ball(1,1) > 45)
                    ball(1,1) = 45;
                    if (otherTeam == 0)
                        ball(1,2) = sign(ball(1,2)) * 30;
                    else
                        ball(1,:) = [39.4,0];
                        for i = 1:nPlayers
                            if (players{3}(i,1) == lastTeamBallPossession && players{1}(i,1) > 30)
                                players{1}(i,1) = 30;
                            end
                        end
                    end
                end
                if (ball(1,1) < -45)
                    ball(1,1) = -45;
                    if (otherTeam == 1)
                        ball(1,2) = sign(ball(1,2)) * 30;
                    else
                        ball(1,:) = [-39.4,0];
                        for i = 1:nPlayers
                            if (players{3}(i,1) == lastTeamBallPossession && players{1}(i,1) < -30)
                                players{1}(i,1) = -30;
                            end
                        end
                    end
                end
                if (ball(1,2) > 30)
                    ball(1,2) = 30;
                end
                if (ball(1,2) < -30)
                    ball(1,2) = -30;
                end
                
                ball(2,:) = [0 0];
                ball(3,:) = [0 0];
                players{1}(closestPlayer,:) = ball(1,:);
            end
        end
    end
    goal = 0;
end
