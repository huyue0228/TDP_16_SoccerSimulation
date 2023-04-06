%% Main Game File %%

clear       % Clearing variables
clf         % Clearing figures
clc         % Clearing commands
close all   % Closing figures

% Initialzing values

field = [90 60];
kickoffTeamStart=randi([0, 1]);                             % For Red team use 0, for Blue team use 1
formation1=[1 2];                                           % A defender and two attackers 
formation2=[1 2];                                           % A defender and two attackers 
nPlayers=sum(formation1)+sum(formation2)+2;                 % We add two extra players as goalkeepers for each team
kickoffTeam = kickoffTeamStart;                             % To display which team won the coin flip               
attributes = [zeros(nPlayers/2,1); ones(nPlayers/2,1)];     % To differentiate between the two teams' players, for Red team use 0, for Blue team use 1

startPositionBall = [0;0];  % Start position of the ball in the center of the field 
startVelBall = [0;0];       % Start velocity of the ball is initialized as zero (standing still)
startAccBall = [0;0];       % Start acceleration of the ball is initialized as zero (not )

goalsTeam1=0;
goalsTeam2=0;

timeSteps = 6000*20;    % Timesteps of the simulation in seconds (6000 Timesteps roughly equals 1 minute)
timeDelta = 1;          % The gametime elapsed between every update
timeSync = 0.01;        % Time between drawing of each plot

% With these settings one simulation will take around 20 minutes (half time of the total match)
time=0; % For simulating
tic();  % For plotting       
pause(1)

% Initialize a while loop that will run for the specified number of time steps
while time < timeSteps
    isGoal = false; % Initialize the goal flag to false for each new round
    
    % Reset the ball and player attributes to their initial values for each new round
    ball = BallInitialPosition(startPositionBall, startVelBall, startAccBall);
    [players, playerOriginalPosition] = PlayersInitialPositions(formation1, formation2, attributes, kickoffTeam);

    pause(1); % Pause for 1 second before starting the round
    
    % Create a while loop that runs until a goal is scored
    while isGoal == false

        % Update player and ball positions based on time elapsed
        [players, ball] = SimulationSync(players, ball, timeSync, timeDelta, playerOriginalPosition);
        
        % Plot the playing field, players, and ball on the figure window
        PlotTheField(field)
        PlotThePlayers(players)
        PlotTheBall(ball)
        
        % Check if the ball has crossed the field boundaries and adjust its position accordingly
        [ball, players, goal] = FieldBorders(ball, players);
        
        % Check if a goal has been scored and update the goal flag and score accordingly
        [isGoal, goalsTeam1, goalsTeam2, kickoffTeam] = Scoring(ball, goalsTeam1, goalsTeam2);
        
        % Update the time elapsed and format it as minutes, seconds, and milliseconds
        t = toc();
        min = floor(t / 60);
        sec = floor(t - min * 60);
        msec = floor((t - floor(t)) * 1000);
        
        % Display a message indicating which team will start with the ball based on a coin toss
        if kickoffTeamStart == 0 && t < 10
            txt = {[sprintf('After flipping a coin, Red team will start with the ball!')]};
            text(0,38,txt,'HorizontalAlignment','center')
        elseif kickoffTeamStart == 1 && t < 10
            txt = {[sprintf('After flipping a coin, Blue team will start with the ball!')]};
            text(0,38,txt,'HorizontalAlignment','center')
        end 
        
        % Display the current time and score
        if t < 1200
            txt = {[sprintf('%02d',min) ':' sprintf('%02d',sec) ':' sprintf('%02d',rem(msec, 100))],[sprintf('Red ') num2str(goalsTeam1) '-' num2str(goalsTeam2) sprintf(' Blue')]};
            text(0,45,txt,'HorizontalAlignment','center')
        elseif t >= 1200
            % If more than 60 seconds have elapsed, add extra time for a final push
            time = 6000 * 20; % Set the time to 20 minutes
            txt = {[sprintf('%02d',min) ':' sprintf('%02d',sec) ':' sprintf('%02d',rem(msec, 100))],[num2str(goalsTeam1) '-' num2str(goalsTeam2)],[sprintf('Time''s up! Extra time is now added for the final push!')]};
            text(0,43,txt,'HorizontalAlignment','center')
        end 
        
        % Increment the time step counter by 1
        time = time + 1;
    end
end

% Keepign the final plot with its attributes (ball position, players positions, the time, and the goals)
clf                     % Clear the current figure
PlotTheField(field)     % Plot the soccer field
PlotThePlayers(players)    % Plot the players

% Check which team has won or if it is a tie, and display the appropriate text
if goalsTeam1 > goalsTeam2 % If Red team has won
    txt = {[sprintf('%02d',min) ':' sprintf('%02d',sec) ':' sprintf('%02d',rem(msec, 100))],[num2str(goalsTeam1) '-' num2str(goalsTeam2)],[sprintf('Red team won with %d goals!', goalsTeam1)]};
    text(0,43,txt,'HorizontalAlignment','center')
elseif goalsTeam2 > goalsTeam1 % If Blue team has won
    txt = {[sprintf('%02d',min) ':' sprintf('%02d',sec) ':' sprintf('%02d',rem(msec, 100))],[num2str(goalsTeam1) '-' num2str(goalsTeam2)],[sprintf('Blue team won with %d goals!', goalsTeam2)]};
    text(0,43,txt,'HorizontalAlignment','center')
elseif goalsTeam1 == goalsTeam2 % If it is a tie
    txt = {[sprintf('%02d',min) ':' sprintf('%02d',sec) ':' sprintf('%02d',rem(msec, 100))],[num2str(goalsTeam1) '-' num2str(goalsTeam2)],[sprintf('It''s a tie with %d goals to %d goals for Red team and Blue team, respectively!', goalsTeam1, goalsTeam2)]};
    text(0,43,txt,'HorizontalAlignment','center')
end
