%CLIQUETREECALIBRATE Performs sum-product or max-product algorithm for 
%clique tree calibration.

%   P = CLIQUETREECALIBRATE(P, isMax) calibrates a given clique tree, P 
%   according to the value of isMax flag. If isMax is 1, it uses max-sum
%   message passing, otherwise uses sum-product. This function 
%   returns the clique tree where the .val for each clique in .cliqueList
%   is set to the final calibrated potentials.

% CS228 Probabilistic Models in AI (Winter 2012)
% Copyright (C) 2012, Stanford University

function P = CliqueTreeCalibrate(P, isMax)


% Number of cliques in the tree.
N = length(P.cliqueList);

% Setting up the messages that will be passed.
% MESSAGES(i,j) represents the message going from clique i to clique j. 
MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% While there are ready cliques to pass messages between, keep passing
% messages. Use GetNextCliques to find cliques to pass messages between.
% Once you have clique i that is ready to send message to clique
% j, compute the message and put it in MESSAGES(i,j).
% Remember that you only need an upward pass and a downward pass.
%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(isMax==0)
[i j]=GetNextCliques(P, MESSAGES);

while (i~=0)
    V=setdiff(P.cliqueList(i).var,P.cliqueList(j).var);
    factor=P.cliqueList(i);
    
    indx=setdiff(find(P.edges(:,i)),j);
    for k=1:length(indx)
                factor=FactorProduct(factor, MESSAGES(indx(k),i));
    end
    
    MESSAGES(i,j)=FactorMarginalization(factor, V);
    MESSAGES(i,j).val=MESSAGES(i,j).val./sum(MESSAGES(i,j).val);
    
    [i j]=GetNextCliques(P, MESSAGES);
end
    
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Now the clique tree has been calibrated. 
% Compute the final potentials for the cliques and place them in P.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:N
    factor=P.cliqueList(i);
    for j=1:N
        factor=FactorProduct(factor, MESSAGES(j,i));
    end
    P.cliqueList(i)=factor;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else if(isMax==1)
    
    [i j]=GetNextCliques(P, MESSAGES);

while (i~=0)
    
    factor=P.cliqueList(i);
    factor.val=log(factor.val);
    
    indx=P.edges(i,:);
    
        for k=1:N
            if(indx(k)==0||k==j)
                continue;
            end
                factor=FactorSum(factor, MESSAGES(k,i));
        end
 
    V=setdiff(factor.var,P.cliqueList(j).var);
    MESSAGES(i,j)=FactorMaxMarginalization(factor, V);
    
    [i j]=GetNextCliques(P, MESSAGES);
end

for i=1:N
    factor=P.cliqueList(i);
    factor.val=log(factor.val);
    
    indx=P.edges(i,:);
    
        for k=1:N
            if(indx(k)==0)
                continue;
            end
                factor=FactorSum(factor,MESSAGES(k,i));
        end
    
    P.cliqueList(i)=factor;
end

    end
end

return
