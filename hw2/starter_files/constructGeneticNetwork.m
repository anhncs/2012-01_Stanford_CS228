function factorList = constructGeneticNetwork(pedigree, alleleFreqs, alleleList, alphaList)
% This function constructs a Bayesian network for genetic inheritance.  It
% assumes that there are only 2 phenotypes.  It also assumes that either 
% both parents are specified or neither parent is specified.

% Here is an example of how the variable numbering should work: if
% pedigree.names = {'Ira', 'James', 'Robin'} and pedigree.parents = [0, 0;
% 1, 3; 0, 0], then the variable numbering is as follows:
%
% Variable 1: IraGenotype
% Variable 2: JamesGenotype
% Variable 3: RobinGenotype
% Variable 4: IraPhenotype
% Variable 5: JamesPhenotype
% Variable 6: RobinPhenotype
%
% Here is how the variables should be numbered, for a pedigree with n
% people:
%
% 1.  The first n variables should be the genotype variables and should
% be numbered according to the index of the corresponding person in
% pedigree.names; the ith person with name pedigree.names{i} has genotype
% variable number i.
%
% 3.  The next n variables should be the phenotype variables and should be
% numbered according to the index of the corresponding person in
% pedigree.names; the ith person with name pedigree.names{i} has phenotype
% variable number n+i.

% Input:
%   pedigree: Data structure that includes names, genders, and parent-child
%   relationships
%   alleleFreqs: Frequencies of alleles in the population
%   alleleList: Cell array of alleles
%   alphaList: n x 1 vector of alpha values for genotypes, where n is the
%   number of genotypes -- the alpha value for a genotype is the 
%   probability that a person with that genotype will have the
%   physical trait
%
% Output:
%   factorList: Struct array of factors for the genetic network

numPeople = length(pedigree.names);

factorList = struct('var', [], 'card', [], 'val', []);
for i = 1:2*numPeople
    % Initialize factors
    % The number of factors is twice the number of people because there is
    % a factor for each person's genotype and a separate factor for each
    % person's phenotype
    factorList(i) = struct('var', [], 'card', [], 'val', []);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INSERT YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  