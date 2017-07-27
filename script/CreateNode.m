function n = CreateNode (parent,prob,pos)

% Create a new node and put it as output.
% The type of the new node is a structure given below.

global tree;
global maxDepth;

n = struct('parent',parent,'p',prob,'leaf',1,'NW',0,'NE',0,'SE',0,...
    'SW',0,'xmax',0,'ymax',0,'xmin','0','ymin',0,...
    'buf1',0,'buf2',0,'depth',1,'xc',0,'yc',0,'D',0,...
    'TimesSensed',0);

% In the structure, 2 buffer variables are provided 
% in case future code needs it.

if parent ~= 0
    par=tree(parent);
    deltax = (par.xmax-par.xmin)/2;
    deltay = (par.ymax-par.ymin)/2;
    n.depth = par.depth+1;
    if (n.depth > maxDepth)
        error('Maximum depth exceeded');
    end
    switch pos
        case 1 % North West
            n.xmin = par.xmin;
            n.xmax = par.xmin + deltax;
            n.ymax = par.ymax;
            n.ymin = par.ymax - deltay;
            
        case 2 % North East
            n.xmax = par.xmax;
            n.xmin = par.xmax - deltax;
            n.ymax = par.ymax;
            n.ymin = par.ymax - deltay;
            
        case 3 % South East
            n.xmax = par.xmax;
            n.xmin = par.xmax - deltax;
            n.ymin = par.ymin;
            n.ymax = par.ymin + deltay;
            
        case 4 % South West
            n.xmin = par.xmin;
            n.xmax = par.xmin + deltax;
            n.ymin = par.ymin;
            n.ymax = par.ymin + deltay;
            
    end
end

n.xc = (n.xmin+n.xmax)/2;
n.yc = (n.ymin+n.ymax)/2;