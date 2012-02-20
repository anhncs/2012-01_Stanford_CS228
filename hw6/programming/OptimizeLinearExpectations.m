function [MEU OptimalDecisionRule] = OptimizeLinearExpectations( I )
  % Inputs: An influence diagram I with a single decision node and one or more utility nodes.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  % You may assume that there is a unique optimal decision.
  %
  % This is similar to OptimizeMEU except that we will have to account for
  % multiple utility factors.  We will do this by calculating the expected
  % utility factors and combining them, then optimizing with respect to that
  % combined expected utility factor.  

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  % A decision rule for D assigns, for each joint assignment to D's parents, 
  % probability 1 to the best option from the EUF for that joint assignment 
  % to D's parents, and 0 otherwise.  Note that when D has no parents, it is
  % a degenerate case we can handle separately for convenience.
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    D = I.DecisionFactors(1);
    EUF = struct('var', [], 'card', [], 'val', []);
    for i=1:length(I.UtilityFactors)
        Inew = I;
        Inew.UtilityFactors = I.UtilityFactors(i);
        EUF = FactorSum(EUF, CalculateExpectedUtilityFactor( Inew ));
    end    
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
    
  % Quiz Q6
%   TestI0.RandomFactors(10).card=[3 2]
%   TestI0.RandomFactors(10).val=zeros(1,6);
%   TestI0.RandomFactors(10) = SetValueOfAssignment( TestI0.RandomFactors(10), [1 1], 0.999);
%   TestI0.RandomFactors(10) = SetValueOfAssignment( TestI0.RandomFactors(10), [1 2], 0.75);
%   TestI0.RandomFactors(10) = SetValueOfAssignment( TestI0.RandomFactors(10), [2 1], 0.75);
%   TestI0.RandomFactors(10) = SetValueOfAssignment( TestI0.RandomFactors(10), [2 2], 0.999);
%   TestI0.RandomFactors(10) = SetValueOfAssignment( TestI0.RandomFactors(10), [3 1], 0.999);
%   TestI0.RandomFactors(10) = SetValueOfAssignment( TestI0.RandomFactors(10), [3 2], 0.999);
end
