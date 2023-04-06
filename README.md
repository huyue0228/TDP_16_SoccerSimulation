# TDP_16_SoccerSimulation
21/03/2023 add acceleration to Move.m (by Yue)  

25/03/2023 change the feild size and players' positions (by Yue)  

25/03/2023 add Attack function and update global parameter fallbehindTeam, 2on1 logic to UpadatePlayer (by Chenwei Cui)  

25/03/2023  change the error when player kick ball on kickBall.m   by XK  

26/03/2023 updated：UpadatePlayers，Update, SoccerGame(by Chenwei Cui)  

28/03/2023 FinalUpdatedWork: Adjusted the goal size in Goal.m. Debugged the plotting for the rectangle in PlotBall.m. Added commentary to the game in CheckBorders.m. Added minor adjustments to the comments and will work on the players animations and static work. (By Ahmad)  

28/03/2023 updated passBall.m  by XK  

31/03/2023 FinalUpdatedWork: Squashed a bug for the condition of corner kicks on CheckBorders.m. It shouldn't break the ball parameters for plotting now. (By Ahmad)  

31/03/2023 TDP_16_RobocupSimulation-final: This has the updated function names and final work so far. (By Ahmad)  

04/04/2023 updated PlayerInitialPositions.m and PlayerMovement.m. (By Yue)  

04/04/2023 change collision code by YL  

05/04/2023 updated plotTheplayers.m, plotTheBall.m, PlayerInitialPosition.m, and PlayerMovement.m. (By Yue)

05/04/2023 solved shaking problem. (By Yue)

06/04/2023 Set each player's movement individually, complete with score-based strategies. (By Yue)

06/04/2023 Updates added to "EditingPreviousWork" branch: Adjusted the UpdatePlayerState function to contain (Kicking, Passing, Marking, and Looking for teammates) all in one function. Adjusted UpdatePlayerState to have a smarter decision making based on calculated thresholds and distances. Adjusted the goal parameters in UpdatePlayerState to have a more dynamic kicks towards the goal. Adjusted FieldBorders to contain corner kicks coniditon without bugging out and counting as an out. Adjusted the global variable in FieldBorders and UpdatePlayerState to work more accuretly. (By Ahmad)

06/04/2023 added parameter ignoreMarkedDistance.  
           added logic to make sure strikers will shoot when they are close enough to the goal even though they are marked.  (By Chenwei Cui)
  
