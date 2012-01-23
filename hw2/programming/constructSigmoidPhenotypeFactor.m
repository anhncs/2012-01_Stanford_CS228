function phenotypeFactor = constructSigmoidPhenotypeFactor(alleleWeights, geneCopyVarOneList, geneCopyVarTwoList, phenotypeVar)
% This function takes a cell array of alleles' weights and constructs a 
% factor expressing a sigmoid CPD.
%
% You can assume that there are only 2 genes involved in the CPD.
%
% In the factor, for each gene, each allele assignment maps to the allele
% whose weight is at the corresponding location.  For example, for gene 1,
% allele assignment 1 maps to the allele whose weight is at
% alleleWeights{1}(1) (same as w_1^1), allele assignment 2 maps to the
% allele whose weight is at alleleWeights{1}(2) (same as w_2^1),....  
% 
% You may assume that there are 2 possible phenotypes.
% For the phenotypes, assignment 1 maps to having the physical trait, and
% assignment 2 maps to not having the physical trait.
%
% THE VARIABLE TO THE LEFT OF THE CONDITIONING BAR MUST BE THE FIRST
% VARIABLE IN THE .var FIELD FOR GRADING PURPOSES
%
% Input:
%   alleleWeights: Cell array of weights, where each entry is an n x 1 
%   of weights for the alleles for a gene (n is the number of alleles for
%   the gene)
%   geneCopyVarOneList: m x 1 vector (m is the number of genes) of variable 
%   numbers that are the variable numbers for each of the first parent's 
%   copy of each gene
%   geneCopyVarTwoList: m x 1 vector (m is the number of genes) of variable 
%   numbers that are the variable numbers for each of the second parent's 
%   copy of each gene
%   phenotypeVar: Variable number corresponding to the variable for the 
%   phenotype
%
% Output:
%   phenotypeFactor: Factor in which the values are the probabilities of 
%   having each phenotype for each allele combination

phenotypeFactor = struct('var', [], 'card', [], 'val', []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INSERT YOUR CODE HERE
% Note that computeSigmoid.m will be useful for this function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% Fill in phenotypeFactor.var.         
% Fill in phenotypeFactor.card.
phenotypeFactor.var(1) = phenotypeVar;
phenotypeFactor.card(1) = 2;
n_geneCopyVarOneList = length(geneCopyVarOneList);
for j=1:n_geneCopyVarOneList
    phenotypeFactor.var(j+1) = geneCopyVarOneList(j);
    phenotypeFactor.card(j+1) = size(alleleWeights{j},1);
end
n_geneCopyVarTwoList = length(geneCopyVarTwoList);
for j=1:n_geneCopyVarTwoList
    phenotypeFactor.var(j+n_geneCopyVarOneList+1) = geneCopyVarTwoList(j);
    phenotypeFactor.card(j+n_geneCopyVarOneList+1) = size(alleleWeights{j},1);
end

phenotypeFactor.val = zeros(prod(phenotypeFactor.card), 1);
% Replace the zeros in phentoypeFactor.val with the correct values.

% Only need loop half of them, since P(i) + P(i+1) = 1 for i is even
for i=1:size(phenotypeFactor.val,1)/2  
    j = 2*i-1;
    assignment = IndexToAssignment(j, phenotypeFactor.card);
    f=0;
    for k=2:(length(assignment))
        allele = assignment(k);
        if k >(length(assignment)+1)/2
            gen = k - (length(assignment)+1)/2;
        else
            gen = k-1;
        end
        f = f + alleleWeights{gen}(allele);
    end
    p = computeSigmoid(f);
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor,assignment,p  );
    assignment = IndexToAssignment(j+1, phenotypeFactor.card);
    phenotypeFactor = SetValueOfAssignment(phenotypeFactor,assignment,1-p);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%