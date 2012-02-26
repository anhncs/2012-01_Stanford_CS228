function features = ComputeConditionedSingletonFeatures (y, X, modelParams)

    [len, featureSize] = size(X);
    assert (len == length(y));

    K = modelParams.numHiddenStates;
    L = modelParams.numObservedStates;

    numFeatures = len * K * featureSize;
    features(numFeatures) = EmptyFeatureStruct();

    featureIdx = 0;

    for hiddenSt = 1:K
        for featureNum = 1:featureSize
            for v = 1:len
                featureIdx = featureIdx + 1;
                obs = X(v, featureNum);
                features(featureIdx).var = v;
                features(featureIdx).assignment = hiddenSt;
                features(featureIdx).paramIdx = sub2ind([L featureSize K], ...
                    obs, featureNum, hiddenSt);
            end
        end
    end

end
