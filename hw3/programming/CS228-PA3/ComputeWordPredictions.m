function wordPredictions = ComputeWordPredictions (allWords, imageModel, pairwiseModel, tripletList)
% This function computes the predicted character assignments for a list of
% words.
%
% Input:
%   allWords: A cell array where allWords{i} is the struct array for the ith
%     word (this is the structure of the provided 'allWords' data).
%   imageModel: The provided image model struct.
%   pairwiseModel: A K-by-K matrix (K is the alphabet size) where pairwiseModel(i,j)
%     is the factor value for the pairwise factor of character i followed by
%     character j.
%   tripletModel: The array of character triplets we will consider (along
%     with their corresponding factor values).
%
% Output:
%   wordPredictions: A cell array in which the ith entry is the array of
%     predicted characters for the ith word. For example, if you predict
%     that the 3rd word is cat, then wordPredictions{3} = [3 1 20].
%
% Hint: For each word, you need to first construct the list of factors
% (BuildOCRNetwork is helpful here). Given those, RunInference computes the
% predictions you need for that word.


numWords = length(allWords);
wordPredictions = cell(numWords, 1);

% Your code here:

end

