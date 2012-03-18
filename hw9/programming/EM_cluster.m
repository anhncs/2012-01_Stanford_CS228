% CS228 PA9 Winter 2011-2012
% File: EM_cluster.m
% Copyright (C) 2012, Stanford University

function [P loglikelihood ClassProb] = EM_cluster(poseData, G, InitialClassProb, maxIter)

% INPUTS
% poseData: N x 10 x 3 matrix, where N is number of poses;
%   poseData(i,:,:) yields the 10x3 matrix for pose i.
% G: graph parameterization as explained in PA8
% InitialClassProb: N x K, initial allocation of the N poses to the K
%   classes. InitialClassProb(i,j) is the probability that example i belongs
%   to class j
% maxIter: max number of iterations to run EM

% OUTPUTS
% P: structure holding the learned parameters as described in the PA
% loglikelihood: #(iterations run) x 1 vector of loglikelihoods stored for
%   each iteration
% ClassProb: N x K, conditional class probability of the N examples to the
%   K classes in the final iteration. ClassProb(i,j) is the probability that
%   example i belongs to class j

% Initialize variables
N = size(poseData, 1);
K = size(InitialClassProb, 2);

ClassProb = InitialClassProb;

loglikelihood = zeros(maxIter,1);

% EM algorithm
for iter=1:maxIter
  
  % M-STEP to estimate parameters for Gaussians
  %
  % Fill in P.c with the estimates for prior class probabilities
  % Fill in P.clg for each body part and each class
  % Make sure to choose the right parameterization based on G(i,1)
  %
  % Hint: This part should be similar to your work from PA8
  
  P.c = zeros(1,K);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 P.c=mean(ClassProb,1);
 P.clg = repmat(struct('mu_y',[],'sigma_y',[],'mu_x',[],'sigma_x',[],'mu_angle',[],'sigma_angle',[],'theta',[]), 1, size(poseData,2));
 
for j = 1:size(poseData,2)
    for k=1:K
        Weight=ClassProb(:,k);
        Y = poseData(:,j,1);
        X = poseData(:,j,2);
        Angle = poseData(:,j,3);   
        if (G(j,1) == 0) 
            [P.clg(j).mu_y(k) P.clg(j).sigma_y(k)] = FitGaussianParameters(Y,Weight);
            [P.clg(j).mu_x(k) P.clg(j).sigma_x(k)] = FitGaussianParameters(X,Weight);
            [P.clg(j).mu_angle(k) P.clg(j).sigma_angle(k)] = FitGaussianParameters(Angle,Weight);
            P.clg(j).theta = [];
        else
            pa = G(j,2);
            U = reshape(poseData(:,pa,:),N,size(poseData,3));
           %[Beta sigma] = FitLinearGaussianParameters(X, U) 
           [BetaY sigmaY] = FitLinearGaussianParameters(Y, U,Weight);
           [BetaX sigmaX] = FitLinearGaussianParameters(X, U,Weight);
           [BetaA sigmaA] = FitLinearGaussianParameters(Angle, U,Weight);
           P.clg(j).sigma_y(k) = sigmaY;
           P.clg(j).sigma_x(k) = sigmaX;
           P.clg(j).sigma_angle(k) = sigmaA;
           P.clg(j).theta(k,:) = [BetaY(4) BetaY(1) BetaY(2) BetaY(3)...
               BetaX(4) BetaX(1) BetaX(2) BetaX(3) BetaA(4) BetaA(1) BetaA(2) BetaA(3)];
        end;
    end;
end;
%loglikelihood = ComputeLogLikelihood(P, G, poseData);

%fprintf('log likelihood: %f\n', loglikelihood);


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % E-STEP to re-estimate ClassProb using the new parameters
  %
  % Update ClassProb with the new conditional class probabilities.
  % Recall that ClassProb(i,j) is the probability that example i belongs to
  % class j.
  %
  % You should compute everything in log space, and only convert to
  % probability space at the end.
  %
  % Tip: To make things faster, try to reduce the number of calls to
  % lognormpdf, and inline the function (i.e., copy the lognormpdf code
  % into this file)
  %
  % Hint: You should use the logsumexp() function here to do
  % probability normalization in log space to avoid numerical issues
  
  ClassProb = zeros(N,K);
  LL=zeros(N,K);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:N
    logProb = zeros(1,K);
    for k = 1:K
        logProb(k) = log(P.c(k)); 
        for j = 1:size(poseData,2)
            D=size(poseData,3);
            pose=reshape(poseData(i,j,:),1,D);
            
            sigma=[P.clg(j).sigma_y(k) P.clg(j).sigma_x(k) P.clg(j).sigma_angle(k)];
            if (G(j,1) == 0) 
                mu=[P.clg(j).mu_y(k) P.clg(j).mu_x(k) P.clg(j).mu_angle(k)];
                log_prob = -log(sigma*sqrt(2*pi))-(pose-mu).^2 ./ (2*sigma.^2);
                logProb(k) = logProb(k) + sum(log_prob);
                
            else
                pa = G(j,2);
                mu_y = P.clg(j).theta(k,1) + P.clg(j).theta(k,2) * poseData(i,pa,1) + P.clg(j).theta(k,3) * poseData(i,pa,2) + P.clg(j).theta(k,4) * poseData(i,pa,3);
                mu_x = P.clg(j).theta(k,5) + P.clg(j).theta(k,6) * poseData(i,pa,1) + P.clg(j).theta(k,7) * poseData(i,pa,2) + P.clg(j).theta(k,8) * poseData(i,pa,3);
                mu_angle = P.clg(j).theta(k,9) + P.clg(j).theta(k,10) * poseData(i,pa,1) + P.clg(j).theta(k,11) * poseData(i,pa,2) + P.clg(j).theta(k,12) * poseData(i,pa,3);
                mu=[mu_y mu_x mu_angle];
                log_prob = -log(sigma*sqrt(2*pi))-(pose-mu).^2 ./ (2*sigma.^2);
                logProb(k) = logProb(k) + sum(log_prob);
            end;
        end;

    end;
    ClassProb(i,:)=exp(logProb-logsumexp(logProb));
    LL(i,:)=logProb;
   
   % loglikelihood = loglikelihood + log(sum(exp(logProb)));
end;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Compute log likelihood of poseData for this iteration
  % Hint: You should use the logsumexp() function here
  loglikelihood(iter) = 0;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  loglikelihood(iter)=sum(logsumexp(LL));
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Print out loglikelihood
  disp(sprintf('EM iteration %d: log likelihood: %f', ...
    iter, loglikelihood(iter)));
  if exist('OCTAVE_VERSION')
    fflush(stdout);
  end
  
  % Check for overfitting: when loglikelihood decreases
  if iter > 1
    if loglikelihood(iter) < loglikelihood(iter-1)
      break;
    end
  end
  
end

% Remove iterations if we exited early
loglikelihood = loglikelihood(1:iter);
