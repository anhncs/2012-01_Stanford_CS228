%COMPUTEEXACTMARGINALSBP Runs exact inference and returns the marginals
%over all the variables (if isMax == 0) or the max-marginals (if isMax == 1). 
%
%   M = COMPUTEEXACTMARGINALSBP(F, E, isMax) takes a list of factors F,
%   evidence E, and a flag isMax, runs exact inference and returns the
%   final marginals for the variables in the network. If isMax is 1, then
%   it runs exact MAP inference, otherwise exact inference (sum-prod).
%   It returns an array of size equal to the number of variables in the 
%   network where M(i) represents the ith variable and M(i).val represents 
%   the marginals of the ith variable. 


% CS228 Probabilistic Models in AI (Winter 2012)
% Copyright (C) 2012, Stanford University

function M = ComputeExactMarginalsBP(F, E, isMax)

% Since we only need marginals at the end, you should M as:
%
% M = repmat(struct('var', 0, 'card', 0, 'val', []), length(N), 1);
%
% where N is the number of variables in the network, which can be determined
% from the factors F.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Implement Exact and MAP Inference.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


VarList=[];

for i=1:length(F)
    VarList=union(VarList,F(i).var);
end

N=length(VarList);
M = repmat(struct('var', 0, 'card', 0, 'val', []), N, 1);

P = CreateCliqueTree(F, E);
P = CliqueTreeCalibrate(P, isMax);

for i=1:N
    for j=1:length(P.cliqueList)
        if(ismember(VarList(i),P.cliqueList(j).var))
            if(~isMax)
            M(i)=FactorMarginalization(P.cliqueList(j), setdiff(P.cliqueList(j).var,VarList(i)));
            M(i).val=M(i).val./sum(M(i).val);
            else
                M(i)=FactorMaxMarginalization(P.cliqueList(j), setdiff(P.cliqueList(j).var,VarList(i)));
            end
            break;
        end
    end
end






end
