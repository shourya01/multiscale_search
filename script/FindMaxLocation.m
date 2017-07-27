function [loc,M] = FindMaxLocation (ncur)

% Find location that maximises the cost function to 
% find next node to go.

global tree;
global lambda;
global locTrajectory;
global VarWeight;
global STOP;

n1 = numel(locTrajectory);
o = max(1,n1-7);
ZS = locTrajectory(o:n1);
tu = 0.95; % Upper threshold for clearing cell
tl = 0.05; % Lower threshold for clearing cell

VARMEASURE = [];

% Some variance based cost I introduced to
% stop the searcher from getting stuck and
% oscillating between 2 nodes.
for j = 1:numel(tree)
    VARMEASURE = [VARMEASURE var([ZS j])];
end
VARMAX = max(VARMEASURE);

IGSTORE = [];
DISTSTORE = [];

% Distance
for j = 1:numel(tree)
    a = cost(ncur,j);
    DISTSTORE = [DISTSTORE,a];
end
DISTMAX = max(DISTSTORE);

% Expected Information Gain
for j = 1:numel(tree)
    a = IG(j);
    IGSTORE = [IGSTORE,a];
end
IGMAX = max(abs(IGSTORE));

COST = lambda*((IGSTORE/IGMAX)) - (1-lambda)*(DISTSTORE/DISTMAX) + VarWeight*(VARMEASURE/VARMAX);
ILLEGAL = logical(([tree(:).p]>tu|[tree(:).p]<tl)&([tree(:).TimesSensed]>0)); % Fish out cleared nodes
COST(ILLEGAL) = NaN; % Set cost of cleared nodes to NaN

% Below loop to quit in case every cost turns to NaN
if sum(isnan(COST))==numel(COST)
    STOP = 1;
    M = -10000;
    loc = 1;
    return;
end

% Arg max over n
[M,loc] = max(COST);

end

function T = cost (i,j)

% Find the cost of travel between nodes i and j
% Depends on coordinates of i and j 
% Also depends on their elevation and who's higher than whom

global tree;
global cost_ascend;
global bonus_descent;

dist = norm(tree(i).xc-tree(j).xc,tree(i).yc-tree(j).yc);

if tree(i).depth >= tree(j).depth
    vert = cost_ascend*(tree(i).depth-tree(j).depth);
else
    vert = -bonus_descent*(tree(j).depth-tree(i).depth);
end

if(i==j)
    T = 100;
    return;
end

T = dist+vert;

end