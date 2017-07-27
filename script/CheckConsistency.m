function CheckConsistency

% Perform a bottom-up update
% At every node ensure qn=qn1*qn2*qn3*qn4

global tree;
global maxDepth;

updated = [];
check = @(x,y) sum(x-y==0);

for i = maxDepth:-1:2
    NODES = find([tree(:).depth]==i);
    for j = 1:numel(NODES)
        k = tree(NODES(j)).parent;
        if ~check(updated,k)
            q1 = 1 - tree(tree(k).NW).p;
            q2 = 1 - tree(tree(k).NE).p;
            q3 = 1 - tree(tree(k).SE).p;
            q4 = 1 - tree(tree(k).SW).p;
            tree(k).p = 1 - q1*q2*q3*q4;
            updated = [updated k];
        end
    end
end

end