function [] = testCBRs(method)

% Load the data in for testing
[x,y] = loaddata('cleandata_students.txt');

% Set up variables to store the statistics for the larger NN
stats  = cell(0);
confusionMatrix = zeros(6,6);
recall = zeros(1,6);
precision = zeros(1,6);

% Perform the 10-fold cross-validation for the larger NN
for i = 1:10
    
    % Split the data for the fold
    bottomSplit = (i - 1) * length(x) * 0.1;
    topSplit = i * length(x) * 0.1;
    trainExamples = x([1:bottomSplit, (topSplit + 1):end], :);
    trainTargets = y([1:bottomSplit, (topSplit + 1):end]);
    testExamples = x((bottomSplit + 1):topSplit, :);
    testTargets = y((bottomSplit + 1):topSplit);

    % Set up the CBR
    [cbr] = CBRinit(trainExamples, trainTargets);
    

    % Simulate using the test data
    if method == 1
        [pred] = testCBR1(cbr, testExamples);
    else
        [pred] = testCBR2(cbr, testExamples);
    end

    % Build the confusion matrix
    thisCM = buildCM(pred, testTargets);

    % Calculate the recall and precision
    [thisRecall, thisPrecision] = recall_precision(thisCM);

    % Add the recall and precision for averaging later
    recall = recall + thisRecall;
    precision = precision + thisPrecision;
    confusionMatrix = confusionMatrix + thisCM;
    
end

confusionMatrix

% Averages recall and precision, and calculates the f1 measure
recall = recall/10
precision = precision/10
f1 = f1measure(recall, precision)

% Store the statistics to the stats variable for saving to file
stats{1} = confusionMatrix;
stats{2} = recall;
stats{3} = precision;
stats{4} = f1;

save(strcat('testCBRsMethod', num2str(method)), 'stats');

end

function [CM] = buildCM(predictions, testTargets)

CM = zeros(6,6);

for i = 1:length(predictions)
    CM(predictions(i), testTargets(i)) = CM(predictions(i), testTargets(i)) + 1;
end

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
