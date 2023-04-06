function PlotTheBall(ball)
% This function plots the ball on the field.
% It takes the ball's state as input and creates a 2-d shape of a ball to represent the ball.

% Gets the ball's position.
ballPosition = ball(1,:);

% Calculates the position of the circle that represents the ball.
ballRadius = 1;
plotpos(1) = ballPosition(1) - ballRadius;
plotpos(2) = ballPosition(2) - ballRadius;
plotpos(3) = 2 * ballRadius;
plotpos(4) = 2 * ballRadius;

% Check if plotpos values are valid and finite
if all(isfinite(plotpos)) && isnumeric(plotpos)
    % Plots the ball as a white circle on the field.
    rectangle('Position',plotpos,'Curvature',[1 1],'FaceColor','white');
    hold on
    theta = 0:2*pi/5:2*pi;
    r = ballRadius * ones(1,6);
    [X,Y] = pol2cart(theta,r/2);
    plot(X+ballPosition(1),Y+ballPosition(2),'Color','k','LineWidth',0.5)
    fill(X+ballPosition(1),Y+ballPosition(2), 'black');
    hold on
    [X1,Y1] = pol2cart(theta,r);
    line([X;X1]+ballPosition(1),[Y;Y1]+ballPosition(2),'Color','k','LineWidth',1)
else
    % Display a warning message if the values are not valid
    warning('Invalid or non-finite ball position. Ball not plotted.');
end

end
