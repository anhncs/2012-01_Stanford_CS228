% MHUNIFORMTRANS
%
%  MCMC Metropolis-Hastings transition function that
%  utilizes the uniform proposal distribution.
%  A - The current joint assignment.  This should be
%      updated to be the next assignment
%  G - The network
%  F - List of all factors
function A = MHUniformTrans(A, G, F)
% Draw proposed new state from uniform distribution
A_prop = ceil(rand(1, length(A)) .* G.card);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% Compute acceptance probability
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
log_accept = 0;
factors_id = unique([G.var2factors{(1:length(G.card))}]);
for i = 1:length(factors_id)
    log_accept = log_accept +  log(GetValueOfAssignment(F(factors_id(i)), A_prop(F(factors_id(i)).var))) - log(GetValueOfAssignment(F(factors_id(i)), A(F(factors_id(i)).var)));
end
p_acceptance = min(1,exp(log_accept));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Accept or reject proposal
if rand() < p_acceptance
    % disp('Accepted');
    A = A_prop;
end