%MAXDECODING Finds the best assignment for each variable from the marginals M
%passed in. Returns A such that A(i) returns the index of the best
%instantiation for variable i.
%
%   For instance: Let's say we have two variables 1 and 2. 
%   Marginals for 1 = [0.1, 0.3, 0.6]
%   Marginals for 2 = [0.92, 0.08]
%   A(1) = 3, A(2) = 1.
%
%   M is a list of factors, where each factor is only over one variable.
%
%   See also COMPUTEEXACTMARGINALSBP

% CS228 Probabilistic Graphical Models(Winter 2012)
% Copyright (C) 2012, Stanford University

function A = MaxDecoding( M )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% Compute the best assignment for variables in the network.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

