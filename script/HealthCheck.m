function HealthCheck

% HealthCheck Script
% CHECKS FOR
% Number of leafs and nodes at any point of time
% Checks tree consistency
% See if updating a node is changing values outside the
% node's region.
% Script throws errors if any one of the above is missing.
% There are 3 buffer variables that can be used to dump stuff.

clc;

% REQUIREMENTS
% Dump the entire tree in buffer1 before updating it.
% Dump the current node value in buffer2.
% buffer3 is used to output stuff

global tree;
global buffer1;
global buffer2;
global buffer3;

NumberOfErrors = 0;

% Welcome

clc;
sprintf('Welcome to HealthCheck. Press any key to continue.\n');
pause;

% Test for number of leaves, nodes and internal nodes

sprintf('Number of leaves is %d\n',numel(tree));
sprintf('Number of nodes is %d\n',sum([tree(:).leaf]));
sprintf('Number of internal nodes is %d\n',numel(tree)-sum([tree(:).leaf]));

% Check for quadtree consistency
% Do not use buffer1 to check consistency - use tree

ConsistencyError = CheckConsistency(1); % Root node consistency implies tree consistency
if ConsistencyError > 0
%    error('Consistency Error!');
    NumberOfErrors = NumberOfErrors + ConsistencyError;
    c{1} = 'CONSISTENCY ERRORS FOUND!';
    buffer3 = [buffer3 c];
end

% Check for non-sensed node violation

CurrentNode = buffer2;
SensedLeafNodes = FindChildNodes (CurrentNode);
LeafNodes = find([tree(:).leaf]);
NonSensedNodes = setdiff(LeafNodes,SensedLeafNodes);
NonSensedNodesP_old = [buffer1([NonSensedNodes]).p];
NonSensedNodesP_new = [tree([NonSensedNodes]).p];

if norm(NonSensedNodesP_new-NonSensedNodesP_old) > 0.1
%    error('Nodes outside sensing area have been updated!');
    C{1} = 'ERROR IN SENSING OUTSIDE NODES!';
    buffer3 = [buffer3 C];
    NumberOfErrors = NumberOfErrors + 1;
end

% Empty the buffers, buffer3 stays

buffer1 = [];
buffer2 = [];

if NumberOfErrors > 0
    error('Stop! You have errors!');
end

end

function T = CheckConsistency (n)

% DEPRECATED
% USE MAIN CheckConsistency SCRIPT

global tree;
global buffer3;

if tree(n).leaf == 1
    T = 0;
    return;
end

Z = 0;
q1 = 1 - tree(tree(n).NW).p;
q2 = 1 - tree(tree(n).NE).p;
q3 = 1 - tree(tree(n).SE).p;
q4 = 1 - tree(tree(n).SW).p;
q = 1 - tree(n).p;

if abs(q - (q1*q2*q3*q4)) < 1e-3
    Z = 0;
else
    Z = 1;
    C{1} = [n,tree(n).NW,tree(n).NE,tree(n).SE,tree(n).SW,...
        q,q1,q2,q3,q4,abs(q-q1*q2*q3*q4),tree(n).depth,tree(tree(n).NW).depth];
    buffer3 = [buffer3 C];
end

T = Z + CheckConsistency(tree(n).NW) + CheckConsistency(tree(n).NE) +...
    CheckConsistency(tree(n).SE) + CheckConsistency(tree(n).SW);

end



    