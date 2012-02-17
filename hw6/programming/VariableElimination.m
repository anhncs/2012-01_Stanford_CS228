% VariableElimination takes in a list of factors F, a list of variables to eliminate, 
% evidence E, and returns the resulting factor(s) after running sum-product to eliminate
% the given variables.
%
%   Fnew = VariableElimination(F, Z, E) 
%   F = list of factors
%   Z = list of variables to eliminate
%   E = vector of evidence; set this to [] if there is no evidence.
%

% CS228 Probabilistic Graphical Models(Winter 2012)
% Copyright (C) 2012, Stanford University

function Fnew = VariableElimination(F, Z, E)

% List of all variables
  V = unique([F(:).var]);

  % Setting up the adjacency matrix.
  edges = zeros(length(V));

  for i = 1:length(F)
    for j = 1:length(F(i).var)
      for k = 1:length(F(i).var)
	edges(F(i).var(j), F(i).var(k)) = 1;
      end
    end
  end

  variablesConsidered = 0;

  while variablesConsidered < length(Z)
    
    % Using Min-Neighbors where you prefer to eliminate the variable that has
    % the smallest number of edges connected to it. 
    % Everytime you enter the loop, you look at the state of the graph and 
    % pick the variable to be eliminated.
    bestVariable = 0;
    bestScore = inf;
    for i=Z
      score = sum(edges(i,:));
      if score > 0 && score < bestScore
	bestScore = score;
	bestVariable = i;
      end
    end

    variablesConsidered = variablesConsidered + 1;
    [F, edges] = EliminateVar(F, edges, bestVariable);
    
  end

  Fnew = F;
  for j = 1:length(E)
    if (E(j) > 0)
      Fnew = ObserveEvidence(Fnew, [j, E(j)]);
    end
  end

end

  
