%GETNEXTCLIQUES Find a pair of cliques ready for message passing
%   [i, j] = GETNEXTCLIQUES(P, messages) finds ready cliques in a given
%   clique tree, P, and a matrix of current messages. Returns indices i and j
%   such that clique i is ready to transmit a message to clique j.
%
%   We are doing clique tree message passing, so
%   do not return (i,j) if clique i has already passed a message to clique j.
%
%	 messages is a n x n matrix of passed messages, where messages(i,j)
% 	 represents the message going from clique i to clique j. 
%   This matrix is initialized in CliqueTreeCalibrate as such:
%      MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);
%
%   If more than one message is ready to be transmitted, return 
%   the pair (i,j) that is numerically smallest. If you use an outer
%   for loop over i and an inner for loop over j, breaking when you find a 
%   ready pair of cliques, you will get the right answer.
%
%   If no such cliques exist, returns i = j = 0.
%
%   See also CLIQUETREECALIBRATE

% CS228 Probabilistic Graphical Models(Winter 2012)
% Copyright (C) 2012, Stanford University

function [i, j] = GetNextCliques(P, messages)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=length(P.cliqueList);
for i=1:N
    for j=1:N
        if (P.edges(i,j)==0)   %There is no edge between i and j
            continue;
        else if(~isempty(messages(i,j).var)) %i has alreay passed message to j
                continue;
            end
        end
         
        indx=setdiff(find(P.edges(i,:)),j);
        
        if(isempty(indx))
            return;
        end
        
        for k=1:length(indx)
            if (isempty(messages(indx(k),i).var))  %the clique hasn't got all other messages
                k=k-1;
                break;
            end
        end
        
        if (k==length(indx))   %the clique is ready
            return;
        end
        
       
    end
end
i=0;
j=0;


return;
