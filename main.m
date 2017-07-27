clear all; close all; clc;
addpath('script');

% Simulate search using probabilistic quadtrees
% Just run it and relax
% Or change parameters

global tree; % data structure for pqtree
global alpha; % sensor alpha
global beta; % sensor beta
global maxDepth; % 1 is root depth (not 0), 2^maxDepth->side of square region
global cost_ascend; % searcher ascend cost
global bonus_descent; % searcher descent bonus
global VarWeight; % Make it 0.2 to have certain degree of randomness in the searcher's motion
global targets; % targets in format [x1,y1;x2,y2;x3,y3;...]
global maxTime; % maximum allowable time
global simTrajectory; % history of simulation results
global locTrajectory; % ??
global UTrajectory; % history of U(T) results
global searchCriteriaBound; % epsilon for stopping criterion
global lambda; % weight between distance and IG
global COSTval; % ??
global STOP; % Emergency brake. Set to 1 to stop the train
global c00; % Costs for decision making
global c01; % "
global c10; % "
global c11; % "
global thresh_upper; % Upper threshold for declaring cell occupied
global thresh_lower; % Lower threshold for declaring cell empty
% All 4 buffers are used for data logging
global buffer1; % Used to record costs in FindMaxLocation
global buffer2; % UNUSED
global buffer3; % DON'T USE. Used by healthcheck to dump data
global buffer4; % UNUSED

% Define basic variables

maxDepth = 7;
maxTime = 10000;
searchCriteriaSatisfied = 1.1;
c00 = 0;
c11 = 0;
c01 = 100;
c10 = 100;
COSTval = [];
thresh_upper = 0.990;
thresh_lower = 0.001;
lambda = 0.6;
locTrajectory = [];
VarWeight = 0;
UTrajectory = [];
STOP = 0;

% Define targets and costs

L = 2^maxDepth;
targets = [0.21*L,0.27*L;0.42114*L,0.3166*L;0.712*L,0.113*L];
cost_ascend = 0.2*L;
bonus_descent = 0.15*L;

% Sensor performance
% alpha(depth) gives alpha at that depth

x = 1:10;
alpha = 0.2-0.01*x;
beta = 0.3-0.02*x;

% Create the root of current pqtree

root = CreateNode(0,0.5,0);
root.xmin = 0;
root.xmax = 2^maxDepth;
root.ymin = 0;
root.ymax = 2^maxDepth;
root.xc = (root.xmax+root.xmin)/2;
root.yc = (root.ymax+root.ymin)/2;

tree = [root];

% Priors are loaded from a 'prior.mat'
% 'prior.mat' contains 2 variables
% 'pDepth'->depth at which prior data is provided
% 'pData'->2^(pDepth)x2^(pDepth) matrix containing prior value at leafs

GeneratePrior;

data = load('prior.mat');

BuildTreeMaxDepth(data);

% Start simulation

ncurr=1;
nnext=1;
COSTnext=0;
COST=0;

fig = figure(1);

for j = 1:maxTime
    locTrajectory = [locTrajectory ncurr];
%     if j==5 % DIAGNOSTIC STUFF
%         buffer1 = tree;
%         buffer2 = ncurr;
%     end
    z = roulette(ncurr); % Simulate sensing on current node
    simTrajectory = [simTrajectory z];
    tree(ncurr).TimesSensed = tree(ncurr).TimesSensed+1;
    if tree(ncurr).leaf == 1
        SplitNode(tree(nnext).depth+1,nnext);
    end
    UpdateNode(ncurr,z);
    UpdateDecision;
    [nnext,COSTnext] = FindMaxLocation(ncurr);
    COSTval = [COSTval COSTnext];
    SearchCriteriaSatisfied
    if STOP == 1
        sprintf('Search Criteria Satisfied.\n');
        break;
    end
    fig = figure(1);
    DrawQuadtree(ncurr,fig,j);
    ncurr=nnext;
%     if j==5 % DIAGNOSTIC STUFF
%         %        HealthCheck;
%     end
end

DisplayResults;

% -------------------------------------------------------------------------

function DisplayResults

% Display reults of search 

global tree;
for k = 1:numel(tree)
    if tree(k).D == 1
        sprintf('Target found at (%d,%d).\n',tree(k).xc,tree(k).yc);
    end
end
end
