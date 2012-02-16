function VisualizeToyImageMarginals(G, M)

n = sqrt(length(G.names));
marginal_vector = [];
for i = 1:length(M)
    marginal_vector(end+1) = M(i).val(1);
end
clims = [0, 1];
imagesc(reshape(marginal_vector, n, n), clims);
colormap(gray);