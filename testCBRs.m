function [perFoldF1s] = testCBRs(metric, k)


    % Load the data in for testing
    [x,y] = loaddata('cleandata_students.txt');

    stats  = cell(0);
    confusionMatrix = zeros(6,6);
    perFoldF1s = zeros(10, 6);

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
        % recall = recall + thisRecall;
        % precision = precision + thisPrecision;
        confusionMatrix = confusionMatrix + thisCM;
        perFoldF1s(i, :) = thisF1;
    end

    confusionMatrix

    % Averages recall and precision, and calculates the f1 measure
    %recall = recall/10
    %precision = precision/10
    [recall, precision] = recall_precision(confusionMatrix);
    recall
    precision
    f1 = f1measure(recall, precision)
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
