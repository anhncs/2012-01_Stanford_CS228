function SaveECPredictions (yourPredictions)
% This function will save your test set predictions into a text file. The
% submit script for the extra credit submission will then read in that text
% file to send your predictions to the grading server.
%
% The input `yourPredictions' should be an 80x3 matrix where 
% yourPredictions(i,j) is the predicted value (1-26) of the j'th character
% in the i'th word. That is, the predicted value for testData(i).y(j).

if (~isequal([80 3], size(yourPredictions)))
    error ('The input to SaveECPredictions is not the right size.');
end

save('ECPredictions.mat', 'yourPredictions');


end

