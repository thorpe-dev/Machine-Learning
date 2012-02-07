function[confMat] = buildTotalConfusionMatrix(examples, targets)

    confMat = zeros(6,6);
    recall = zeros(1,6);
    precision = zeros(1,6);

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
    
    recall = recall/10
    precision = precision/10
    var  = cell(3);
    var{1} = confMat;
    var{2} = recall;
    var{3} = precision;
    save('stats.mat', 'var');
    
end

function[recall, precision] = recall_precision(confMat)

    recall = zeros(1,6);
    precision = zeros(1,6);

    for i = 1:size(confMat, 2)
       
        truePositives = confMat(i, i);
        falseNegatives = sum(confMat(i, :)) - truePositives;
        falsePositives = sum(confMat(:, i)) - truePositives;
        
        recall(i) = truePositives / (truePositives + falsePositives + eps);
        precision(i) = truePositives / (truePositives + falseNegatives + eps);
        
    end

end
