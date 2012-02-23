function [] = testNNs(networks)

% Load the data in for testing
[x,y] = loaddata('cleandata_students.txt');
[x,y] = ANNdata(x,y);

% Cross validate the larger NN
[net] = networks{1};

confusionMatrices = cell(0);
stats  = cell(0);
largeNNCM = zeros(6,6);
largeRecall = zeros(1,6);
largePrecision = zeros(1,6);

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
    largeCM = buildCM(out, t);
    [thisRecall, thisPrecision] = recall_precision(largeCM);
    largeRecall = largeRecall + thisRecall;
    largePrecision = largePrecision + thisPrecision;
    largeNNCM = largeNNCM + largeCM;
    
end

largeNNCM

% Calculates recall, precision, and f1 measure

largeRecall = largeRecall/10
largePrecision = largePrecision/10
largeF1 = f1measure(largeRecall, largePrecision)
stats{1} = largeNNCM;
stats{2} = largeRecall;
stats{3} = largePrecision;
stats{4} = largeF1;

smallNNsCM = zeros(6,6);
smallRecall = zeros(1,6);
smallPrecision = zeros(1,6);

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
    thisFold = getOneEmotion(thisFold);
    [thisFoldEmotions] = NNout2labels(thisFold);
    [t] = NNout2labels(testTargets);
    smallCM = buildCM(thisFoldEmotions, t);
    [thisRecall, thisPrecision] = recall_precision(smallCM);
    smallRecall = smallRecall + thisRecall;
    smallPrecision = smallPrecision + thisPrecision;
    smallNNsCM = smallNNsCM + smallCM;
    
end

smallNNsCM
% Calculates recall, precision, and f1 measure

smallRecall = smallRecall/10
smallPrecision = smallPrecision/10
smallF1 = f1measure(smallRecall, smallPrecision)
stats{5} = smallNNsCM;
stats{6} = smallRecall;
stats{7} = smallPrecision;
stats{8} = smallF1;

% Saves these statistics to file

save('NNstats.mat', 'stats');

end

function [CM] = buildCM(predictions, testTargets)

CM = zeros(6,6);

for i = 1:length(predictions)
    CM(predictions(i), testTargets(i)) = CM(predictions(i), testTargets(i)) + 1;
end

end

function [fold] = getOneEmotion(foldData)

[m,n] = size(foldData);

sums = sum(foldData);

for i = 1:n
    
    if sums(i) > 1
        ones = find(foldData(:,i) == 1);
        ind = ones(randi(1,length(ones)));
        f = zeros(6,1);
        f(ind) = 1;
        foldData(:,i) = f;
    elseif sums(i) == 0
        foldData(randi([1,6]),i) = 1;
    end
end

fold = foldData;

end

function[recall, precision] = recall_precision(confMat)

% Calculates the recall and precision for the confusion matrix
% for *one* fold

recall = zeros(1,6);
precision = zeros(1,6);

for i = 1:size(confMat, 2)
    
    truePositives = confMat(i, i);
    falseNegatives = sum(confMat(i, :)) - truePositives;
    falsePositives = sum(confMat(:, i)) - truePositives;
    
    recall(i) = truePositives / (truePositives + falsePositives + eps);
    precision(i) = truePositives / (truePositives + falseNegatives ...
        + eps);
    
end

end

function[f1] = f1measure(recall, precision)

% Calculates the f1 measure using the recall and precision for all
% folds

fl = [];

for i = 1:6
    f1(i) = 2 * (recall(i) * precision(i))/ (recall(i) + precision(i));
end

end
