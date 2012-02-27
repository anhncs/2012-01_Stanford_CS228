% function [nll, grad] = InstanceNegLogLikelihood(X, y, theta, modelParams)
% returns the negative log-likelihood and its gradient, given a CRF with parameters theta,
% on data (X, y). 
%
% Inputs:
% X            Data.                           (numInstances x numImageFeatures matrix)
%              X(:,1) is all ones, i.e., it encodes the intercept/bias term.
% y            Data labels.                    (numInstances x 1 vector)
% theta        CRF weights/parameters.         (numParams x 1 vector)
%              These are shared among the various singleton / pairwise features.
% modelParams  Struct with two fields:
%   .numHiddenStates     in our case, set to 26 (26 possible characters)
%   .numObservedStates   in our case, set to 2  (each pixel is either on or off)
%
% Outputs:
% nll          Negative log-likelihood of the data.    (scalar)
% grad         Gradient of nll with respect to theta   (numParams x 1 vector)

function [nll, grad] = InstanceNegLogLikelihood(X, y, theta, modelParams)
% [nll_debug, grad_debug] = InstanceNegLogLikelihood(sampleX, sampleY, sampleTheta, sampleModelParams)
    % featureSet is a struct with two fields:
    %    .numParams - the number of parameters in the CRF (this is not numImageFeatures
    %                 nor numFeatures, because of parameter sharing)
    %    .features  - an array comprising the features in the CRF.
    %
    % Each feature is a binary indicator variable, represented by a struct 
    % with three fields:
    %    .var          - a vector containing the variables in the scope of this feature
    %    .assignment   - the assignment that this indicator variable corresponds to
    %    .paramIdx     - the index in theta that this feature corresponds to
    %
    % For example, if we have:
    %   
    %   feature = struct('var', [2 3], 'assignment', [5 6], 'paramIdx', 8);
    %
    % then feature is an indicator function over X_2 and X_3, which takes on a value of 1
    % if X_2 = 5 and X_3 = 6 (which would be 'e' and 'f'), and 0 otherwise. 
    % Its contribution to the log-likelihood would be theta(8) if it's 1, and 0 otherwise.
    %
    % If you're interested in the implementation details of CRFs, 
    % feel free to read through GenerateAllFeatures.m and the functions it calls!
    % For the purposes of this assignment, though, you don't
    % have to understand how this code works. (It's complicated.)
    
    featureSet = GenerateAllFeatures(X, y, modelParams);
    %featureSet = GenerateAllFeatures(sampleX, sampleY, sampleModelParams);

    % Use the featureSet to calculate nll and grad.
    % This is the main part of the assignment, and it is very tricky - be careful!
    % You might want to code up your own numerical gradient checker to make sure
    % your answers are correct.
    %
    % Hint: you can use CliqueTreeCalibrate to calculate logZ effectively. 
    %       We have halfway-modified CliqueTreeCalibrate; complete our implementation 
    %       if you want to use it to compute logZ.
    %%%
    % Your code here:
    
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
    
    grad = modelParams.lambda * theta; 
    nll =  modelParams.lambda/2 * sum(theta.^2);
    for i=1:length(featureSet.features)
        indicator = 1;
        for j=1:length(featureSet.features(i).var)
            indicator = indicator*( y(featureSet.features(i).var(j)) == featureSet.features(i).assignment(j) );
        end
        nll = nll - theta(featureSet.features(i).paramIdx)*indicator;       
        grad(featureSet.features(i).paramIdx) = grad(featureSet.features(i).paramIdx) - indicator;
        % Start to construct the uncalibratedTree
        
        Current_Feature=featureSet.features(i);        
        %find the clique index corresponding to this feature
        if(length(Current_Feature.var)==2)
            CliqueIndx=Current_Feature.var(1);
            %find the index of theat corresponding to this feature
            Para=theta(Current_Feature.paramIdx);
            %locate the entry which the feature have effect on
            ValIndx=AssignmentToIndex(Current_Feature.assignment, UncalibratedTree.cliqueList(CliqueIndx).card);
            UncalibratedTree.cliqueList(CliqueIndx).val(ValIndx)=UncalibratedTree.cliqueList(CliqueIndx).val(ValIndx)*exp(Para);
        elseif(Current_Feature.var(1)>1)
            CliqueIndx=Current_Feature.var(1)-1;
            %find the index of theat corresponding to this feature
            Para=theta(Current_Feature.paramIdx);
            %locate the entry which the feature have effect on
            AssignmentLength=UncalibratedTree.cliqueList(CliqueIndx).card(1);
            Assignment=[(1:AssignmentLength)' ones(AssignmentLength,1)*Current_Feature.assignment];
            ValIndx=AssignmentToIndex(Assignment, UncalibratedTree.cliqueList(CliqueIndx).card);
            UncalibratedTree.cliqueList(CliqueIndx).val(ValIndx)=UncalibratedTree.cliqueList(CliqueIndx).val(ValIndx)*exp(Para);
         else
                CliqueIndx=Current_Feature.var(1);
            %find the index of theat corresponding to this feature
            Para=theta(Current_Feature.paramIdx);
            %locate the entry which the feature have effect on
            AssignmentLength=UncalibratedTree.cliqueList(CliqueIndx).card(1);
            Assignment=[ones(AssignmentLength,1)*Current_Feature.assignment (1:AssignmentLength)'];
            ValIndx=AssignmentToIndex(Assignment, UncalibratedTree.cliqueList(CliqueIndx).card);
            UncalibratedTree.cliqueList(CliqueIndx).val(ValIndx)=UncalibratedTree.cliqueList(CliqueIndx).val(ValIndx)*exp(Para);
         end
    end
    [CalibratedTree, logZ] = CliqueTreeCalibrate(UncalibratedTree, 0);
    nll = nll +logZ;
    
    % Performing the inference for the data instance in order to calcuate
    % E_theta[f_i] = sum_Y P(Y'|x)f_i(Y'|x) using CalibratedTree
    FeatureToPara=cell(1,length(theta));
    N_features=length(featureSet.features);
    for i=1:N_features
        indx=featureSet.features(i).paramIdx;
        FeatureToPara{indx}=[FeatureToPara{indx} i];
    end
    N=length(y);
    ModelFeatureCounts = zeros(1, length(theta));
    MarginalSingle = cell(1, N);
    MarginalPair = cell(1, N-1);
    for i = 1:N
        CliqueIndx=max(i-1,1);
        MarginalSingle{i} = FactorMarginalization(CalibratedTree.cliqueList(CliqueIndx),setdiff(CalibratedTree.cliqueList(CliqueIndx).var, i));
        MarginalSingle{i}.val = MarginalSingle{i}.val / sum(MarginalSingle{i}.val);
        if (i < N)
            MarginalPair{i} = CalibratedTree.cliqueList(i);
            MarginalPair{i}.val = MarginalPair{i}.val / sum(MarginalPair{i}.val);
        end
    end
    
    for i = 1:length(theta) 
        for j = 1:length(FeatureToPara{i})
            idx = FeatureToPara{i}(j);
            feature = featureSet.features(idx);
            if (length(feature.var) == 1)
                v = GetValueOfAssignment(MarginalSingle{feature.var(1)}, feature.assignment);
                ModelFeatureCounts(i) = ModelFeatureCounts(i) + v;
            else
                v = GetValueOfAssignment(MarginalPair{feature.var(1)}, feature.assignment);
                ModelFeatureCounts(i) = ModelFeatureCounts(i) + v;
            end       
        end
    end
    
    grad = grad + ModelFeatureCounts;
end

