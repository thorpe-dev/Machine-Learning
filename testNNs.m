function [] = testNNs(networks)

% Load the data in for testing
[x,y] = loaddata('cleandata_students.txt');
[x,y] = ANNdata(x,y);

% Cross validate the larger NN
[net] = networks{1};

confusionMatrices = cell(0);

largeNNCM = zeros(6,6);
%{
for i = 1:10
    
    bottomSplit = (i - 1) * length(x) * 0.1;
    topSplit = i * length(x) * 0.1;
    trainExamples = x(:, [1:bottomSplit, (topSplit + 1):end]);
    trainTargets = y(:, [1:bottomSplit, (topSplit + 1):end]);
    testExamples = x(:, (bottomSplit + 1):topSplit);
    testTargets = y(:, (bottomSplit + 1):topSplit);
    [thisNetwork] = configure(net, trainExamples, trainTargets);
    [thisNetwork] = train(thisNetwork, trainExamples, trainTargets);
    [out] = sim(thisNetwork, testExamples);
    [out] = NNout2labels(round(out));
    [t] = NNout2labels(testTargets);
    largeNNCM = largeNNCM + buildLargeNNConfusionMatrix(out, t);
    
end
%}

smallNNsCM = zeros(6,6);
for j = 1:10

    bottomSplit = (j - 1) * length(x) * 0.1;
    topSplit = j * length(x) * 0.1;
    trainExamples = x(:, [1:bottomSplit, (topSplit + 1):end]);
    trainTargets = y(:, [1:bottomSplit, (topSplit + 1):end]);
    testExamples = x(:, (bottomSplit + 1):topSplit);
    testTargets = y(:, (bottomSplit + 1):topSplit);
    thisFold = zeros(6, length(testTargets));
    for i = 1:6
        [thisNetworkTrainTargets] = trainTargets(i,:);
        [thisNetwork] = networks{i+1};
        [thisNetwork] = configure(thisNetwork, trainExamples, thisNetworkTrainTargets);
        [thisNetwork] = train(thisNetwork, trainExamples, thisNetworkTrainTargets);
        [out] = sim(thisNetwork, testExamples);
        thisFold(i,:) = round(out);
    end
    thisFold = getOneEmotion(thisFold)


end

end

function [largeNNConfMat] = buildLargeNNConfusionMatrix(predictions, testTargets)

largeNNConfMat = zeros(6,6);

for i = 1:length(predictions)
    largeNNConfMat(predictions(i), testTargets(i)) = largeNNConfMat(predictions(i), testTargets(i)) + 1;
end

end

function [fold] = getOneEmotion(foldData)

[m,n] = size(foldData);

sums = sum(foldData);

for i = 1:m

  if sums(i) > 1

    ind = randi(find(foldData(i,:) == 1));
    f = zeros(1,6);
    f(ind) = 1;
    foldData(i,:) = f;
  elseif sums(i) == 0
    foldData(randi(i,[1,6])) = 1;
  end
end

fold = foldData

end
