% CS228 Winter 2011-2012
% File: ClassifyDataset.m
% Copyright (C) 2012, Stanford University

function accuracy = ClassifyDataset(dataset, labels, P, G)
% returns the accuracy of the model P and graph G on the dataset 
%
% Inputs:
% dataset: N x 10 x 3, N test instances represented by 10 parts
% labels:  N x 2 true class labels for the instances.
%          labels(i,j)=1 if the ith instance belongs to class j 
% P: struct array model parameters (explained in PA description)
% G: graph structure and parameterization (explained in PA description) 
%
% Outputs:
% accuracy: percentage of correctly classified instances (scalar)

N = size(dataset, 1);
K = size(labels,2);
accuracy = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:N
    logProb = zeros(K,1);
    for m=1:K            
        logProb(m) = logProb(m) + log(P.c(m));
        for j=1:size(dataset,2)    
            condition = 0;
            if length(size(G)) == 2
                if G(j,1)>0
                    pNode = G(j,2);
                    condition = 1;
                end
            elseif length(size(G)) == 3
                if G(j,1,m) > 0
                    pNode = G(j,2,m);
                    condition = 1;
                end
            end
            if condition > 0
                mu_y =     P.clg(j).theta(m,1) + P.clg(j).theta(m,2 )*dataset(i,pNode,1) + P.clg(j).theta(m,3 )*dataset(i,pNode,2) + P.clg(j).theta(m,4 )*dataset(i,pNode,3);
                mu_x =     P.clg(j).theta(m,5) + P.clg(j).theta(m,6 )*dataset(i,pNode,1) + P.clg(j).theta(m,7 )*dataset(i,pNode,2) + P.clg(j).theta(m,8 )*dataset(i,pNode,3);
                mu_angle = P.clg(j).theta(m,9) + P.clg(j).theta(m,10)*dataset(i,pNode,1) + P.clg(j).theta(m,11)*dataset(i,pNode,2) + P.clg(j).theta(m,12)*dataset(i,pNode,3);
            else
                mu_y = P.clg(j).mu_y(m);
                mu_x = P.clg(j).mu_x(m);
                mu_angle = P.clg(j).mu_angle(m);
            end
            logProb(m) = logProb(m) + lognormpdf(dataset(i,j,1), mu_y, P.clg(j).sigma_y(m))...
                                    + lognormpdf(dataset(i,j,2), mu_x, P.clg(j).sigma_x(m))...
                                    + lognormpdf(dataset(i,j,3), mu_angle, P.clg(j).sigma_angle(m));
        end
    end
    loglikelihood = loglikelihood + log(sum(exp(logProb)));
end

%fprintf('Accuracy: %.2f\n', accuracy);