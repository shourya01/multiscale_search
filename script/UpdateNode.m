function UpdateNode (n,z)

% Update node n when a sensing takes place on it
% Sensing result stored in z

global tree;
global alpha;
global beta;

prob = tree(n).p;
a = alpha(tree(n).depth);
b = beta(tree(n).depth);

if z == 0
    tree(n).p = (b*prob)/((1-a)*(1-prob)+b*prob);
else
    tree(n).p = ((1-b)*prob)/((1-prob)*(a)+prob*(1-b));
end

p = tree(n).p;
k = log(p)/log(prob);
if isnan(k)||isinf(k)
    k = 1;
end

UpdateDownwards(n,k);
CheckConsistency;

end

% FUNCTION TO UPDATE UPWARDS FROM A NODE

function UpdateDownwards (n,k)

global tree;

CHILD = FindAllChildren(n);
CHILD = setdiff(CHILD,n);

for i = 1:numel(CHILD)
    p1 = tree(CHILD(i)).p;
    tree(CHILD(i)).p = p1^k;
end
end

function Z = FindAllChildren (n)

global tree;

if tree(n).leaf == 1
    Z = n;
    return;
end

Z = [n,FindAllChildren(tree(n).NW),FindAllChildren(tree(n).NE),...
    FindAllChildren(tree(n).SE),FindAllChildren(tree(n).SW)];

end