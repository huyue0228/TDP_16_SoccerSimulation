function [ball] = BallInitialPosition(startPosition, startVel, startAcc)
% This function initializes the properties of the ball at the start position

% Create a 3x2 matrix to represent the ball with initial values of 0
ball = zeros(3,2);

% Set the first row of the matrix to be the starting position
ball(1,:) = startPosition;

% Set the second row of the matrix to be the starting velocity
ball(2,:) = startVel;

% Set the third row of the matrix to be the starting acceleration
ball(3,:) = startAcc;

end
