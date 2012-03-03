% CS228 Winter 2011-2011
% File: GaussianMutualInformation.m
% Copyright (C) 2012, Stanford University
% Huayan Wang

function I = GaussianMutualInformation(X, Y)

if isequal(X,Y)
    I = 0;
    return;
end
% X: (N x D1), D1 dimensions, N samples 
% Y: (N x D2), D2 dimensions, N samples

% I(X, Y) = 1/2 * log( | Sigma_XX | * | Sigma_YY | / | Sigma |)
% Sigma = [ Sigma_XX, Sigma_XY ; 
%           Sigma_XY, Sigma_YY ]

Sxx = cov(X);
Syy = cov(Y);
S = cov([X,Y]);
I = .5*log(det(Sxx)*det(Syy)/det(S));