% CS228 PA9 Winter 2011-2012
% File: logsumexp.m
% Copyright (C) 2012, Stanford University

function out = logsumexp(A)

% LOGSUMEXP
% Computes log( sum( exp( ) ) ) of each row in A in a way that avoids underflow.
% If A is an N x M matrix, then out is a N x 1 vector.

pi_max = max(A, [], 2);
out = pi_max + log(sum(exp(bsxfun(@minus, A, pi_max)), 2));
