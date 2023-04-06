function [] = PlotTheField(fieldSize)
clf
l = fieldSize(1)/2;
w = fieldSize(2)/2;

rectangles = [ 
    -45 -30 90 60;
    -51 -13 6 26;
    -45 -15 10 30;
    -45 -25 20 50;
    45 -13 6 26;
    35 -15 10 30;
    25 -25 20 50
    ];

hold on
rectangle('Position',rectangles(1,:),'EdgeColor','w','LineWidth',0.8);
rectangle('Position',rectangles(2,:),'EdgeColor','w','LineWidth',0.8);
rectangle('Position',rectangles(3,:),'EdgeColor','w','LineWidth',0.8);
rectangle('Position',rectangles(4,:),'EdgeColor','w','LineWidth',0.8);
rectangle('Position',rectangles(5,:),'EdgeColor','w','LineWidth',0.8);
rectangle('Position',rectangles(6,:),'EdgeColor','w','LineWidth',0.8);
rectangle('Position',rectangles(7,:),'EdgeColor','w','LineWidth',0.8);
line([0 0],[30 -30],'Color','w','LineWidth',0.8);
rectangle('Position', [-7.5, -7.5, 15, 15], 'Curvature', [1, 1], 'EdgeColor', 'w', 'LineWidth', 0.2);

xlabel('');
ylabel('');
yticks('');
xticks('');

axis equal
axis([-l-10 l+10 -w-10 w+10])
%axis([-70 70 -60 60])

set(gca,'Color','#77AC30')
end
