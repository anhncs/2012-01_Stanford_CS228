function phenotypeFactor = phenotypeGivenGenotypeFactor(alphaList, genotypeVar, phenotypeVar)
% This function computes the probability of each phenotype given the 
% different genotypes for a trait. Genotypes (assignments to the genotype
% variable) are indexed from 1 to the number of genotypes, and the alphas
% are provided in the same order as the corresponding genotypes so that the
% alpha for genotype assignment i is alphaList(i).
%
% For the phenotypes, assignment 1 maps to having the physical trait, and 
% assignment 2 maps to not having the physical trait.
%
% THE VARIABLE TO THE LEFT OF THE CONDITIONING BAR MUST BE THE FIRST
% VARIABLE IN THE .var FIELD FOR GRADING PURPOSES
%
% Input:
%   alphaList: Vector of alpha values for each genotype (n x 1 vector,
%   where n is the number of genotypes) -- the alpha value for a genotype
%   is the probability that a person with that genotype will have the
%   physical trait 
%   genotypeVar: The variable number for the genotype variable
%   phenotypeVar: The variable number for the phenotype variable
%
% Output:
%   phenotypeFactor: Factor in which the val has the probability of having 
%   each phenotype for each genotype combination
%

phenotypeFactor = struct('var', [], 'card', [], 'val', []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INSERT YOUR CODE HERE
% The number of genotypes is the length of alphaList.
% The number of phenotypes is 2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% Fill in phenotypeFactor.var.
phenotypeFactor.var = [phenotypeVar, genotypeVar];
n_size = length(alphaList);
% Fill in phenotypeFactor.card.
phenotypeFactor.card = [2, n_size];

phenotypeFactor.val = zeros(prod(phenotypeFactor.card), 1);
% Replace the zeros in phentoypeFactor.val with the correct values.

for i=1:n_size
    p = alphaList(i);
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor,[1,i],p);
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor,[2,i],1-p);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%