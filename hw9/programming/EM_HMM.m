% CS228 PA9 Winter 2011-2012
% File: EM_HMM.m
% Copyright (C) 2012, Stanford University

function [P loglikelihood ClassProb PairProb] = EM_HMM(actionData, poseData, G, InitialClassProb, InitialPairProb, maxIter)

% INPUTS
% actionData: structure holding the actions as described in the PA
% poseData: N x 10 x 3 matrix, where N is number of poses in all actions
% G: graph parameterization as explained in PA description
% InitialClassProb: N x K matrix, initial allocation of the N poses to the K
%   states. InitialClassProb(i,j) is the probability that example i belongs
%   to state j.
%   This is described in more detail in the PA.
% InitialPairProb: V x K^2 matrix, where V is the total number of pose
%   transitions in all HMM action models, and K is the number of states.
%   This is described in more detail in the PA.
% maxIter: max number of iterations to run EM

% OUTPUTS
% P: structure holding the learned parameters as described in the PA
% loglikelihood: #(iterations run) x 1 vector of loglikelihoods stored for
%   each iteration
% ClassProb: N x K matrix of the conditional class probability of the N examples to the
%   K states in the final iteration. ClassProb(i,j) is the probability that
%   example i belongs to state j. This is described in more detail in the PA.
% PairProb: V x K^2 matrix, where V is the total number of pose transitions
%   in all HMM action models, and K is the number of states. This is
%   described in more detail in the PA.

% Initialize variables
N = size(poseData, 1);
K = size(InitialClassProb, 2);
L = size(actionData, 2); % number of actions
V = size(InitialPairProb, 1);

ClassProb = InitialClassProb;
PairProb = InitialPairProb;

loglikelihood = zeros(maxIter,1);

% EM algorithm
for iter=1:maxIter
  
  % M-STEP to estimate parameters for Gaussians
  % Fill in P.c, the initial state prior probability (NOT the class probability as in PA8 and EM_cluster.m)
  % Fill in P.clg for each body part and each class
  % Make sure to choose the right parameterization based on G(i,1)
  % Hint: This part should be similar to your work from PA8 and EM_cluster.m
  
  P.c = zeros(1,K);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  InitialIndx=zeros(1,L);
  for i=1:L
      InitialIndx(i)=actionData(i).marg_ind(1);
  end
  P.c=mean(ClassProb(InitialIndx,:),1);
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
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % M-STEP to estimate parameters for transition matrix
  % Fill in P.transMatrix, the transition matrix for states
  % P.transMatrix(i,j) is the probability of transitioning from state i to state j
  P.transMatrix = zeros(K,K);
  
  % Add Dirichlet prior based on size of poseData to avoid 0 probabilities
  P.transMatrix = P.transMatrix + size(PairProb,1) * .05;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  MeanPair=sum(PairProb,1);
  P.transMatrix=P.transMatrix+reshape(MeanPair,size(P.transMatrix));
  
  for i=1:size(P.transMatrix,1)
      P.transMatrix(i,:)=P.transMatrix(i,:)/sum(P.transMatrix(i,:));
  end
      
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
    
  % E-STEP preparation: compute the emission model factors (emission probabilities) in log space for each 
  % of the poses in all actions = log( P(Pose | State) )
  % Hint: This part should be similar to (but NOT the same as) your code in EM_cluster.m
  
  logEmissionProb = zeros(N,K);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  for i = 1:N
    logProb = zeros(1,K);
    for k = 1:K
        for j = 1:size(poseData,2)
            D=size(poseData,3);
            pose=reshape(poseData(i,j,:),1,D);
            
            sigma=[P.clg(j).sigma_y(k) P.clg(j).sigma_x(k) P.clg(j).sigma_angle(k)];
            if (G(j,1) == 0) 
                mu=[P.clg(j).mu_y(k) P.clg(j).mu_x(k) P.clg(j).mu_angle(k)];
            else
                pa = G(j,2);
                mu_y = P.clg(j).theta(k,1) + P.clg(j).theta(k,2) * poseData(i,pa,1) + P.clg(j).theta(k,3) * poseData(i,pa,2) + P.clg(j).theta(k,4) * poseData(i,pa,3);
                mu_x = P.clg(j).theta(k,5) + P.clg(j).theta(k,6) * poseData(i,pa,1) + P.clg(j).theta(k,7) * poseData(i,pa,2) + P.clg(j).theta(k,8) * poseData(i,pa,3);
                mu_angle = P.clg(j).theta(k,9) + P.clg(j).theta(k,10) * poseData(i,pa,1) + P.clg(j).theta(k,11) * poseData(i,pa,2) + P.clg(j).theta(k,12) * poseData(i,pa,3);
                mu=[mu_y mu_x mu_angle];
            end;
            log_prob = -log(sigma*sqrt(2*pi))-(pose-mu).^2 ./ (2*sigma.^2);
            logProb(k) = logProb(k)+sum(log_prob);
        end;

    end;
    
    logEmissionProb(i,:)=logProb;
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
    
  % E-STEP to compute expected sufficient statistics
  % ClassProb contains the conditional class probabilities for each pose in all actions
  % PairProb contains the expected sufficient statistics for the transition CPDs (pairwise transition probabilities)
  % Also compute log likelihood of dataset for this iteration
  % You should do inference and compute everything in log space, only converting to probability space at the end
  % Hint: You should use the logsumexp() function here to do probability normalization in log space to avoid numerical issues
  
  ClassProb = zeros(N,K);
  PairProb = zeros(V,K^2);
  loglikelihood(iter) = 0;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %Run inference for each of the action

  for i=1:L
       
      %construct the factors for inference
      indx1=actionData(i).marg_ind;
      indx2=actionData(i).pair_ind;
      F=repmat(struct('var',[],'card',[],'val',[]),1,length(indx1)+length(indx2));
      %P(S1)
      for j=1:length(indx1)
          F(j).var=j;
          F(j).card=K;
          if j==1
              F(j).val=log(P.c)+logEmissionProb(indx1(j),:);
          else
              F(j).val=logEmissionProb(indx1(j),:);
          end
      end
      %P(S'|S)
      for l=1:length(indx2)
          F(j+l).var=[l l+1];
          F(j+l).card=[K K];
          F(j+l).val=log(reshape(P.transMatrix,1,prod(F(j+1).card)));
      end
      
      [M, PCalibrated] = ComputeExactMarginalsHMM(F);
      
      %Renew the table of ClassProb and PairProb
      for j=1:length(indx1)
          ClassProb(indx1(j),:)=exp(M(j).val-logsumexp(M(j).val));
      end
      for j=1:length(indx2)
          PairProb(indx2(j),:)=exp(PCalibrated.cliqueList(j).val-logsumexp(PCalibrated.cliqueList(j).val));
      end
      
     %Pick a clique and marginalize all the Ss in that clique to get the
     %joint distribution of the Ps
     
     loglikelihood(iter) = loglikelihood(iter)+logsumexp(PCalibrated.cliqueList(1).val); 
  end
  
  
  
 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Print out loglikelihood
  disp(sprintf('EM iteration %d: log likelihood: %f', ...
    iter, loglikelihood(iter)));
  if exist('OCTAVE_VERSION')
    fflush(stdout);
  end
  
  % Check for overfitting by decreasing loglikelihood
  if iter > 1
    if loglikelihood(iter) < loglikelihood(iter-1)
      break;
    end
  end
  
end

% Remove iterations if we exited early
loglikelihood = loglikelihood(1:iter);
