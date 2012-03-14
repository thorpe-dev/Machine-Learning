function [avg] = testCBRs(metric, k)


    % Load the data in for testing
    [x,y] = loaddata('cleandata_students.txt');

    % Set up variables to store the statistics for the larger NN
    stats  = cell(0);
    confusionMatrix = zeros(6,6);
    perFold = zeros(1, 10);

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
        [pred] = testCBR(cbr, testExamples, k, metric);

        % Build the confusion matrix
        thisCM = buildCM(pred, testTargets);

        % Calculate the recall and precision
        [thisRecall, thisPrecision] = recall_precision(thisCM);
        thisF1 = f1measure(thisRecall, thisPrecision);
        % Add the recall and precision for averaging later
     %   recall = recall + thisRecall;
     %   precision = precision + thisPrecision;
        confusionMatrix = confusionMatrix + thisCM;
%        perFold(i) = thisF1;
    end

    confusionMatrix

    % Averages recall and precision, and calculates the f1 measure
    %recall = recall/10
    %precision = precision/10
    [recall, precision] = recall_precision(confusionMatrix);
    recall
    precision
    f1 = f1measure(recall, precision)
    avg = sum(f1)/6;
    % Store the statistics to the stats variable for saving to file
    stats{1} = confusionMatrix;
    stats{2} = recall;
    stats{3} = precision;
    stats{4} = f1;

    save(strcat('tests/testCBRsMetric', num2str(metric), 'k', num2str(k)), 'stats');

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

        recall(i) = (truePositives  + eps)/ (truePositives + falsePositives + eps);
        precision(i) = (truePositives + eps) / (truePositives + falseNegatives ...
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
