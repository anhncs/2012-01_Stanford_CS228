function factorList = constructDecoupledGeneticNetwork(pedigree, alleleFreqs, alleleList, alphaList)
% This function constructs a Bayesian network for genetic inheritance.  It
% assumes that there are only 2 phenotypes.  It also assumes that, in the
% pedigree, either both parents are specified or neither parent is
% specified.
%
% Here is an example of how the variable numbering should work: if
% pedigree.names = {'Ira', 'James', 'Robin'} and pedigree.parents = [0, 0;
% 1, 3; 0, 0], then the variable numbering is as follows:
%
% Variable 1: IraGeneCopy1
% Variable 2: JamesGeneCopy1
% Variable 3: RobinGeneCopy1
% Variable 4: IraGeneCopy2
% Variable 5: JamesGeneCopy2
% Variable 6: RobinGeneCopy2
% Variable 7: IraPhenotype
% Variable 8: JamesPhenotype
% Variable 9: RobinPhenotype
%
% Here is how the variables should be numbered, for a pedigree with n
% people:
%
% 1.  The first n variables should be the gene copy 1 variables and should
% be numbered according to the index of the corresponding person in
% pedigree.names; the ith person with name pedigree.names{i} has gene copy
% 1 variable number i.  If the parents are specified, then gene copy 1 is the
% copy inherited from pedigree.names{pedigree.parents(i, 1)}.
%
% 2.  The next n variables should be the gene copy 2 variables and should
% be numbered according to the index of the corresponding person in
% pedigree.names; the ith person with name pedigree.names{i} has gene copy
% 2 variable number n+i.  If the parents are specified, then gene copy 2 is the
% copy inherited from pedigree.parents(i, 2).
%
% 3.  The final n variables should be the phenotype variables and should be
% numbered according to the index of the corresponding person in
% pedigree.names; the ith person with name pedigree.names{i} has phenotype
% variable number 2n+i.
%
% Input:
%   pedigree: Data structure that includes the names and parents of each
%   person
%   alleleFreqs: n x 1 vector of allele frequencies in the population,
%   where n is the number of alleles
%   alleleList: Cell array of alleles
%   alphaList: n x 1 vector of alphas for different genotypes, where n is
%   the number of genotypes -- the alpha value for a genotype is the 
%   probability that a person with that genotype will have the physical 
%   trait
%
% Output:
%   factorList: struct array of factors for the genetic network

numPeople = length(pedigree.names);

factorList = struct('var', [], 'card', [], 'val', []);

for i = 1:3*numPeople
    % Need 3*numPeople factors because, for each person, there is a factor for
    % the CPD at each of 2 parental copies of the gene and a factor for the CPD
    % at the phenotype
    factorList(i) = struct('var', [], 'card', [], 'val', []);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INSERT YOUR CODE HERE
% Variable numbers:
% 1 - numPeople: first parent copy of gene
% numPeople+1 - 2*numPeople: second parent copy of gene
% 2*numPeople+1 - 3*numPeople: phenotypes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        


no_parent_indices = find(ismember(pedigree.parents, [0, 0], 'rows'));
% Construct the genotype factors for people who are not specified parents
for i=1:size(no_parent_indices, 1) 
    factorList(no_parent_indices(i)          ) = childCopyGivenFreqsFactor(alleleFreqs, no_parent_indices(i)          );
    factorList(no_parent_indices(i)+numPeople) = childCopyGivenFreqsFactor(alleleFreqs, no_parent_indices(i)+numPeople);
end

% Now, start to compute the genotype factors for people who have parents
uncomputed_factor_list = ~ismember(pedigree.parents, [0, 0], 'rows');
while( sum(uncomputed_factor_list) ~= 0)
     uncomputed_indices = find(uncomputed_factor_list);
     for i=1:size(uncomputed_indices, 1)
        node_parents = pedigree.parents(uncomputed_indices(i),: );
        if( (uncomputed_factor_list(node_parents(1))==0) && (uncomputed_factor_list(node_parents(2)) ==0) )
            factorList(uncomputed_indices(i))           = childCopyGivenParentalsFactor(alleleList, uncomputed_indices(i)          , node_parents(1), node_parents(1)+numPeople);
            factorList(uncomputed_indices(i)+numPeople) = childCopyGivenParentalsFactor(alleleList, uncomputed_indices(i)+numPeople, node_parents(2), node_parents(2)+numPeople);
            uncomputed_factor_list( uncomputed_indices(i) ) = 0;
        end
     end
end

% Finally, calcuate the phenotype factors
for i=2*numPeople+1:3*numPeople    
    factorList(i) = phenotypeGivenCopiesFactor(alphaList, alleleList, i-2*numPeople, i-numPeople, i);
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  