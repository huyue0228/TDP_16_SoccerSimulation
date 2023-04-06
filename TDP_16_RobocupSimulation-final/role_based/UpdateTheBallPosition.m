function [updatedBall] = UpdateTheBallPosition(ball, timeDelta, acceleration)

frictionCoefficient=0.75; %less than 1

updatedBall=ball;

updatedBall(1,1)=ball(1,1)+ball(2,1)*timeDelta;%-sign(ball(2,1))*acceleration*timeDelta^2/2;
updatedBall(1,2)=ball(1,2)+ball(2,2)*timeDelta;%-sign(ball(2,2))*acceleration*timeDelta^2/2;
%updatedBall(2,1)=ball(2,1)-sign(ball(2,1))*acceleration*timeDelta;
%updatedBall(2,2)=ball(2,2)-sign(ball(2,2))*acceleration*timeDelta;
updatedBall(2,1)=frictionCoefficient*ball(2,1);
updatedBall(2,2)=frictionCoefficient*ball(2,2);

end
