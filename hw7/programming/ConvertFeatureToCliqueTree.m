%This function is to convert the feature Set into a clique trr with its
%factors filled in. The tree is a chain.
function P=ConvertFeatureToCliqueTree(y,theta,modelParams,featureSet)

P=struct('edges',[],'cliqueList',[]);
    N=length(y);
    P.edges=zeros(N-1,N-1);
    
    for i=1:N-2
        P.edges(i,i+1)=1;
        P.edges(i+1,i)=1;
    end
    
    %construc the chain structure of the tree
    P.cliqueList = repmat(struct('var', [], 'card', [],'val', []), N-1, 1);
    
    for i = 1:N-1
        P.cliqueList(i).var = [i i+1];
        P.cliqueList(i).card = [modelParams.numHiddenStates modelParams.numHiddenStates];
        P.cliqueList(i).val = ones(1, prod(P.cliqueList(i).card));
    end;
    
    N_features=length(featureSet.features);
    
    for i=1:N_features
        Current_Feature=featureSet.features(i);
        
        %find the clique index corresponding to this feature
        if(length(Current_Feature.var)==2)
            CliqueIndx=Current_Feature.var(1);
            %find the index of theat corresponding to this feature
            Para=theta(Current_Feature.paramIdx);
            %locate the entry which the feature have effect on
            ValIndx=AssignmentToIndex(Current_Feature.assignment, P.cliqueList(CliqueIndx).card);
            P.cliqueList(CliqueIndx).val(ValIndx)=P.cliqueList(CliqueIndx).val(ValIndx)*exp(Para);
        else if(Current_Feature.var(1)>1)
            CliqueIndx=Current_Feature.var(1)-1;
            %find the index of theat corresponding to this feature
            Para=theta(Current_Feature.paramIdx);
            %locate the entry which the feature have effect on
            AssignmentLength=P.cliqueList(CliqueIndx).card(1);
            Assignment=[(1:AssignmentLength)' ones(AssignmentLength,1)*Current_Feature.assignment];
            ValIndx=AssignmentToIndex(Assignment, P.cliqueList(CliqueIndx).card);
            P.cliqueList(CliqueIndx).val(ValIndx)=P.cliqueList(CliqueIndx).val(ValIndx)*exp(Para);
            else
                CliqueIndx=Current_Feature.var(1);
            %find the index of theat corresponding to this feature
            Para=theta(Current_Feature.paramIdx);
            %locate the entry which the feature have effect on
            AssignmentLength=P.cliqueList(CliqueIndx).card(1);
            Assignment=[ones(AssignmentLength,1)*Current_Feature.assignment (1:AssignmentLength)'];
            ValIndx=AssignmentToIndex(Assignment, P.cliqueList(CliqueIndx).card);
            P.cliqueList(CliqueIndx).val(ValIndx)=P.cliqueList(CliqueIndx).val(ValIndx)*exp(Para);
            end
        end
    end
