
function pred = PredictOCR(X, theta, modelParams)
    pred(1) = 1;
    pred(2) = 2;
    pred(3) = 3;
    featureSet = GenerateAllFeatures(X, pred, modelParams);
    y = pred;
    UncalibratedTree = struct('cliqueList',[],'edges',[]);
    UncalibratedTree.cliqueList = repmat(struct('var',[],'card',[],'val',[]),length(y)-1,1);
    UncalibratedTree.edges = zeros(length(y)-1, length(y)-1);
    for i=1:length(y)-1
        if( i~=(length(y)-1) )
            UncalibratedTree.edges(i, i+1) = 1;
            UncalibratedTree.edges(i+1, i) = 1;
        end
        UncalibratedTree.cliqueList(i).var = [i i+1];
        UncalibratedTree.cliqueList(i).card = [modelParams.numHiddenStates modelParams.numHiddenStates];
        UncalibratedTree.cliqueList(i).val = ones(1, prod(UncalibratedTree.cliqueList(i).card));
    end 
    
    for i=1:length(featureSet.features)
        
        % Start to construct the uncalibratedTree
        % P = exp(sum_i theta_i*f_i)
        
        % This is the factor of two adjacent variable
        if(length(featureSet.features(i).var)==2)
            indx_clique = min(featureSet.features(i).var);
            assignment = featureSet.features(i).assignment;
        elseif(featureSet.features(i).var(1)>1)
            indx_clique=featureSet.features(i).var(1)-1;
            AssignmentLength=UncalibratedTree.cliqueList(indx_clique).card(1);
            assignment=[(1:AssignmentLength)' ones(AssignmentLength,1)*featureSet.features(i).assignment];
         else
            indx_clique=featureSet.features(i).var(1);
            AssignmentLength=UncalibratedTree.cliqueList(indx_clique).card(1);
            assignment=[ones(AssignmentLength,1)*featureSet.features(i).assignment (1:AssignmentLength)'];
        end
         indx = AssignmentToIndex(assignment, UncalibratedTree.cliqueList(indx_clique).card);
         UncalibratedTree.cliqueList(indx_clique).val(indx) = UncalibratedTree.cliqueList(indx_clique).val(indx)*exp(theta(featureSet.features(i).paramIdx));
    end
    [CalibratedTree, logZ] = CliqueTreeCalibrate(UncalibratedTree, 0);
    factors = FactorProduct(CalibratedTree.cliqueList(1),CalibratedTree.cliqueList(2));
    [max_P indx] = max(factors.val);
    pred = IndexToAssignment(indx, [26 26 26]);
end

