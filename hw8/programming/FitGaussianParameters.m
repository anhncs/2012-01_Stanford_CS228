% CS228 Winter 2011-2012
% File: FitGaussianParameters.m
% Copyright (C) 2012, Stanford University
% Huayan Wang

function [mu sigma] = FitGaussianParameters(X)

% X: (N x 1): N examples (1 dimensional)
% Fit N(mu, sigma^2) to the empirical distribution
%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%
mu = mean(X);
sigma = sqrt(cov(X,1));