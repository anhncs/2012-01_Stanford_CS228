% CS228 Winter 2011-2012
% File: LearnCPDsGivenGraph.m
% Copyright (C) 2012, Stanford University
% Huayan Wang

function [P loglikelihood] = LearnCPDsGivenGraph(dataset, G, labels)
%
% Inputs:
% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha)
% G: graph parameterization as explained in PA description
% labels: N x 2 true class labels for the examples. labels(i,j)=1 if the 
%         the ith example belongs to class j and 0 elsewhere        
%
% Outputs:
% P: struct array parameters (explained in PA description)
% loglikelihood: log-likelihood of the data (scalar)


N = size(dataset, 1);
K = size(labels,2);

%loglikelihood = 0;
P.c = zeros(1,K);

% estimate parameters
% fill in P.c, MLE for class probabilities
% fill in P.clg for each body part and each class
% choose the right parameterization based on G(i,1)
% compute the likelihood - you may want to use ComputeLogLikelihood.m
% you just implemented.
%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:K
    P.c(i) = sum(labels(:,i))/size(labels,1);
end
P.clg = repmat(struct('mu_y', [], 'sigma_y', [], 'mu_x', [],'sigma_x',[],'mu_angle',[],'sigma_angle',[],'theta',[]), 1, size(dataset, 2));

for i=1:size(dataset,2)
    for j=1:K
        condition = 0;
        if length(size(G)) == 2
            if G(i,1)>0
                pNode = G(i,2);
                    condition = 1;
            end
        elseif length(size(G)) == 3
            if G(i,1,j) > 0
                pNode = G(i,2,j);
                condition = 1;
            end
        end
        indx = find(labels(:,j));
        if condition == 0;
            if j==1
                P.clg(i).mu_y = zeros(1,K);
                P.clg(i).sigma_y = zeros(1,K);
                P.clg(i).mu_x = zeros(1,K);
                P.clg(i).sigma_x = zeros(1,K);
                P.clg(i).mu_angle = zeros(1,K);
                P.clg(i).sigma_angle = zeros(1,K);
            end
            [P.clg(i).mu_y(j),     P.clg(i).sigma_y(j)]     = FitGaussianParameters(dataset(indx,i,1));
            [P.clg(i).mu_x(j),     P.clg(i).sigma_x(j)]     = FitGaussianParameters(dataset(indx,i,2));
            [P.clg(i).mu_angle(j), P.clg(i).sigma_angle(j)] = FitGaussianParameters(dataset(indx,i,3));
        else
            if j==1
                P.clg(i).sigma_y = zeros(1,K);
                P.clg(i).sigma_x = zeros(1,K);
                P.clg(i).sigma_angle = zeros(1,K);
                P.clg(i).theta = zeros(2,12);
            end
            pData = [dataset(indx,pNode,1), dataset(indx,pNode,2), dataset(indx,pNode,3)];
            [Beta, P.clg(i).sigma_y(j)]     = FitLinearGaussianParameters(dataset(indx,i,1), pData);
            P.clg(i).theta(j,1)  = Beta(4);
            P.clg(i).theta(j,2)  = Beta(1);             
            P.clg(i).theta(j,3)  = Beta(2);
            P.clg(i).theta(j,4)  = Beta(3);
            [Beta, P.clg(i).sigma_x(j)]     = FitLinearGaussianParameters(dataset(indx,i,2), pData);
            P.clg(i).theta(j,5)  = Beta(4);
            P.clg(i).theta(j,6)  = Beta(1);             
            P.clg(i).theta(j,7)  = Beta(2);
            P.clg(i).theta(j,8)  = Beta(3);
            [Beta, P.clg(i).sigma_angle(j)] = FitLinearGaussianParameters(dataset(indx,i,3), pData);
            P.clg(i).theta(j,9)  = Beta(4);
            P.clg(i).theta(j,10) = Beta(1);             
            P.clg(i).theta(j,11) = Beta(2);
            P.clg(i).theta(j,12) = Beta(3);
        end
    end
end
loglikelihood = ComputeLogLikelihood(P, G, dataset);
%fprintf('log likelihood: %f\n', loglikelihood);