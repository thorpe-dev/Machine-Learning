function [] = runner()

    [examples, targets] = loaddata('cleandata_students.txt');
%    for i = 1:6
%        new_targets = remap(targets, i);
%        tree = decisionTreeLearning(examples, (1:45), new_targets);
%        DrawDecisionTree(tree)
%    end

    confMat = zeros(6,6);

    for i = 1:10
        bottomSplit = (i - 1) * length(examples) * 0.1;
        topSplit = i * length(examples) * 0.1;
        trainExamples = examples([1:bottomSplit, (topSplit + 1):end], :);
        trainTargets = targets([1:bottomSplit, (topSplit + 1):end]);
        testExamples = examples((bottomSplit + 1):topSplit, :);
        testTargets = targets((bottomSplit + 1):topSplit);
        confMat = confMat + buildConfusionMatrix(trainExamples, ...
            trainTargets, testExamples, testTargets, (1:45));
    end

    confMat


end