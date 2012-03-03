% CS228 Winter 2011-2012
% File: SampleMultinomial.m
% Copyright (C) 2012, Stanford University
% Huayan Wang

function sample = SampleMultinomial(probabilities)

dice = rand(1,1);
accumulate = 0;
for i=1:length(probabilities)
    accumulate = accumulate + probabilities(i);
   if accumulate/sum(probabilities) > dice
       break
   end
end
sample = i;


