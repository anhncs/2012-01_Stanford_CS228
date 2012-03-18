% CS228 PA3 Winter 2011
% File: VisualizeDataset.m
% Copyright (C) 2011, Stanford University
% contact: Huayan Wang, huayanw@cs.stanford.edu

function VisualizeDataset(Dataset)

figure
for i=1:size(Dataset,1)
    img = ShowPose(reshape(Dataset(i,:,:), [10 3]));
    imshow(img);
    pause(0.3);
end
