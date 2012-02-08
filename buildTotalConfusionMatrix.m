function[confMat] = buildTotalConfusionMatrix(examples, targets)

    confMat = zeros(6,6);
    recall = zeros(1,6);
    precision = zeros(1,6);

    % Splits the data into ten folds, and sums the confusion
    % matrices for each fold
    
    for i = 1:10
        bottomSplit = (i - 1) * length(examples) * 0.1;
        topSplit = i * length(examples) * 0.1;
        trainExamples = examples([1:bottomSplit, (topSplit + 1):end], :);
        trainTargets = targets([1:bottomSplit, (topSplit + 1):end]);
        testExamples = examples((bottomSplit + 1):topSplit, :);
        testTargets = targets((bottomSplit + 1):topSplit);
        thisConfMat =  buildConfusionMatrix(trainExamples, ...
            trainTargets, testExamples, testTargets, (1:45));
        [thisRecall, thisPrecision] = recall_precision(thisConfMat);
        recall = recall + thisRecall;
        precision = precision + thisPrecision;
        confMat = confMat + thisConfMat;
    end
    
    % Calculates recall, precision, and f1 measure
    
    recall = recall/10
    precision = precision/10
    f1 = f1measure(recall, precision)
    var  = cell(3);
    var{1} = confMat;
    var{2} = recall;
    var{3} = precision;
    var{4} = f1;
    
    % Saves these statistics to file
    
    save('stats.mat', 'var');
    
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