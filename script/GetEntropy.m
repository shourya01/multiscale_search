function H = GetEntropy (varargin)

global tree;

% Get entropy of either the entire tree or a single node
% Robust to p = 0 or 1 cases

nargin = numel(varargin);

if nargin == 0
    P = [tree(logical([tree(:).leaf]==1)).p];
    H = entropy(P);
else
    n = varargin{1};
    pr = tree(n).p;
    H = entropy(pr);
end