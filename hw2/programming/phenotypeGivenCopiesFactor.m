function phenotypeFactor = phenotypeGivenCopiesFactor(alphaList, alleleList, geneCopyVarOne, geneCopyVarTwo, phenotypeVar)
% This function makes a factor whose values are the probabilities of 
% a phenotype given an allele combination.

% In the factor, each assignment maps to the allele at the corresponding
% location on the allele list, so allele assignment 1 maps to
% alleleList{1}, allele assignment 2 maps to alleleList{2}, ....  For the
% phenotypes, assignment 1 maps to having the physical trait, and
% assignment 2 maps to not having the physical trait.

% THE VARIABLE TO THE LEFT OF THE CONDITIONING BAR MUST BE THE FIRST
% VARIABLE IN THE .var FIELD FOR GRADING PURPOSES

% Input:
%   alphaList: n x 1 vector of alpha values for the different genotypes,
%   where n is the number of genotypes -- the alpha value for a genotype
%   is the probability that a person with that genotype will have the
%   physical trait
%   alleleList: Cell array of alleles
%   geneCopyVarOne: Variable number corresponding to the variable for
%   the first parent's copy of the gene
%   geneCopyVarTwo: Variable number corresponding to the variable for
%   the second parent's copy of the gene
%   phenotypeVar: Variable number corresponding to the variable for the 
%   phenotype
%
% Output:
%   phenotypeFactor: Factor in which the values are the probabilities of 
%   having each phenotype for each allele combination

phenotypeFactor = struct('var', [], 'card', [], 'val', []);
numAlleles = length(alleleList);

% Each allele has an ID that is the index of its location in the allele
% list/the index of its allele frequency in the allele frequency list. Each
% genotype also has an ID that is the index of its alpha in the list of
% alphas.  There is a mapping from a pair of allele IDs to genotype IDs and
% from genotype IDs to a pair of allele IDs below; we compute this mapping 
% using generateAlleleGenotypeMappers(numAlleles). (A genotype consists of
% 2 alleles.)

[allelesToGenotypes, genotypesToAlleles] = generateAlleleGenotypeMappers(numAlleles);

% One or both of these matrices might be useful.
%
%   1.  allelesToGenotypes: n x n matrix that maps pairs of allele IDs to 
%   genotype IDs -- if allelesToGenotypes(i, j) = k, then the genotype with 
%   ID k comprises of the alleles with IDs i and j
%
%   2.  genotypesToAlleles: m x 2 matrix of allele IDs, where m is the number of 
%   genotypes -- if genotypesToAlleles(k, :) = i, j, then the genotype with ID k 
%   is comprised of the allele with ID i and the allele with ID j

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INSERT YOUR CODE HERE
% The number of phenotypes is 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% Fill in phenotypeFactor.var.
phenotypeFactor.var = [phenotypeVar, geneCopyVarOne, geneCopyVarTwo];
% Fill in phenotypeFactor.card.
% C^n_2 + n = size(alphaList); therefore, n = int(  (-1 + sqrt( 1+size(alphaList)*8 )/2 )
n_gene_card = (  (-1 + sqrt( 1+ length(alphaList)*8 ))/2 );
phenotypeFactor.card = [2, n_gene_card, n_gene_card];

phenotypeFactor.val = zeros(prod(phenotypeFactor.card), 1);
% Replace the zeros in phentoypeFactor.val with the correct values.

for i=1:n_gene_card
    for j=1:n_gene_card
        p = alphaList(allelesToGenotypes(i,j));
        phenotypeFactor = SetValueOfAssignment(phenotypeFactor, [1, i, j], p  );
        phenotypeFactor = SetValueOfAssignment(phenotypeFactor, [2, i, j], 1-p);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%