% ExtraCredit.m
% If you choose to do the extra credit portion of this assignment, you
% should do two things:
% 1) Call the function SaveECPredictions(yourPredictions).
%      `yourPredictions' should be an 80x3 matrix where
%      yourPredictions(i,j) is the predicted value (1-26) of the j'th
%      character in the i'th word. That is, the predicted value for
%      testData(i).y(j).
% 2) Copy and paste the contents of any new files you have written into
%    this file. The `submit' script needs to know the filenames in advance
%    when we collect your code, but we want to allow you to structure your
%    code any way you like. By copying those new files into this file, we
%    will collect this file and have your code.

% Copy function definitions (or just command scripts) here:
clear;
load Part2FullDataset.mat;
load Part2Sample.mat;
sampleModelParams.lambda = 0.003;
gradFn = @(theta, i) CostOCR(trainData, theta, sampleModelParams, i);

theta0 = zeros(1,2366);
thetaOpt = StochasticGradientDescent(gradFn, theta0, 50000);
    
TrainPredict = 0;
TrainYEst = zeros(length(trainData),3);
for i=1:length(trainData)
   TrainYEst(i,:) = PredictOCR(trainData(i).X, thetaOpt, sampleModelParams);
   if(sum(abs(trainData(i).y - TrainYEst(i,:))) == 0)
        TrainPredict = TrainPredict + 1
        i
   end
end
TrainPredict_percent = 100*(TrainPredict/length(trainData))


TestYEst = zeros(length(testData),3);
for i=1:length(testData)
    TestYEst(i,:) = PredictOCR(testData(i).X, thetaOpt, sampleModelParams);
end
SaveECPredictions(TestYEst);

% function [cost, grad] = CostOCR(TrainData, theta, modelParams, i)
%     i = mod(i, length(TrainData)) + 1;
%     [cost, grad] = InstanceNegLogLikelihood(TrainData(i).X, TrainData(i).y, theta, modelParams);
% end

% 
% 
% function pred = PredictOCR(X, theta, modelParams)
%     pred(1) = 1;
%     pred(2) = 2;
%     pred(3) = 3;
%     featureSet = GenerateAllFeatures(X, pred, modelParams);
%     y = pred;
%     UncalibratedTree = struct('cliqueList',[],'edges',[]);
%     UncalibratedTree.cliqueList = repmat(struct('var',[],'card',[],'val',[]),length(y)-1,1);
%     UncalibratedTree.edges = zeros(length(y)-1, length(y)-1);
%     for i=1:length(y)-1
%         if( i~=(length(y)-1) )
%             UncalibratedTree.edges(i, i+1) = 1;
%             UncalibratedTree.edges(i+1, i) = 1;
%         end
%         UncalibratedTree.cliqueList(i).var = [i i+1];
%         UncalibratedTree.cliqueList(i).card = [modelParams.numHiddenStates modelParams.numHiddenStates];
%         UncalibratedTree.cliqueList(i).val = ones(1, prod(UncalibratedTree.cliqueList(i).card));
%     end 
%     
%     for i=1:length(featureSet.features)
%         
%         % Start to construct the uncalibratedTree
%         % P = exp(sum_i theta_i*f_i)
%         
%         % This is the factor of two adjacent variable
%         if(length(featureSet.features(i).var)==2)
%             indx_clique = min(featureSet.features(i).var);
%             assignment = featureSet.features(i).assignment;
%         elseif(featureSet.features(i).var(1)>1)
%             indx_clique=featureSet.features(i).var(1)-1;
%             AssignmentLength=UncalibratedTree.cliqueList(indx_clique).card(1);
%             assignment=[(1:AssignmentLength)' ones(AssignmentLength,1)*featureSet.features(i).assignment];
%          else
%             indx_clique=featureSet.features(i).var(1);
%             AssignmentLength=UncalibratedTree.cliqueList(indx_clique).card(1);
%             assignment=[ones(AssignmentLength,1)*featureSet.features(i).assignment (1:AssignmentLength)'];
%         end
%          indx = AssignmentToIndex(assignment, UncalibratedTree.cliqueList(indx_clique).card);
%          UncalibratedTree.cliqueList(indx_clique).val(indx) = UncalibratedTree.cliqueList(indx_clique).val(indx)*exp(theta(featureSet.features(i).paramIdx));
%     end
%     [CalibratedTree, logZ] = CliqueTreeCalibrate(UncalibratedTree, 0);
%     factors = FactorProduct(CalibratedTree.cliqueList(1),CalibratedTree.cliqueList(2));
%     [max_P indx] = max(factors.val);
%     pred = IndexToAssignment(indx, [26 26 26]);
% end
