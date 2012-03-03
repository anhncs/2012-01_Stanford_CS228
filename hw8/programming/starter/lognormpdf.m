% CS228 PA8 Winter 2011-2012
% File: lognormpdf.m
% Copyright (C) 2012, Stanford University

function val = lognormpdf(x, mu, sigma)
val = - (x - mu).^2 / (2*sigma^2) - log (sqrt(2*pi) * sigma);