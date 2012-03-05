% CS228 Winter 2011-2012
% File: FitLinearGaussianParameters.m
% Copyright (C) 2012, Stanford University
% Huayan Wang

function [Beta sigma] = FitLinearGaussianParameters(X, U)

% Estimate parameters of the linear Gaussian model:
% X|U ~ N(Beta(1)*U(1) + ... + Beta(n)*U(n) + Beta(n+1), sigma^2);

% Note that Matlab/Octave index from 1, we can't write Beta(0).
% So Beta(n+1) is essentially Beta(0) in the text book.

% X: (M x 1), the child variable, M examples
% U: (M x N), N parent variables, M examples

M = size(U,1);
N = size(U,2);

%Beta = zeros(N+1,1);
%sigma = 1;

% collect expectations and solve the linear system
% A = [ E[U(1)],      E[U(2)],      ... , E[U(n)],      1     ; 
%       E[U(1)*U(1)], E[U(2)*U(1)], ... , E[U(n)*U(1)], E[U(1)];
%       ...         , ...         , ... , ...         , ...   ;
%       E[U(1)*U(n)], E[U(2)*U(n)], ... , E[U(n)*U(n)], E[U(n)] ]

% construct A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = zeros(N+1,N+1);
A(1,N+1) = 1;
for i=1:N
    A(1,i) = mean(U(:,i));
    A(i+1,N+1) = A(1,i);
end
for i=2:N+1
    for j=1:N
        A(i,j) = (U(:,j)'*U(:,i-1))/M;
    end
end

% B = [ E[X]; E[X*U(1)]; ... ; E[X*U(n)] ]

% construct B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
B = zeros(N+1,1);
B(1,1) = mean(X);
for i=2:N+1
    B(i,1) = (X'*U(:,i-1))/M;
end

% solve A*Beta = B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Beta = A\B;

% then compute sigma according to eq. (11) in PA description
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temp = X'*X/M - mean(X)*mean(X);
for i=1:N
    for j=1:N
        temp = temp - Beta(i,1)*Beta(j,1)*(U(:,i)'*U(:,j)/M - mean(U(:,i))*mean(U(:,j)));
    end
end
sigma = sqrt(temp);


