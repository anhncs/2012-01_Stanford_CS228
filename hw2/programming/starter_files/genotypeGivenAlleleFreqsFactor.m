function genotypeFactor = genotypeGivenAlleleFreqsFactor(alleleFreqs, genotypeVar)
% This function computes the probability of each genotype given the allele 
% frequencies in the population.

% Note that we assume that the allele frequencies are independent, so the
% probability of a genotype is the product of the frequencies of its
% constituent alleles (or twice that product for heterozygous genotypes).
% We also assume that a person has an equal probability of having each
% allele for each copy of a gene.

% Input:
%   alleleFreqs: An n x 1 vector of the frequencies of the alleles in the 
%   population, where n is the number of alleles
%   genotypeVar: The variable number for the genotype
%
% Output:
%   genotypeFactor: Factor in which the val has the probability of having 
%   each genotype

% The number of genotypes is (number of alleles choose 2) + number of 
% alleles -- need to add number of alleles at the end to account for 
% homozygotes

genotypeFactor = struct('var', [], 'card', [], 'val', []);
numAlleles = length(alleleFreqs);

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fill in phenotypeFactor.var.
% Fill in phenotypeFactor.card.

genotypeFactor.val = zeros(prod(genotypeFactor.card), 1);
% Replace the zeros in genotypeFactor.val with the correct values.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  