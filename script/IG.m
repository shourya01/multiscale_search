function S = IG (n)

% Calculate expected IG for a node
% Use optimization for top down updation
% mentioned in the report

global tree;
global alpha;
global beta;

a = alpha(tree(n).depth);
b = beta(tree(n).depth);
p = tree(n).p;
q = 1-p;

S1 = (q*(1-a)+p*b)*IGif(n,1) + (q*a+p*(1-b))*IGif(n,0);

if tree(n).leaf == 1
    SYSENT = entropy(tree(n).p);
else
    CHILD = FindChildNodes(n);
    SYSENT = entropy([tree(CHILD).p]);
end

S = SYSENT - S1;

end

function H = IGif (n,z)

global tree;
global alpha;
global beta;

a = alpha(tree(n).depth);
b = beta(tree(n).depth);
p = tree(n).p;
q = 1-p;

if tree(n).leaf == 1
    if z == 0
        p1 = b*p/(q*(1-a)+p*b);
        H = entropy(p1);
        return;
    else
        p1 = (1-b)*p/(q*a+p*(1-b));
        H = entropy(p1);
        return;
    end
else
    if z == 0
        p1 = b*p/(q*(1-a)+p*b);
        k = log(p1)/log(p);
        if isnan(k)||isinf(k)
            k = 1;
        end
    else
        p1 = (1-b)*p/(q*a+p*(1-b));
        k = log(p1)/log(p);
        if isnan(k)||isinf(k)
            k = 1;
        end
    end
    W = FindChildNodes(n);
    P = [tree(W).p];
    P1 = P.^k;
    H = entropy(P1);
    return;
end
end
