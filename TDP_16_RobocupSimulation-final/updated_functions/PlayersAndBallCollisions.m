function [x, y, ball] = PlayersAndBallCollisions(x, y, ball, particleRadius)

gridSize = length(x);
c = 1.2;

for i = 1:gridSize
    for j = 1:i-1
        if i ~= j
            deltaX = x(i) - x(j);
            deltaY = y(i) - y(j);
            distance = sqrt(deltaX^2 + deltaY^2);
            
            if distance < 2 * particleRadius
                % Calculate collision response based on conservation of momentum       
                normalX = deltaX / distance;
                normalY = deltaY / distance;

                % Reposition players to prevent overlapping
                overlap = 2 * particleRadius - distance;
                x(i) = x(i) + c * overlap * normalX / 2;
                x(j) = x(j) - c * overlap * normalX / 2;
                y(i) = y(i) + c * overlap * normalY / 2;
                y(j) = y(j) - c * overlap * normalY / 2;
            end
        end
    end
end

