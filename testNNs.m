function [largeF1Folds, smallF1Folds] = testNNs(networks)

% Load the data in for testing
[x,y] = loaddata('cleandata_students.txt');
[x,y] = ANNdata(x,y);

% Cross validate the larger NN
[net] = networks{1};

% Set up variables to store the statistics for the larger NN
stats  = cell(0);
largeNNCM = zeros(6,6);
largeRecall = zeros(1,6);
largePrecision = zeros(1,6);
largeF1Folds = zeros(6, 10);

% Perform the 10-fold cross-validation for the larger NN
for i = 1:10
    
    % Split the data for the fold
    bottomSplit = (i - 1) * length(x) * 0.1;
    topSplit = i * length(x) * 0.1;
    trainExamples = x(:, [1:bottomSplit, (topSplit + 1):end]);
    trainTargets = y(:, [1:bottomSplit, (topSplit + 1):end]);
    testExamples = x(:, (bottomSplit + 1):topSplit);
    testTargets = y(:, (bottomSplit + 1):topSplit);

    % Configure and train
    [thisNetwork] = configure(net, trainExamples, trainTargets);
    [thisNetwork] = train(thisNetwork, trainExamples, trainTargets);

    % Simulate using the test data
    [out] = sim(thisNetwork, testExamples);

    % Transform the output
    [out] = NNout2labels(findMax(out));
    [t] = NNout2labels(testTargets);

    % Build the confusion matrix
    largeCM = buildCM(out, t);

    % Calculate the recall and precision
    [thisRecall, thisPrecision] = recall_precision(largeCM);
    thisF1 = f1measure(thisRecall, thisPrecision);
    largeF1Folds(i,:) = thisF1;

    % Add the recall and precision for averaging later
    largeRecall = largeRecall + thisRecall;
    largePrecision = largePrecision + thisPrecision;
    largeNNCM = largeNNCM + largeCM;
    
end

[largeRecall, largePrecision] = recall_precision(largeNNCM);
largeNNCM

% Averages recall and precision, and calculates the f1 measure
largeRecall %= largeRecall/10
largePrecision %= largePrecision/10
largeF1 = f1measure(largeRecall, largePrecision)

% Store the statistics to the stats variable for saving to file
stats{1} = largeNNCM;
stats{2} = largeRecall;
stats{3} = largePrecision;
stats{4} = largeF1;

% Set up variables to store the statistics for the smaller NNs
smallNNsCM = zeros(6,6);
smallRecall = zeros(1,6);
smallPrecision = zeros(1,6);
smallF1Folds = zeros(10,6);

% Perform the 10-fold cross-validation on the smaller NNs
for j = 1:10
    
    % Split the data for this fold
    bottomSplit = (j - 1) * length(x) * 0.1;
    topSplit = j * length(x) * 0.1;
    trainExamples = x(:, [1:bottomSplit, (topSplit + 1):end]);
    trainTargets = y(:, [1:bottomSplit, (topSplit + 1):end]);
    testExamples = x(:, (bottomSplit + 1):topSplit);
    testTargets = y(:, (bottomSplit + 1):topSplit);

    % Initialise a matrix to store the output of each NN
    thisFold = zeros(6, length(testTargets));

    % Configure and train the networks for this fold
    for i = 1:6
	% Strip out the expected values for this NN
        [thisNetworkTrainTargets] = trainTargets(i,:);
        [thisNetwork] = networks{i+1};
        [thisNetwork] = configure(thisNetwork, trainExamples, thisNetworkTrainTargets);
        [thisNetwork] = train(thisNetwork, trainExamples, thisNetworkTrainTargets);
        [out] = sim(thisNetwork, testExamples);

	% Transform the data
        thisFold(i,:) = out > 0.5;
    end

    % Ensure only one emotion is selected for each example
    thisFold = getOneEmotion(thisFold);
    [thisFoldEmotions] = NNout2labels(thisFold);
    [t] = NNout2labels(testTargets);

    % Build the confusion matrix
    smallCM = buildCM(thisFoldEmotions, t);

    % Calculate the recall and precision
    [thisRecall, thisPrecision] = recall_precision(smallCM);
    thisF1 = f1measure(thisRecall, thisPrecision);
    smallF1Folds(i,:) = thisF1;

    % Add the recall and precision for averaging later
    smallRecall = smallRecall + thisRecall;
    smallPrecision = smallPrecision + thisPrecision;
    smallNNsCM = smallNNsCM + smallCM;
    
end

smallNNsCM

[smallRecall, smallPrecision] = recall_precision(smallNNsCM);
% Averages recall and precision, and calcaultes the f1 measure
smallRecall %= smallRecall/10
smallPrecision %= smallPrecision/10
smallF1 = f1measure(smallRecall, smallPrecision)

% Store the statistics to the stats variable for saving to file
stats{5} = smallNNsCM;
stats{6} = smallRecall;
stats{7} = smallPrecision;
stats{8} = smallF1;

% Saves these statistics to file
%save('NNstats.mat', 'stats');

end

% Build a confusion matrix given the predictions and correct classifications
function [CM] = buildCM(predictions, testTargets)

CM = zeros(6,6);

for i = 1:length(predictions)
    CM(predictions(i), testTargets(i)) = CM(predictions(i), testTargets(i)) + 1;
end

end

% Ensure only one emotion for eache example
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

% Find the most likely classification for the 6-output NN
function[foldMaxes] = findMax(fold)

[m,n] = size(fold);

foldMaxes = zeros(m, n);

for i = 1:n
   
    thisColumn = fold(:, i);
    maxVal = thisColumn(1);
    maxInd = 1;
    
    for j = 2:m
        if(thisColumn(j) > maxVal)
            maxVal = thisColumn(j);
            maxInd = j;
        end
    end
    
    foldMaxes(maxInd, i) = 1;
            
end

end
