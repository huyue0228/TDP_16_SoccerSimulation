function [updatedBall] = BallKicking(ball, kickBallSigma, kickBallCoefficient, targetPosition, timeDelta)

ballPosition = ball(1,:);
updatedBall = ball;

% Set an error; error range:[-0.15,0.15]
error = 0.3 * rand() - 0.15;

distanceError = targetPosition - ballPosition;
distance = norm(distanceError);
direction = distanceError / distance;

% Add random noise to the kick direction
kickDirection = direction + error;
kickDirection(1) = kickDirection(1) + normrnd(0, kickBallSigma); % Add random noise to the x-component of the kick direction
kickDirection(2) = kickDirection(2) + normrnd(0, kickBallSigma); % Add random noise to the y-component of the kick direction

% Update the speed of the ball
updatedBall(2,:) = updatedBall(2,:) + kickBallCoefficient * kickDirection;

% Apply a damping factor to account for deceleration (e.g., due to air resistance or friction)
dampingFactor = 0.95;
updatedBall(2,:) = dampingFactor * updatedBall(2,:);

% Update the position of the ball based on the updated velocity and timeDelta
updatedBall(1,:) = updatedBall(1,:) + updatedBall(2,:) * timeDelta;

end
