function DrawQuadtree (n,fig,time)

% Draw current quadtree in all its glory.
% Currently pretty slow.

figure = fig;

global tree;
global targets;

for i = 1:numel(tree)
    xm = tree(i).xmax;
    xmi = tree(i).xmin;
    ym = tree(i).ymax;
    ymi = tree(i).ymin;
    x = [xmi xm xm xmi];
    y = [ymi ymi ym ym];
    plot(x,y,'k');
    hold on;
end

% Draw marker

xlow = tree(1).xmin;
xhigh = tree(1).xmax;
ylow = tree(1).ymin;
yhigh = tree(1).ymax;

xlim([xlow xhigh]);
ylim([ylow yhigh]);

x = tree(n).xc;
y = tree(n).yc;

plot(x,y,'r--x','MarkerSize',10);

% Plot targets

for i = 1:size(targets,1)
    plot(targets(i,1),targets(i,2),'k--*','MarkerSize',5);
end

% Plot decisions

for i = 1:numel(tree)
    if tree(i).D == 1
        x = tree(i).xc;
        y = tree(i).yc;
        plot(x,y,'b--o','MarkerSize',5);
    end
end

title(['Timestep ',num2str(time),', Marker ',num2str(n)]);

hold off;

end