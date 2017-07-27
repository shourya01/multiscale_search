function BuildTreeMaxDepth (data)

% Initialise the tree with a prior.
% Depth at which to initialise is given.
% Depth and prior matrix are in 'data'

global tree;
global maxDepth;

prior = data.pData;
d = data.pDepth;

% step = ((2^(maxDepth-1))/(2^(d-1)))/2;

SplitNode(d,1); % the first element in the data structure is the root

for i = 1:numel(tree)
    if tree(i).leaf == 1
%        x = tree(i).xc;
%        y = tree(i).yc;
%        row = (y+step)/(2^maxDepth-d);
%        col = (x+step)/(2^maxDepth-d);
%        tree(i).p = prior(row,col);
        tree(i).p = 0.3; % Hack for now to put uniform prior, will correct this bug later
    end
end

CheckConsistency; % Initiate each internal node to proper value

delete('prior.mat');

end  