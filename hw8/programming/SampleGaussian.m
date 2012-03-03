% CS228 Winter 2011-2012
% File: SampleGuassian.m
% Copyright (C) 2012, Stanford University
% Huayan Wang

function sample = SampleGaussian(mu, sigma)

% sample from the Gaussian distribution specifed by mean value mu and standard deviation sigma

    sample = mu + sigma*randn(1,1);
