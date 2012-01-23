function genotypeFactor = genotypeGivenParentsGenotypesFactor(alleleList, genotypeVarChild, genotypeVarParentOne, genotypeVarParentTwo)
% This function computes a factor representing the CPD for the genotype of
% a child given the parents' genotypes.

% THE VARIABLE TO THE LEFT OF THE CONDITIONING BAR MUST BE THE FIRST
% VARIABLE IN THE .var FIELD FOR GRADING PURPOSES

% When writing this function, make sure to consider all possible genotypes 
% from both parents and all possible genotypes for the child.

% Input:
%   alleleList: Cell array of allele names
%   genotypeVarChild: Variable number corresponding to the variable for the
%   child's genotype
%   genotypeVarParentOne: Variable number corresponding to the variable for
%   the first parent's genotype
%   genotypeVarParentTwo: Variable number corresponding to the variable for
%   the second parent's genotype
%
% Output:
%   genotypeFactor: Factor in which val is probability of the child having 
%   each genotype

% The number of genotypes is (number of alleles choose 2) + number of 
% alleles -- need to add number of alleles at the end to account for
% homozygotes
genotypeFactor = struct('var', [], 'card', [], 'val', []);
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% Fill in genotypeFactor.var.
genotypeFactor.var = [genotypeVarChild, genotypeVarParentOne, genotypeVarParentTwo];
% Fill in genotypeFactor.card.
genotypeFactor.card = [size(genotypesToAlleles,1), size(genotypesToAlleles,1), size(genotypesToAlleles,1)];

genotypeFactor.val = zeros(prod(genotypeFactor.card), 1);
% Replace the zeros in genotypeFactor.val with the correct values.

% loop over ParentOne
for i=1:size(genotypesToAlleles,1) 
    % loop over ParentTwo
    for j=1:size(genotypesToAlleles,1) 
        allele_pair_One = genotypesToAlleles(i,:); % A B
        allele_pair_Two = genotypesToAlleles(j,:); % C D
        %%%% The following four cases have the same P = 0.25. Build a table
        %         C      D
        %    A   AC,1     AD,2
        %    B   BC,3     BD,4
        %%%%
        table(1,:) = [allele_pair_One(1), allele_pair_Two(1)];
        table(2,:) = [allele_pair_One(1), allele_pair_Two(2)];
        table(3,:) = [allele_pair_One(2), allele_pair_Two(1)];
        table(4,:) = [allele_pair_One(2), allele_pair_Two(2)];
        % loop over Child
        for k=1:size(genotypesToAlleles,1) 
            allele_pair_Child = genotypesToAlleles(k,:);
            if( allele_pair_Child(1) ~= allele_pair_Child(2) )
                p = (sum( ismember(table, [allele_pair_Child(1), allele_pair_Child(2)], 'rows') ) +  sum( ismember(table, [allele_pair_Child(2), allele_pair_Child(1)], 'rows') ))*0.25;
            else
                p =  sum( ismember(table, [allele_pair_Child(1), allele_pair_Child(1)], 'rows'))*0.25;
            end
            genotypeFactor = SetValueOfAssignment(genotypeFactor, [k, i, j], p);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
