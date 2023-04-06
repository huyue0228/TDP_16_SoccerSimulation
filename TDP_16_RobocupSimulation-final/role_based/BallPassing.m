function [updatedBall] = BallPassing(ball, passBallSigma, passBallCoefficient, passBallAcceleration, targetPosition, timeDelta)
% This function simulates a ball pass by updating its position and velocity based on the target position, kick coefficient, and random noise.

% Inputs:
% 1. ball: 2x2 matrix, with the first row representing the ball's position (x, y) and the second row representing the ball's velocity (vx, vy)
% 2. passBallSigma: scalar, standard deviation of noise added to the kick direction (both x and y components) to simulate inaccuracy of the pass
% 3. passBallCoefficient: scalar, coefficient for scaling the pass length, affecting how far the ball is kicked
% 4. passBallAcceleration: scalar, not used in the function (might be a placeholder for future implementation or an unused legacy parameter)
% 5. targetPosition: 1x2 vector, representing the target position (x, y) of the pass
% 6. timeDelta: scalar, not used in the function (might be a placeholder for future implementation or an unused legacy parameter)
% Output:
% 1. updatedBall: 2x2 matrix, with the first row representing the new position (x, y) and the second row representing the new velocity (vx, vy) after the pass

dampingFactor = 0.95; % Define a damping factor to account for deceleration (e.g., due to air resistance or friction)
maxPassLength = 20; % Define the maximum pass length

ballPosition = ball(1,:); % Extract the current ball position from the input ball variable
updatedBall = ball; % Initialize the updatedBall variable with the current ball values
passLength = norm(targetPosition - ballPosition); % Calculate the length of the pass
scaledPassLength = min(passLength, maxPassLength); % Limit the pass length to the defined maximum

passBallCoefficient = (passBallCoefficient * scaledPassLength / passLength) * normrnd(1, 0.1); % Scale the passBallCoefficient based on the scaled pass length and a random factor with mean 1 and standard deviation 0.1

kickDirection = (targetPosition - ballPosition) / passLength; % Calculate the unit vector representing the direction of the pass
kickDirection(1) = kickDirection(1) + normrnd(0, passBallSigma); % Add random noise to the x-component of the kick direction
kickDirection(2) = kickDirection(2) + normrnd(0, passBallSigma); % Add random noise to the y-component of the kick direction

% Update the velocity of the ball based on the calculated kick direction, scaled pass length, and acceleration
updatedBall(2,:) = updatedBall(2,:) + passBallCoefficient * passLength * kickDirection + passBallAcceleration * timeDelta * kickDirection;

% Apply the damping factor to the updated velocity
updatedBall(2,:) = dampingFactor * updatedBall(2,:);

% Update the position of the ball based on the updated velocity and timeDelta
updatedBall(1,:) = updatedBall(1,:) + updatedBall(2,:) * timeDelta;

end

%For TDP_Team_16 interpretation:
    % Changes made:
        % Incorporate the effect of acceleration and timeDelta to the ball's velocity