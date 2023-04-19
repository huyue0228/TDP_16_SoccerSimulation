%% Main Game File %%
% 20 Minutes Full Match 

clear           % Clearing variables
clf             % Clearing figures
clc             % Clearing commands
close all       % Closing figures
clear sound;    % Clear the sound playing

% Declaring some global variables that hold the game statistics
global totalPossession; global targetedKicksRed; global targetedKicksBlue; global playerKicksBlue1; global playerKicksBlue2; global playerKicksBlue3; global playerKicksBlue4; global playerPossessionBlue1; global playerPossessionBlue2; global playerPossessionBlue3; global playerPossessionBlue4; global teamKicksBlue; global teamPossessionBlue; global playerKicksRed1; global playerKicksRed2; global playerKicksRed3; global playerKicksRed4; global playerPossessionRed1; global playerPossessionRed2; global playerPossessionRed3; global playerPossessionRed4; global teamKicksRed; global teamPossessionRed; global KickCounterForAudioCues;
totalPossession  = 0; targetedKicksRed = 0; targetedKicksBlue = 0; playerKicksBlue1 = 0;  playerKicksBlue2 = 0;  playerKicksBlue3 = 0;  playerKicksBlue4 = 0;  playerPossessionBlue1 = 0;  playerPossessionBlue2 = 0;  playerPossessionBlue3 = 0;  playerPossessionBlue4 = 0; teamKicksBlue = 0;  teamPossessionBlue = 0; playerKicksRed1 = 0;  playerKicksRed2 = 0;  playerKicksRed3 = 0;  playerKicksRed4 = 0;  playerPossessionRed1 = 0;  playerPossessionRed2 = 0;  playerPossessionRed3 = 0;  playerPossessionRed4 = 0; teamKicksRed = 0;  teamPossessionRed = 0; KickCounterForAudioCues = 0;

% Initialzing game variables
field = [90 60];
kickoffTeamStart = randi([0, 1]);                               % For Red team use 0, for Blue team use 1
kickoffTeam = kickoffTeamStart;                                 % To display which team won the coin flip 
formation1 = [1 2];                                             % A defender and two attackers 
formation2 = [1 2];                                             % A defender and two attackers 
nPlayers = sum(formation1)+sum(formation2)+2;                   % We add two extra players as goalkeepers for each team
attributes = [zeros(nPlayers/2,1); ones(nPlayers/2,1)];         % To differentiate between the two teams' players, for Red team use 0, for Blue team use 1

startPositionBall = [0;0];  % Start position of the ball in the center of the field 
startVelBall = [0;0];       % Start velocity of the ball is initialized as zero (standing still)
startAccBall = [0;0];       % Start acceleration of the ball is initialized as zero

goalsTeam0 = 0;             % Initialize the current score as zero for the Red team
goalsTeam1 = 0;             % Initialize the current score as zero for the Blue team

timeDelta = 1;              % The gametime elapsed between every update
timeSync = 0.01;            % Time between drawing of each plot

% With these settings one simulation will take around 20 minutes (each half of the match will take around 10 minutes)
MatchFlag = 0;                  % For simulating the full match
HalfMatchFlag = 0;              % For each half of the match's while loop condition
HalfMatchFlagGame = 0;          % For creating the gameplay for each half of the match
t = tic();                      % For timing the whole simulation nonstop
t1 = tic();                     % For timing the first half of the match
time2 = 0;                      % For timing the second half of the match (to enable the time to be resetted to 0 for each half)
xtime = 5;                      % For timing the text messages by the commentary team
IncrementPeriod = 30;           % For incrementing the xtime variable every 30 seconds
ATflag = randi([0,1]);          % For adding extra time at the end of each half
fh = figure();                  % Naming the figure for further manipulation
fh.WindowState = 'maximized';   % Forcing the figure to be in full screen mode

% Define the cell arrays of messages for different scenarios
goodSupportiveMsgs = {'''s defense is looking solid!', '''s midfield is controlling the game!', '''s striker is having a great game!', '''s goalkeeper is keeping them in the match!', '''s coach will be pleased with their performance so far.', ' is really dominating the possession!', '''s passing is a joy to watch!', '''s defense is holding strong!', ' is looking like the stronger side right now!', ' is showing why they are a top team in the league!'};
badCritiquingMsgs = {' needs to step up their game if they want to win.', ' is struggling to get into the game.', '''s manager might need to make some changes.', ' needs to take more risks and attack more.', '''s supporters are getting restless!'};
commentaryMidGame = {'This is shaping up to be a thrilling match!', 'Both teams are playing some great soccer.', 'This is a very entertaining match!', 'The atmosphere in the stadium is electric!', 'This match is living up to its billing.', 'Both teams are showing great determination.', 'The pace of the game has been relentless!', 'This has been a physical encounter.', 'It''s been an end-to-end contest!', 'The players are giving their all.', 'The tactical battle between the managers is fascinating.', 'We''re witnessing some exceptional football!', 'The midfield battle is crucial today.', 'The defense has been solid!', 'Both goalkeepers have been in fine form.', 'A moment of individual brilliance could decide this match!', 'The substitutes could make a real impact.', 'The weather conditions may play a role.', 'We''re seeing some great off-the-ball movement!', 'The crowd is really getting behind their team.', 'The level of skill on display is outstanding!', 'The pressing game from both teams is impressive.', 'This match could go either way!', 'It''s difficult to predict who will come out on top.', 'A mistake could prove costly for either side.', 'Both teams are showing great discipline.', 'The tempo of the match has been high!', 'Fitness levels will be tested in this game.', 'The players are leaving everything on the field.', 'The commitment from both sides is commendable!', 'The manager is urging his team forward.', 'The players are receiving instructions from the bench.', 'There''s a lot of activity on the touchline!', 'The atmosphere is tense in the technical area.', 'The manager is clearly not happy with that decision.'};
halfTimeMsgs = {'And it''s half-time here at the stadium.', 'The referee blows the whistle for half-time.', 'Both teams head into the break.', 'An entertaining first half comes to a close.', 'Time for a well-earned break.', 'The players will be eager to regroup.', 'What a thrilling first half!', 'The managers will have a lot to discuss.', 'A chance for both teams to catch their breath.', 'We look forward to the second half.', 'An intriguing first half sets the stage for a captivating second half.', 'The players have given their all in the first half.', 'Half-time offers an opportunity for the teams to reassess their strategies.', 'The fans eagerly await the second half.', 'The players are staying hydrated during the break.'};
commentators = {'Commentator 1: ', 'Commentator 2: ', 'Commentator 3: '};
MSG = commentators{randi(length(commentators))}+string(commentaryMidGame{randi(length(commentaryMidGame))}); % Mid-game commentary first message
%disp(MSG)
MSG1 = commentators{randi(length(commentators))}+"The Red team"+string(goodSupportiveMsgs{randi(length(goodSupportiveMsgs))}); % Supportive commentary for the Red team first message
%disp(MSG1)                        
MSG2 = commentators{randi(length(commentators))}+"The Blue team"+string(badCritiquingMsgs{randi(length(badCritiquingMsgs))}); % Critiqing commentary for the Blue team first message
%disp(MSG2)                         
MSG3 = commentators{randi(length(commentators))}+"The Blue team"+string(goodSupportiveMsgs{randi(length(goodSupportiveMsgs))}); % Supportive commentary for the Blue team first message
%disp(MSG3)                        
MSG4 = commentators{randi(length(commentators))}+"The Red team"+string(badCritiquingMsgs{randi(length(badCritiquingMsgs))}); % Critiqing commentary for the Red team first message
%disp(MSG4)                          
pause(1)

while MatchFlag ~= 1
    whistle = randi([0, 2]);
    if whistle ==  0
        [x,fs] = audioread('Whistle1.wav');
        sound(x, fs)
    elseif whistle == 1
        [x,fs] = audioread('Whistle2.wav');
        sound(x, fs)
    elseif whistle == 2
        [x,fs] = audioread('Whistle3.wav');
        sound(x, fs)
    end
    crowd = randi([0, 1]);
    if crowd ==  0
        [x,fs] = audioread('Crowd1.wav');
        sound(x, fs)
    elseif crowd == 1
        [x,fs] = audioread('Crowd2.wav');
        sound(x, fs)
    end
    if HalfMatchFlag == 1     
        if time1 >= 600 && time1 < 600+AddedTime1
            % Keepign the final plot with its attributes (ball position, players positions, the time, and the goals)
            clf                         % Clear the current figure
            PlotTheField(field)         % Plot the soccer field
            PlotThePlayers(players)     % Plot the players
            
            % Check which team has won or if it is a tie, and display the appropriate text
            if goalsTeam0 > goalsTeam1 % If Red team is ahead
                if goalsTeam0 == 1
                    txt = {[sprintf('%02d',min1) ':' sprintf('%02d',sec1) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('What a goal! That was a great final push!')],[sprintf('Red team is currently leading with %d goal!', goalsTeam0)]};
                    text(0,42,txt,'HorizontalAlignment','center')
                else
                    txt = {[sprintf('%02d',min1) ':' sprintf('%02d',sec1) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('What a goal! That was a great final push!')],[sprintf('Red team is currently leading with %d goals!', goalsTeam0)]};
                    text(0,42,txt,'HorizontalAlignment','center')
                end
            elseif goalsTeam1 > goalsTeam0 % If Blue team is ahead
                if goalsTeam1 == 1
                    txt = {[sprintf('%02d',min1) ':' sprintf('%02d',sec1) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('What a goal! That was a great final push!')],[sprintf('Blue team is currently leading with %d goal!', goalsTeam1)]};
                    text(0,42,txt,'HorizontalAlignment','center')
                else
                    txt = {[sprintf('%02d',min1) ':' sprintf('%02d',sec1) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('What a goal! That was a great final push!')],[sprintf('Blue team is currently leading with %d goals!', goalsTeam1)]};
                    text(0,42,txt,'HorizontalAlignment','center')
                end  
            elseif goalsTeam0 == goalsTeam1 % If it is a tie
                if goalsTeam0 == 1 && goalsTeam1 == 1
                    txt = {[sprintf('%02d',min1) ':' sprintf('%02d',sec1) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('What a goal! That was a great final push!')],[sprintf('So far it''s a tie with %d goal to %d goal for Red team and Blue team, respectively!', goalsTeam0, goalsTeam1)]};
                    text(0,42,txt,'HorizontalAlignment','center')
                else
                    txt = {[sprintf('%02d',min1) ':' sprintf('%02d',sec1) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('What a goal! That was a great final push!')],[sprintf('So far it''s a tie with %d goals to %d goals for Red team and Blue team, respectively!', goalsTeam0, goalsTeam1)]};
                    text(0,42,txt,'HorizontalAlignment','center')  
                end
            end
            % Calculating and displaying the statistics of the first half of the match
            RedTeamTotalPossession = round((teamPossessionRed/totalPossession)*100, 2);
            BlueTeamTotalPossession = round((teamPossessionBlue/totalPossession)*100, 2);
            
            txt = {[sprintf("First Half Statistics:")],[sprintf("Red Team                  -                   Blue Team")],[sprintf("%d                Possession                %d",teamPossessionRed,teamPossessionBlue)],[sprintf("%g%%      Possession Percentage       %g%%",RedTeamTotalPossession,BlueTeamTotalPossession)],[sprintf("%d             Targeted Kicks              %d",targetedKicksRed,targetedKicksBlue)],[sprintf("%d             Team Kicks              %d",teamKicksRed,teamKicksBlue)],[sprintf("Players Statistics:")],[sprintf("%d             Possessions Player 1              %d",playerPossessionRed1,playerPossessionBlue1)],[sprintf("%d             Possessions Player 2              %d",playerPossessionRed2,playerPossessionBlue2)],[sprintf("%d             Possessions Player 3              %d",playerPossessionRed3,playerPossessionBlue3)],[sprintf("%d             Possessions Player 4              %d",playerPossessionRed4,playerPossessionBlue4)],[sprintf("%d             Kicks Player 1              %d",playerKicksRed1,playerKicksBlue1)],[sprintf("%d             Kicks Player 2              %d",playerKicksRed2,playerKicksBlue2)],[sprintf("%d             Kicks Player 3              %d",playerKicksRed3,playerKicksBlue3)],[sprintf("%d             Kicks Player 4              %d",playerKicksRed4,playerKicksBlue4)]};
            text(0,10,txt,'HorizontalAlignment','center') 

            MSG = commentators{randi(length(commentators))}+string(halfTimeMsgs{randi(length(halfTimeMsgs))}); % Half-time commentary
            disp(MSG)
            txt = {[sprintf(MSG)]};
            text(0,-33,txt,'HorizontalAlignment','center')
            pause(10)
            whistle2 = randi([0, 2]);
            if whistle2 ==  0
                [x,fs] = audioread('Whistle1.wav');
                sound(x, fs)
            elseif whistle2 == 1
                [x,fs] = audioread('Whistle2.wav');
                sound(x, fs)
            elseif whistle2 == 2
                [x,fs] = audioread('Whistle3.wav');
                sound(x, fs)
            end
            crowd = randi([0, 1]);
            if crowd ==  0
                [x,fs] = audioread('Crowd1.wav');
                sound(x, fs)
            elseif crowd == 1
                [x,fs] = audioread('Crowd2.wav');
                sound(x, fs)
            end
            
        end
        FirstHalfgoalsRedTeam = goalsTeam0;             % Store the current score to the first half score as zero for the red team
        FirstHalfgoalsBlueTeam = goalsTeam1;            % Initialize the first half score as zero for the blue team
        kickoffTeamStartSH = abs(kickoffTeamStart-1);   % For flipping to the other team at the start of the second half 
        kickoffTeam = kickoffTeamStartSH;               % To display which team
        ATflag = randi([0,1]);                          % For adding extra time at the end of each half
        xtime = 5;                                      % For timing the text messages by the commentary team
        IncrementPeriod = 30;                           % For incrementing the xtime variable every 30 seconds
        t2 = tic();                                     % For timing the second half of the match in the simulation
        HalfMatchFlag = 0;                              % Reset the half time flag to start the second half
        HalfMatchFlagGame = 1;                          % Set the half match flag as 1 to trigger the second half's gameplay
    end
    % Initialize a while loop that will run for the half of the match
    while HalfMatchFlag ~= 1
        Goal = false; % Initialize the goal flag to false for each new round
        
        % Reset the ball and player attributes to their initial values for each new round
        ball = BallInitialPosition(startPositionBall, startVelBall, startAccBall);
        [players, playerOriginalPosition, playerStickPosition] = PlayersInitialPositions(formation1, formation2, attributes, kickoffTeam, goalsTeam0, goalsTeam1);
        pause(1); % Pause for 1 second before starting the round
        
        if HalfMatchFlagGame == 0 % Gameplay for the first half of the match
            % Create a while loop that runs until a goal is scored
            while Goal == false
        
                % Update player and ball positions based on time elapsed
                [players, ball] = SimulationSync(players, ball, timeSync, timeDelta, playerOriginalPosition, goalsTeam0, goalsTeam1);
                playerOriginalPosition = playerStickPosition;
                % Plot the playing field, players, and ball on the figure window
                PlotTheField(field)
                PlotThePlayers(players)
                PlotTheBall(ball)
                % Check if the ball has crossed the field boundaries and adjust its position accordingly
                [ball, players, goal] = FieldBorders(ball, players);
                
                % Check if a goal has been scored and update the goal flag and score accordingly
                [Goal, goalsTeam0, goalsTeam1, kickoffTeam] = Scoring(ball, goalsTeam0, goalsTeam1);
                
                % Update the time elapsed and format it as minutes, seconds, and milliseconds
                time1 = toc(t1);
                min1 = floor(time1 / 60);
                sec1 = floor(time1 - min1 * 60);
                msec1 = floor((time1 - floor(time1)) * 1000);
                
                % Display a message indicating which team will start with the ball based on a coin toss
                if kickoffTeamStart == 0 && time1 < 10
                    txt = {[sprintf('After flipping a coin, Red team will start with the ball for the first half of the match!')]};
                    text(0,39,txt,'HorizontalAlignment','center')
                elseif kickoffTeamStart == 1 && time1 < 10
                    txt = {[sprintf('After flipping a coin, Blue team will start with the ball for the first half of the match!')]};
                    text(0,39,txt,'HorizontalAlignment','center')
                end 
                
                % Add some live commentary to the game
                if (sec1 >= 5 && sec1 <= 15) || (sec1 >= 25 && sec1 <= 35)
                    if (time1 >= xtime && time1 <= (xtime+0.15)) || (time1 >= (xtime+20) && time1 <= (xtime+20.15))
                        MSG = commentators{randi(length(commentators))}+string(commentaryMidGame{randi(length(commentaryMidGame))}); % Mid-game commentary
                        disp(MSG)
                        if (time1 >= xtime && time1 <= xtime+0.10)
                            clear sound;
                            [x,fs] = audioread('OleChantWithDrums.wav');
                            sound(x, fs)
                        end
                        if goalsTeam0 > goalsTeam1 % If Red team is ahead
                            MSG1 = commentators{randi(length(commentators))}+"The Red team"+string(goodSupportiveMsgs{randi(length(goodSupportiveMsgs))}); % Supportive commentary for the Red team
                            disp(MSG1)                        
                            MSG2 = commentators{randi(length(commentators))}+"The Blue team"+string(badCritiquingMsgs{randi(length(badCritiquingMsgs))}); % Critiqing commentary for the Blue team
                            disp(MSG2)                         
                        elseif goalsTeam1 > goalsTeam0 % If Blue team is ahead
                            MSG3 = commentators{randi(length(commentators))}+"The Blue team"+string(goodSupportiveMsgs{randi(length(goodSupportiveMsgs))}); % Supportive commentary for the Blue team
                            disp(MSG3)                        
                            MSG4 = commentators{randi(length(commentators))}+"The Red team"+string(badCritiquingMsgs{randi(length(badCritiquingMsgs))}); % Critiqing commentary for the Red team
                            disp(MSG4)                          
                        end
                    end
                    if (sec1 >= 5 && sec1 <= 8) || (sec1 >= 25 && sec1 <= 28)
                        txt = {[sprintf(MSG)]};
                        text(0,-33,txt,'HorizontalAlignment','center')
                    elseif (sec1 > 8 && sec1 <= 15) || (sec1 > 28 && sec1 <= 35)
                        if goalsTeam0 > goalsTeam1 % If Red team is ahead
                            if (sec1 > 8 && sec1 <= 11) || (sec1 > 28 && sec1 <= 31)
                                txt = {[sprintf(MSG1)]};
                                text(0,-35,txt,'HorizontalAlignment','center')
                            elseif (sec1 > 11 && sec1 <= 15) || (sec1 > 31 && sec1 <= 35)
                                txt = {[sprintf(MSG2)]};
                                text(0,-37,txt,'HorizontalAlignment','center')
                            end
                        elseif goalsTeam1 > goalsTeam0 % If Blue team is ahead
                            if (sec1 > 8 && sec1 <= 11) || (sec1 > 28 && sec1 <= 31)
                                txt = {[sprintf(MSG3)]};
                                text(0,-35,txt,'HorizontalAlignment','center')
                            elseif (sec1 > 11 && sec1 <= 15) || (sec1 > 31 && sec1 <= 35)
                                txt = {[sprintf(MSG4)]};
                                text(0,-37,txt,'HorizontalAlignment','center')
                            end
                        end
                    end
                end
                if time1 >= IncrementPeriod
                    xtime = xtime + 30; % Increment x by 20            
                    % Update the next increment period
                    IncrementPeriod = IncrementPeriod + 30;
                end
                % Display the current time and score
                if time1 < 600
                    txt = {[sprintf('%02d',min1) ':' sprintf('%02d',sec1) ':' sprintf('%02d',rem(msec1, 100))],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf("1st half of the match")]};
                    text(0,43,txt,'HorizontalAlignment','center')
                elseif time1 >= 600
                    % If more than 10 miuntes have elapsed, add extra time (half a minute or a minute and a half for a final push)
                    if ATflag == 0
                        AddedTime1 = 30; % Add half a minute for the final push
                    elseif ATflag == 1
                        AddedTime1 = 60; % Add a minute for the final push
                    end                
                    HalfMatchFlag = 1; % set the flag to 1 to trigger the while loop breaking condition
                    txt = {[sprintf('10') ':' sprintf('00') ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('Time''s up for the first half of the match! Extra time up to %d seconds is now added for the final push!', AddedTime1)]};
                    text(0,43,txt,'HorizontalAlignment','center')
                    txt = {[sprintf(' +') sprintf('00') ':' sprintf('%02d',sec1) ':' sprintf('%02d',rem(msec1, 100))]};
                    text(10,45.2,txt,'HorizontalAlignment','center')
                    if time1 >= 600+AddedTime1
                        % Keepign the final plot with its attributes (ball position, players positions, the time, and the goals)
                        clf                         % Clear the current figure
                        PlotTheField(field)         % Plot the soccer field
                        PlotThePlayers(players)     % Plot the players
                        
                        % Check which team has won or if it is a tie, and display the appropriate text
                        if goalsTeam0 > goalsTeam1 % If Red team is ahead
                            if goalsTeam0 == 1
                                txt = {[sprintf('%02d',min1) ':' sprintf('%02d',sec1) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('Time''s up for the first half of the match! The referee just blew the whistle!')],[sprintf('Red team is currently leading with %d goal!', goalsTeam0)]};
                                text(0,42,txt,'HorizontalAlignment','center')
                            else
                                txt = {[sprintf('%02d',min1) ':' sprintf('%02d',sec1) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('Time''s up for the first half of the match! The referee just blew the whistle!')],[sprintf('Red team is currently leading with %d goals!', goalsTeam0)]};
                                text(0,42,txt,'HorizontalAlignment','center')
                            end
                        elseif goalsTeam1 > goalsTeam0 % If Blue team is ahead
                            if goalsTeam1 == 1
                                txt = {[sprintf('%02d',min1) ':' sprintf('%02d',sec1) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('Time''s up for the first half of the match! The referee just blew the whistle!')],[sprintf('Blue team is currently leading with %d goal!', goalsTeam1)]};
                                text(0,42,txt,'HorizontalAlignment','center')
                            else
                                txt = {[sprintf('%02d',min1) ':' sprintf('%02d',sec1) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('Time''s up for the first half of the match! The referee just blew the whistle!')],[sprintf('Blue team is currently leading with %d goals!', goalsTeam1)]};
                                text(0,42,txt,'HorizontalAlignment','center')
                            end
                        elseif goalsTeam0 == goalsTeam1 % If it is a tie
                            if goalsTeam0 == 1 && goalsTeam1 == 1
                                txt = {[sprintf('%02d',min1) ':' sprintf('%02d',sec1) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('Time''s up for the first half of the match! The referee just blew the whistle!')],[sprintf('So far it''s a tie with %d goal to %d goal for Red team and Blue team, respectively!', goalsTeam0, goalsTeam1)]};
                                text(0,42,txt,'HorizontalAlignment','center')
                            else
                                txt = {[sprintf('%02d',min1) ':' sprintf('%02d',sec1) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('Time''s up for the first half of the match! The referee just blew the whistle!')],[sprintf('So far it''s a tie with %d goals to %d goals for Red team and Blue team, respectively!', goalsTeam0, goalsTeam1)]};
                                text(0,42,txt,'HorizontalAlignment','center')  
                            end                            
                        end
                        % Calculating and displaying the statistics of the first half of the match
                        RedTeamTotalPossession = round((teamPossessionRed/totalPossession)*100, 2);
                        BlueTeamTotalPossession = round((teamPossessionBlue/totalPossession)*100, 2);
                        
                        txt = {[sprintf("First Half Statistics:")],[sprintf("Red Team                  -                   Blue Team")],[sprintf("%d                Possession                %d",teamPossessionRed,teamPossessionBlue)],[sprintf("%g%%      Possession Percentage       %g%%",RedTeamTotalPossession,BlueTeamTotalPossession)],[sprintf("%d             Targeted Kicks              %d",targetedKicksRed,targetedKicksBlue)],[sprintf("%d             Team Kicks              %d",teamKicksRed,teamKicksBlue)],[sprintf("Players Statistics:")],[sprintf("%d             Possessions Player 1              %d",playerPossessionRed1,playerPossessionBlue1)],[sprintf("%d             Possessions Player 2              %d",playerPossessionRed2,playerPossessionBlue2)],[sprintf("%d             Possessions Player 3              %d",playerPossessionRed3,playerPossessionBlue3)],[sprintf("%d             Possessions Player 4              %d",playerPossessionRed4,playerPossessionBlue4)],[sprintf("%d             Kicks Player 1              %d",playerKicksRed1,playerKicksBlue1)],[sprintf("%d             Kicks Player 2              %d",playerKicksRed2,playerKicksBlue2)],[sprintf("%d             Kicks Player 3              %d",playerKicksRed3,playerKicksBlue3)],[sprintf("%d             Kicks Player 4              %d",playerKicksRed4,playerKicksBlue4)]};
                        text(0,10,txt,'HorizontalAlignment','center') 
                        
                        MSG = commentators{randi(length(commentators))}+string(halfTimeMsgs{randi(length(halfTimeMsgs))}); % Half-time commentary
                        disp(MSG)
                        txt = {[sprintf(MSG)]};
                        text(0,-33,txt,'HorizontalAlignment','center')
                        pause(10)
                        Goal = true; % Set the goal flag to true (or 1) to trigger the while loop breaking condition
                    end
                end 
            end
        elseif HalfMatchFlagGame == 1 % Gameplay for the first half of the match
            while Goal == false
        
                % Update player and ball positions based on time elapsed
                [players, ball] = SimulationSync(players, ball, timeSync, timeDelta, playerOriginalPosition, goalsTeam0, goalsTeam1);
                playerOriginalPosition = playerStickPosition;
                % Plot the playing field, players, and ball on the figure window
                PlotTheField(field)
                PlotThePlayers(players)
                PlotTheBall(ball)
                
                % Check if the ball has crossed the field boundaries and adjust its position accordingly
                [ball, players, goal] = FieldBorders(ball, players);
                
                % Check if a goal has been scored and update the goal flag and score accordingly
                [Goal, goalsTeam0, goalsTeam1, kickoffTeam] = Scoring(ball, goalsTeam0, goalsTeam1);
                
                % Update the time elapsed and format it as minutes, seconds, and milliseconds
                time2 = toc(t2);
                min2 = floor(time2 / 60);
                sec2 = floor(time2 - min2 * 60);
                msec2 = floor((time2 - floor(time2)) * 1000);
                
                % Display a message indicating which team will start with the ball based on a coin toss
                if kickoffTeamStartSH == 0 && time2 < 10
                    txt = {[sprintf('Now Red team will start with the ball for the second half of the match!')]};
                    text(0,39,txt,'HorizontalAlignment','center')
                elseif kickoffTeamStartSH == 1 && time2 < 10
                    txt = {[sprintf('Now Blue team will start with the ball for the second half of the match!')]};
                    text(0,39,txt,'HorizontalAlignment','center')
                end 
                
                % Add some live commentary to the game
                if (sec2 >= 5 && sec2 <= 12) || (sec2 >= 25 && sec2 <= 32)
                    if (time2 >= xtime && time2 <= (xtime+0.15)) || (time2 >= (xtime+20) && time2 <= (xtime+20.15))
                        MSG = commentators{randi(length(commentators))}+string(commentaryMidGame{randi(length(commentaryMidGame))}); % Mid-game commentary
                        disp(MSG)
                        if (time2 >= xtime && time2 <= xtime+0.10)
                            clear sound;
                            [x,fs] = audioread('OleChantWithDrums.wav');
                            sound(x, fs)
                        end
                        if goalsTeam0 > goalsTeam1 % If Red team is ahead
                            MSG1 = commentators{randi(length(commentators))}+"The Red team"+string(goodSupportiveMsgs{randi(length(goodSupportiveMsgs))}); % Supportive commentary for the Red team
                            disp(MSG1)                        
                            MSG2 = commentators{randi(length(commentators))}+"The Blue team"+string(badCritiquingMsgs{randi(length(badCritiquingMsgs))}); % Critiqing commentary for the Blue team
                            disp(MSG2)                         
                        elseif goalsTeam1 > goalsTeam0 % If Blue team is ahead
                            MSG3 = commentators{randi(length(commentators))}+"The Blue team"+string(goodSupportiveMsgs{randi(length(goodSupportiveMsgs))}); % Supportive commentary for the Blue team
                            disp(MSG3)                        
                            MSG4 = commentators{randi(length(commentators))}+"The Red team"+string(badCritiquingMsgs{randi(length(badCritiquingMsgs))}); % Critiqing commentary for the Red team
                            disp(MSG4)                          
                        end
                    end
                    if (sec2 >= 5 && sec2 <= 8) || (sec2 >= 25 && sec2 <= 28)
                        txt = {[sprintf(MSG)]};
                        text(0,-33,txt,'HorizontalAlignment','center')
                    elseif (sec2 > 8 && sec2 <= 15) || (sec2 > 28 && sec2 <= 35)
                        if goalsTeam0 > goalsTeam1 % If Red team is ahead
                            if (sec2 > 8 && sec2 <= 11) || (sec2 > 28 && sec2 <= 31)
                                txt = {[sprintf(MSG1)]};
                                text(0,-35,txt,'HorizontalAlignment','center')
                            elseif (sec2 > 11 && sec2 <= 15) || (sec2 > 31 && sec2 <= 35)
                                txt = {[sprintf(MSG2)]};
                                text(0,-37,txt,'HorizontalAlignment','center')
                            end
                        elseif goalsTeam1 > goalsTeam0 % If Blue team is ahead
                            if (sec2 > 8 && sec2 <= 11) || (sec2 > 28 && sec2 <= 31)
                                txt = {[sprintf(MSG3)]};
                                text(0,-35,txt,'HorizontalAlignment','center')
                            elseif (sec2 > 11 && sec2 <= 15) || (sec2 > 31 && sec2 <= 35)
                                txt = {[sprintf(MSG4)]};
                                text(0,-37,txt,'HorizontalAlignment','center')
                            end
                        end
                    end
                end
                if time2 >= IncrementPeriod
                    xtime = xtime + 30; % Increment x by 20            
                    % Update the next increment period
                    IncrementPeriod = IncrementPeriod + 30;
                end
                % Display the current time and score
                if time2 < 600
                    txt = {[sprintf('%02d',min2) ':' sprintf('%02d',sec2) ':' sprintf('%02d',rem(msec2, 100))],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')], [sprintf("2nd half of the match")]};
                    text(0,43,txt,'HorizontalAlignment','center')
                elseif time2 >= 600
                    % If more than 10 miuntes have elapsed, add extra time (half a minute or a minute and a half for a final push)
                    if ATflag == 0
                        AddedTime2 = 30; % Add half a minute for the final push
                    elseif ATflag == 1
                        AddedTime2 = 60; % Add a minute for the final push
                    end                
                    HalfMatchFlag = 1; % set the flag to 1 to trigger the while loop breaking condition
                    MatchFlag = 1; % Set the goal flag to true (or 1) to trigger the while loop breaking condition
                    txt = {[sprintf('10') ':' sprintf('00') ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('Time''s up for the second half of the match! Extra time up to %d seconds is now added for the final push!', AddedTime2)]};
                    text(0,43,txt,'HorizontalAlignment','center')
                    txt = {[sprintf(' +') sprintf('00') ':' sprintf('%02d',sec2) ':' sprintf('%02d',rem(msec2, 100))]};
                    text(10,45.2,txt,'HorizontalAlignment','center')
                    if time2 >= 600+AddedTime2 
                        Goal = true; % Set the goal flag to true (or 1) to trigger the while loop breaking condition
                    end
                end 
            end
        end
    end
end 

[x,fs] = audioread('WhistleFinal.wav');
sound(x, fs)
crowd = randi([0, 1]);
if crowd ==  0
    [x,fs] = audioread('Crowd1.wav');
    sound(x, fs)
elseif crowd == 1
    [x,fs] = audioread('Crowd2.wav');
    sound(x, fs)
end

% Keep track of the scoring during the match
FirstHalfgoalsRedTeam;
FirstHalfgoalsBlueTeam;
SecondHalfgoalsRedTeam = goalsTeam0 - FirstHalfgoalsRedTeam;
SecondHalfgoalsBlueTeam = goalsTeam1 - FirstHalfgoalsBlueTeam;
TotalgoalsRedTeam = goalsTeam0;
TotalgoalsBlueTeam = goalsTeam1;


% Update the time elapsed and format it as minutes, seconds, and milliseconds
time3 = toc(t);
min = floor(time3 / 60);
sec = floor(time3 - min * 60);
msec = floor((time3 - floor(time3)) * 1000);

% Keepign the final plot with its attributes (ball position, players positions, the time, and the goals)
clf                         % Clear the current figure
PlotTheField(field)         % Plot the soccer field
PlotThePlayers(players)     % Plot the players

% Check which team has won or if it is a tie, and display the appropriate text
if time3 >= time1+time2+10
    if goalsTeam0 > goalsTeam1 % If Red team has won
        if goalsTeam0 == 1
            txt = {[sprintf('%02d',min) ':' sprintf('%02d',sec-10) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('Time''s up! The referee just blew the final whistle!')],[sprintf('Red team won with %d goal!', goalsTeam0)]};
            text(0,42,txt,'HorizontalAlignment','center')
        else
            txt = {[sprintf('%02d',min) ':' sprintf('%02d',sec-10) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('Time''s up! The referee just blew the final whistle!')],[sprintf('Red team won with %d goals!', goalsTeam0)]};
            text(0,42,txt,'HorizontalAlignment','center')
        end
    elseif goalsTeam1 > goalsTeam0 % If Blue team has won
        if goalsTeam1 == 1
            txt = {[sprintf('%02d',min) ':' sprintf('%02d',sec-10) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('Time''s up! The referee just blew the final whistle!')],[sprintf('Blue team won with %d goal!', goalsTeam1)]};
            text(0,42,txt,'HorizontalAlignment','center')
        else
            txt = {[sprintf('%02d',min) ':' sprintf('%02d',sec-10) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('Time''s up! The referee just blew the final whistle!')],[sprintf('Blue team won with %d goals!', goalsTeam1)]};
            text(0,42,txt,'HorizontalAlignment','center')
        end
    elseif goalsTeam0 == goalsTeam1 % If it is a tie
        if goalsTeam0 == 1 && goalsTeam1 == 1
            txt = {[sprintf('%02d',min) ':' sprintf('%02d',sec-10) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('Time''s up! The referee just blew the final whistle!')],[sprintf('It''s a tie with %d goals to %d goals for Red team and Blue team, respectively!', goalsTeam0, goalsTeam1)]};
            text(0,42,txt,'HorizontalAlignment','center')
        else
            txt = {[sprintf('%02d',min) ':' sprintf('%02d',sec-10) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('Time''s up! The referee just blew the final whistle!')],[sprintf('It''s a tie with %d goals to %d goals for Red team and Blue team, respectively!', goalsTeam0, goalsTeam1)]};
            text(0,42,txt,'HorizontalAlignment','center')  
        end
    end
else
    if goalsTeam0 > goalsTeam1 % If Red team has won
        if goalsTeam0 == 1
            txt = {[sprintf('%02d',min) ':' sprintf('%02d',sec-10) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('What a goal! That was a great final push!')],[sprintf('Red team won with %d goal!', goalsTeam0)]};
            text(0,42,txt,'HorizontalAlignment','center')
        else
            txt = {[sprintf('%02d',min) ':' sprintf('%02d',sec-10) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('What a goal! That was a great final push!')],[sprintf('Red team won with %d goals!', goalsTeam0)]};
            text(0,42,txt,'HorizontalAlignment','center')
        end
    elseif goalsTeam1 > goalsTeam0 % If Blue team has won
        if goalsTeam1 == 1
            txt = {[sprintf('%02d',min) ':' sprintf('%02d',sec-10) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('What a goal! That was a great final push!')],[sprintf('Blue team won with %d goal!', goalsTeam1)]};
            text(0,42,txt,'HorizontalAlignment','center')
        else
            txt = {[sprintf('%02d',min) ':' sprintf('%02d',sec-10) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('What a goal! That was a great final push!')],[sprintf('Blue team won with %d goals!', goalsTeam1)]};
            text(0,42,txt,'HorizontalAlignment','center')
        end  
    elseif goalsTeam0 == goalsTeam1 % If it is a tie
        if goalsTeam0 == 1 && goalsTeam1 == 1
            txt = {[sprintf('%02d',min) ':' sprintf('%02d',sec-10) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('What a goal! That was a great final push!')],[sprintf('It''s a tie with %d goals to %d goals for Red team and Blue team, respectively!', goalsTeam0, goalsTeam1)]};
            text(0,42,txt,'HorizontalAlignment','center')
        else
            txt = {[sprintf('%02d',min) ':' sprintf('%02d',sec-10) ':' sprintf('00')],[sprintf('Red ') num2str(goalsTeam0) '-' num2str(goalsTeam1) sprintf(' Blue')],[sprintf('What a goal! That was a great final push!')],[sprintf('It''s a tie with %d goals to %d goals for Red team and Blue team, respectively!', goalsTeam0, goalsTeam1)]};
            text(0,42,txt,'HorizontalAlignment','center')  
        end
    end
end

% Calculating and displaying the statistics of the match
RedTeamTotalPossession = round((teamPossessionRed/totalPossession)*100, 2);
BlueTeamTotalPossession = round((teamPossessionBlue/totalPossession)*100, 2);

txt = {[sprintf("Full Match Statistics:")],[sprintf("Red Team                  -                   Blue Team")],[sprintf("%d                Possession                %d",teamPossessionRed,teamPossessionBlue)],[sprintf("%g%%      Possession Percentage       %g%%",RedTeamTotalPossession,BlueTeamTotalPossession)],[sprintf("%d             Targeted Kicks              %d",targetedKicksRed,targetedKicksBlue)],[sprintf("%d             Team Kicks              %d",teamKicksRed,teamKicksBlue)],[sprintf("Players Statistics:")],[sprintf("%d             Possessions Player 1              %d",playerPossessionRed1,playerPossessionBlue1)],[sprintf("%d             Possessions Player 2              %d",playerPossessionRed2,playerPossessionBlue2)],[sprintf("%d             Possessions Player 3              %d",playerPossessionRed3,playerPossessionBlue3)],[sprintf("%d             Possessions Player 4              %d",playerPossessionRed4,playerPossessionBlue4)],[sprintf("%d             Kicks Player 1              %d",playerKicksRed1,playerKicksBlue1)],[sprintf("%d             Kicks Player 2              %d",playerKicksRed2,playerKicksBlue2)],[sprintf("%d             Kicks Player 3              %d",playerKicksRed3,playerKicksBlue3)],[sprintf("%d             Kicks Player 4              %d",playerKicksRed4,playerKicksBlue4)]};
text(0,10,txt,'HorizontalAlignment','center')