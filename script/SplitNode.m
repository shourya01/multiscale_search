function SplitNode (dep,parent)

% Split a node from node 'parent' all the way down
% to level 'dep'.

global tree;
global maxDepth;

if dep>maxDepth
    return;
end

if tree(parent).depth>=dep
    return;
end

prob = tree(parent).p;
probnew = 1-(1-prob)^0.25;

nw = CreateNode(parent,probnew,1);
ne = CreateNode(parent,probnew,2);
se = CreateNode(parent,probnew,3);
sw = CreateNode(parent,probnew,4);


num = numel(tree);
tree = [tree nw ne se sw];
tree(parent).leaf = 0;
tree(parent).NW = num+1;
tree(parent).NE = num+2;
tree(parent).SE = num+3;
tree(parent).SW = num+4;

SplitNode(dep,num+1);
SplitNode(dep,num+2);
SplitNode(dep,num+3);
SplitNode(dep,num+4);

end