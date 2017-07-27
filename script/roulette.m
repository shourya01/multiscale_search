function Z = roulette (n)

% Simulate a sensing on input node N
% Output simulation result

global tree;
global alpha;
global beta;
global targets;

a = alpha(tree(n).depth);
b = beta(tree(n).depth);

X = OnTarget (n); % Check whether our node contains the target!
rng('shuffle');
z = rand(1);

if X == 1
    if z <= b
        Z = 0;
    else
        Z = 1;
    end
else
    if z <= a
        Z = 1;
    else
        Z = 0;
    end
    
end
end

function T = OnTarget (n)

global tree;
global targets;

T = 0;

for j = 1:size(targets,1)
    if targets(j,1)>=tree(n).xmin&&tree(n).xmax>=targets(j,1)
        if targets(j,2)>=tree(n).ymin&&tree(n).ymax>=targets(j,2)
            T = 1;
        end
    end
end

end