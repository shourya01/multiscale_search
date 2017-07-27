function T = FindChildNodes (n)

% Find all leaf nodes that are descendants
% of the node n

global tree;

if tree(n).leaf == 1
    T = n;
else
    T = [FindChildNodes(tree(n).NW),FindChildNodes(tree(n).NE),...
        FindChildNodes(tree(n).SE),FindChildNodes(tree(n).SW)];
end

end