function UpdateDecision

% Update the decision on all (leaf) nodes
% after a sensing takes place.

global tree

for i = 1:numel(tree)
    if tree(i).leaf==1
        if tree(i).TimesSensed>0
            if tree(i).p > 0.95
                tree(i).D =1;
            end
        end
    end
end

end