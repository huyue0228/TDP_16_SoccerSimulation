function [x,y,ball]=PlayersAndBallCollisions(x,y,ball,particleRadius)

gridSize=length(x);
c=1.0;

%player collisions
for i = 1:gridSize
    for j = 1:i
        if i ~= j
            distance = sqrt((x(i) - x(j)).^2+(y(i) - y(j)).^2);
            if distance < 2*particleRadius
                repulsion = (2*particleRadius-distance)/2;
                x(i) = x(i) + c*repulsion*(x(i)-x(j))/distance;
                x(j) = x(j) - c*repulsion*(x(i)-x(j))/distance;
                y(i) = y(i) + c*repulsion*(y(i)-y(j))/distance;
                y(j) = y(j) - c*repulsion*(y(i)-y(j))/distance;
            end
        end
    end
end

% %ball collisions below
% c2=1;
% for i = 1:gridSize
%     distance = sqrt((x(i) - ball(1,1)).^2+(y(i) - ball(1,2)).^2);
%     if distance < 2*particleRadius
%         repulsion = (2*particleRadius-distance)/2;
%         %x(i) = x(i) + c2*repulsion*(x(i)-ball(1,1))/distance;
%         ball(1,1) = ball(1,1) - 2*c2*repulsion*(x(i)-ball(1,1))/distance;
%         %y(i) = y(i) + c2*repulsion*(y(i)-ball(1,2))/distance;
%         ball(1,2) = ball(1,2) - 2*c2*repulsion*(y(i)-ball(1,2))/distance;
% %         ball(2,1)=0;
% %         ball(2,2)=0;
%     end
% end

end
