% function err = LRAccuracy(GroundTruth, Predictions) compares the 
% vector of predictions with the vector of ground truth values, 
% and returns the error rate.
%
% Input:
% GroundTruth    (numInstances x 1 vector) 
% Predictions    (numInstances x 1 vector) 
%
% Output:
% err            (scalar between 0 and 1 inclusive)

function err = LRAccuracy(GroundTruth, Predictions)

    GroundTruth = GroundTruth(:);
    Predictions = Predictions(:);
    assert(all(size(GroundTruth) == size(Predictions)));

    err = 1 - (sum(GroundTruth ~= Predictions) / length(GroundTruth));

end
