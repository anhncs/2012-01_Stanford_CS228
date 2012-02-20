function [MEU OptimalDecisionRule] = OptimizeMEU( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  
  % We assume I has a single decision node.
  % You may assume that there is a unique optimal decision.
  D = I.DecisionFactors(1);

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  % 
  % Some other information that might be useful for some implementations
  % (note that there are multiple ways to implement this):
  % 1.  It is probably easiest to think of two cases - D has parents and D 
  %     has no parents.
  % 2.  You may find the Matlab/Octave function setdiff useful.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    EUF = CalculateExpectedUtilityFactor( I );
    OptimalDecisionRule = D;
    OptimalDecisionRule.val = 0*D.val;
    MEU = 0;
    n = length(OptimalDecisionRule.val)/OptimalDecisionRule.card(1);
    for i=1:n
        [val, indx_temp] = max(EUF.val((i-1)*n + 1:(i-1)*n + n));
        MEU = MEU + val;
        indx = indx_temp + (i-1)*n;
        OptimalDecisionRule = SetValueOfAssignment(OptimalDecisionRule, IndexToAssignment(indx, OptimalDecisionRule.card), 1);
    end
end
