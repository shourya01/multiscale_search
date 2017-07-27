function  SearchCriteriaSatisfied

% Stopping criteria + plot U(T) continuously
% setting variable STOP stops the mission

global tree;
global searchCriteriaBound;
global simTrajectory;
global UTrajectory;
global STOP;

sumHT = GetEntropy;
MAXH = 0;
for k = 1:numel(tree)
    if tree(k).leaf == 1
        ISMAX = GetEntropy(k);
        if ISMAX > MAXH
            MAXH = ISMAX;
        end
    end
end
NUM = sum([tree(:).leaf]);

U = sumHT/(MAXH*NUM);
UTrajectory = [UTrajectory U];

searchCriteriaBound = 0.03;

figure(2);
hold on;
xlim([0,500]);
plot(numel(simTrajectory),U,'b--o','MarkerSize',3);

if U < searchCriteriaBound
    STOP = 1;
else
    STOP = 0;
end

end