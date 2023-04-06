function [] = PlotThePlayers(players)
pos = players{1};

%Players size
radie = 1.5;

hold on
team = players{3};
team1 = find(team == 0);
team2 = find(team == 1);

for i = 1:length(team1)
    plotpos = [pos(team1(i),1)-radie pos(team1(i),2)-radie radie 2*radie];
    rectangle('Position',plotpos,'Curvature',[0.8 0.8],'FaceColor','#CD212A','EdgeColor','none');
    plotpos = [pos(team1(i),1) pos(team1(i),2)-radie radie 2*radie];
    rectangle('Position',plotpos,'Curvature',[0.8 0.8],'FaceColor','#CD212A','EdgeColor','none');
    plotpos = [pos(team1(i),1)-2*radie/6 pos(team1(i),2)-radie 2*radie/3 2*radie];
    rectangle('Position',plotpos,'FaceColor','#F4F5F0','EdgeColor','none');
    hold on
    x_center = plotpos(1) + plotpos(3)/2;
    y_center = plotpos(2) + plotpos(4)/2;
    text(x_center, y_center, num2str(i), 'FontSize', 8, 'HorizontalAlignment', 'center','Color', 'k','FontWeight', 'bold' )
    %text(x_center, y_center, '1', 'FontSize', 7, 'HorizontalAlignment', 'center','Color' ,'w', 'FontWeight','normal')
end
for i = 1:length(team2)
    plotpos = [pos(team2(i),1)-radie pos(team2(i),2)-radie 2*radie 2*radie];
    rectangle('Position',plotpos,'Curvature',[0.75 0.75],'FaceColor','#0583E8','EdgeColor','none');
    plotpos = [pos(team2(i),1)-radie pos(team2(i),2)-radie/4 2*radie radie/2];
    rectangle('Position',plotpos,'FaceColor','#0583E8','EdgeColor','none');
    plotpos = [pos(team2(i),1)-radie/4 pos(team2(i),2)-radie radie/2 2*radie];
    rectangle('Position',plotpos,'FaceColor','#F4F5F0','EdgeColor','none');
    x_center = plotpos(1) + plotpos(3)/2;
    y_center = plotpos(2) + plotpos(4)/2;
    text(x_center, y_center, num2str(i), 'FontSize', 8, 'HorizontalAlignment', 'center','Color', 'k','FontWeight', 'bold' )
    hold on
end
end
