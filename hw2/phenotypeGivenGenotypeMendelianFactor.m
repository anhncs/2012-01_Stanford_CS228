function phenotypeFactor = phenotypeGivenGenotypeMendelianFactor(isDominant, genotypeVar, phenotypeVar)
% This function computes the probability of each phenotype given the
% different genotypes for a trait.  It assumes that there is 1 dominant
% allele and 1 recessive allele.
%
% For the genotypes, assignment 1 maps to homozygous dominant, assignment 2
% maps to heterozygous, and assignment 3 maps to homozygous recessive.  For
% the phenotypes, assignment 1 maps to having the physical trait, and
% assignment 2 maps to not having the physical trait.
%
% THE VARIABLE TO THE LEFT OF THE CONDITIONING BAR MUST BE THE FIRST
% VARIABLE IN THE .var FIELD FOR GRADING PURPOSES
%
% Input:
%   isDominant: 1 if the trait is caused by the dominant allele (trait 
%   would be caused by A in example above) and 0 if the trait is caused by
%   the recessive allele (trait would be caused by a in the example above)
%   genotypeVar: The variable number for the genotype variable
%   phenotypeVar: The variable number for the phenotype variable
%
% Output:
%   phenotypeFactor: Factor denoting the probability of having each 
%   phenotype for each genotype

phenotypeFactor = struct('var', [], 'card', [], 'val', []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INSERT YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Fill in phenotypeFactor.var.
phenotypeFactor.var = [phenotypeVar, genotypeVar];
% Fill in phenotypeFactor.card.
phenotypeFactor.card = [2, 3];

phenotypeFactor.val = zeros(prod(phenotypeFactor.card), 1);
% Replace the zeros in phentoypeFactor.val with the correct values.

if isDominant == 1
    p = 1;
    % P(1 | 1=AA ) = 1
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor,[1,1],p);
    % P(2 | 1=AA) = 0
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor,[2,1],1-p);

    p = 1;
    % P(1 | 2=Aa) = 1
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor,[1,2],p);    
    % P(2 | 2=Aa) = 0
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor,[2,2],1-p);

    p = 0;
    % P(1 | 3=aa) = 0
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor,[1,3],p);
    % P(2 | 3=aa) = 1
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor,[2,3],1-p);
else
    p = 0;
    % P(1 | 1=AA) = 0
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor,[1,1],p);    
    % P(2 | 1=AA) = 1
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor,[2,1],1-p);

    p = 0;
    % P(1 | 2=Aa) = 0
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor,[1,2],p);    
    % P(2 | 2=Aa) = 1
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor,[2,2],1-p);

    p = 1;
    % P(1 | 3=aa) = 1
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor,[1,3],p);
    % P(2 | 3=aa) = 0
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor,[2,3],1-p);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
