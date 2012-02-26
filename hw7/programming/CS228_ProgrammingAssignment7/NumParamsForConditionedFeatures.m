function n = NumParamsForConditionedFeatures (features, numObservedStates)

maxParam = max([features.paramIdx]);
n = maxParam + numObservedStates - 1 - mod(maxParam - 1, numObservedStates);

end
