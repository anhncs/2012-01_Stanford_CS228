function features = ComputeUnconditionedSingleFeatures (y, modelParams)

nSingleFeatures = length(y) * modelParams.numHiddenStates;
features(nSingleFeatures) = EmptyFeatureStruct();

K = modelParams.numHiddenStates;
featureIdx = 0;

for st = 1:K
    paramVal = st;
    for v = 1:length(y)
        featureIdx = featureIdx + 1;
        features(featureIdx).var = v;
        features(featureIdx).assignment = st;
        features(featureIdx).paramIdx = paramVal;

    end
end

end
