% this script makes a prior for the simulation
% right now nout being used

pDepth = 4;
pData = (3/(2^(pDepth-1)))*ones(2^(pDepth-1),(2^pDepth-1)); % Uniform Prior

save('prior.mat','pDepth','pData');