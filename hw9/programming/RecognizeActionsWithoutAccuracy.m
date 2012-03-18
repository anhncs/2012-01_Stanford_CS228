    
function predicted_labels = RecognizeActionsWithoutAccuracy(datasetTrain, datasetTest, G, maxIter)

[P{1} loglikelihood1 ClassProb1 PairProb1] = EM_HMM(datasetTrain(1).actionData, datasetTrain(1).poseData, G, datasetTrain(1).InitialClassProb, datasetTrain(1).InitialPairProb, maxIter);
[P{2} loglikelihood2 ClassProb2 PairProb2] = EM_HMM(datasetTrain(2).actionData, datasetTrain(2).poseData, G, datasetTrain(2).InitialClassProb, datasetTrain(2).InitialPairProb, maxIter);
[P{3} loglikelihood2 ClassProb3 PairProb3] = EM_HMM(datasetTrain(3).actionData, datasetTrain(3).poseData, G, datasetTrain(3).InitialClassProb, datasetTrain(3).InitialPairProb, maxIter);

n_test = length(datasetTest.actionData);

for n=1:3
    for i = 1:size( datasetTest.poseData, 1)
        logProb = zeros(1,size(datasetTrain(n).InitialClassProb, 2));
        for k = 1:size(datasetTrain(n).InitialClassProb, 2)
            for j = 1:size( datasetTest.poseData, 2)
                D=size(datasetTest.poseData,3);
                pose=reshape(datasetTest.poseData(i,j,:),1,D);
            
                sigma=[P{n}.clg(j).sigma_y(k) P{n}.clg(j).sigma_x(k) P{n}.clg(j).sigma_angle(k)];
                if (G(j,1) == 0) 
                    mu=[P{n}.clg(j).mu_y(k) P{n}.clg(j).mu_x(k) P{n}.clg(j).mu_angle(k)];
                else
                    pa = G(j,2);
                    mu_y =     P{n}.clg(j).theta(k,1) + P{n}.clg(j).theta(k,2)  * datasetTest.poseData(i,pa,1) + P{n}.clg(j).theta(k,3)  * datasetTest.poseData(i,pa,2) + P{n}.clg(j).theta(k,4)  * datasetTest.poseData(i,pa,3);
                    mu_x =     P{n}.clg(j).theta(k,5) + P{n}.clg(j).theta(k,6)  * datasetTest.poseData(i,pa,1) + P{n}.clg(j).theta(k,7)  * datasetTest.poseData(i,pa,2) + P{n}.clg(j).theta(k,8)  * datasetTest.poseData(i,pa,3);
                    mu_angle = P{n}.clg(j).theta(k,9) + P{n}.clg(j).theta(k,10) * datasetTest.poseData(i,pa,1) + P{n}.clg(j).theta(k,11) * datasetTest.poseData(i,pa,2) + P{n}.clg(j).theta(k,12) * datasetTest.poseData(i,pa,3);
                    mu=[mu_y mu_x mu_angle];
                end;
                log_prob = -log(sigma*sqrt(2*pi))-(pose-mu).^2 ./ (2*sigma.^2);
                logProb(k) = logProb(k)+sum(log_prob);
            end

        end
        logEmissionProb{n}(i,:)=logProb;
    end
end

predicted_labels = zeros(n_test,1);
for i=1:n_test
    loglikelihood = zeros(3,1);
    %construct the factors for inference
    indx1 = datasetTest.actionData(i).marg_ind;
    indx2 = datasetTest.actionData(i).pair_ind;
    for n=1:3
            F=repmat(struct('var',[],'card',[],'val',[]),1,length(indx1)+length(indx2));
            %P(S1)
            K = size(datasetTrain(n).InitialClassProb, 2);
            for j=1:length(indx1)
                F(j).var=j;
                F(j).card=K;
                if j==1
                    F(j).val=log(P{n}.c)+logEmissionProb{n}(indx1(j),:);
                else
                    
                    F(j).val=logEmissionProb{n}(indx1(j),:);
                end
            end
            %P(S'|S)
            for l=1:length(indx2)
                F(j+l).var=[l l+1];
                F(j+l).card=[K K];
                F(j+l).val=log(reshape(P{n}.transMatrix,1,prod(F(j+1).card)));
            end
      
            [M, PCalibrated] = ComputeExactMarginalsHMM(F);          
            %Pick a clique and marginalize all the Ss in that clique to get the
            %joint distribution of the Ps
            loglikelihood(n) = loglikelihood(n)+logsumexp(PCalibrated.cliqueList(1).val); 
    end
    [val, indx] = max(loglikelihood);
    predicted_labels(i) = indx;
end

