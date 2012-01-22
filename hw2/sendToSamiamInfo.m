% This script contains the information needed for sending files to SamIam.
% UNCOMMENT THE COMMENTED FUNCTIONS FOR CONSTRUCTING NETWORKS ONCE YOU HAVE
% SUCCESSFULLY COMPLETED THEM.  You can convert your networks to a file
% format for SamIam by uncommenting the appropriate sendToSamiam functions
% and running this script.

pedigree = struct('parents', [0,0;1,3;0,0;1,3;2,6;0,0;2,6;4,9;0,0]);
pedigree.names = {'Ira','James','Robin','Eva','Jason','Rene','Benjamin','Sandra','Aaron'};
alleleFreqs = [0.1; 0.9];
alleleList = {'F', 'f'};
alphaList = [0.8; 0.6; 0.1];
phenotypeList = {'CysticFibrosis', 'NoCysticFibrosis'};
positions = [520, 600, 520, 500; 650, 400, 650, 300; 390, 600, 390, 500; 260, 400, 260, 300; 780, 200, 780, 100; 1040, 400, 1040, 300; 910, 200, 910, 100; 130, 200, 130, 100; 0, 400, 0, 300];

% Uncomment the lines below once constructGeneticNetwork.m is working, and
% run this script.  This will construct a Bayesian network and convert it
% into a file that can be viewed in SamIam.
%
% factorList = constructGeneticNetwork(pedigree, alleleFreqs, alleleList, alphaList);
% sendToSamiam(pedigree, factorList, alleleList, phenotypeList, positions, 'cysticFibrosisBayesNet');

% The pedigree for the decoupled network is the same as it was for 
% constructGeneticNetwork.m.
alleleFreqsThree = [0.1; 0.7; 0.2];
alleleListThree = {'F', 'f', 'n'};
alphaListThree = [0.8; 0.6; 0.1; 0.5; 0.05; 0.01];
% The phenotype list for the decoupled network is the same as it was for
% constructGeneticNetwork.m.
positionsGeneCopy = [1040, 600, 1170, 600, 1105, 500; 1300, 400, 1430, 400, 1365, 300; 780, 600, 910, 600, 845, 500; 520, 400, 650, 400, 585, 300; 1560, 200, 1690, 200, 1625, 100; 2080, 400, 2210, 400, 2145, 300; 1820, 200, 1950, 200, 1885, 100; 260, 200, 390, 200, 325, 100; 0, 400, 130, 400, 65, 300];

% Uncomment the lines below once constructDecoupledGeneticNetwork.m is
% working, and run this script.  This will construct a decoupled Bayesian
% network and convert it into a file that can be viewed in SamIam.
%
% factorListDecoupled = constructDecoupledGeneticNetwork(pedigree, alleleFreqsThree, alleleListThree, alphaListThree);
% sendToSamiamGeneCopy(pedigree, factorListDecoupled, alleleListThree, phenotypeList, positionsGeneCopy, 'cysticFibrosisBayesNetGeneCopy');