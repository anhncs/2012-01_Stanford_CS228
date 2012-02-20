function EUF = CalculateExpectedUtilityFactor( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: A factor over the scope of the decision rule D from I that
  % gives the conditional utility given each assignment for D.var
  %
  % Note - We assume I has a single decision node and utility node.

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    F = I.RandomFactors;
    U = I.UtilityFactors(1);
    
    % All the indices of factors without a joint assignment 
    % to the parents of D, D, and U.
    indx_All_without_PaD_and_U = unique([I.RandomFactors(:).var I.DecisionFactors(1).var I.UtilityFactors(1).var]);
    indx_All_without_PaD_and_U(ismember(indx_All_without_PaD_and_U, [I.DecisionFactors(1).var U.var]))=[];
 
    F_new_list = VariableElimination(F, indx_All_without_PaD_and_U, []);
    temp = struct('var', [], 'card', [], 'val', []);
    for i=1:length(F_new_list)
          temp = FactorProduct(temp,F_new_list(i));
    end   
    temp =  FactorProduct(U,temp );
    indx_sum = temp.var;
    indx_sum(ismember(indx_sum, I.DecisionFactors(1).var))=[];
    
    EUF_list = VariableElimination(temp,indx_sum,[]);
    EUF = struct('var', [], 'card', [], 'val', []);
    for i=1:length(EUF_list)
          EUF = FactorProduct(EUF,EUF_list(i));
    end   
end  
