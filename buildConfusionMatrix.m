function [confusionMatrix] = buildConfusionMatrix(trainExamples, ...
    trainTargets, testExamples, testTargets, attributes)

    % builds a confusion matrix for one fold (tenth) of the data

    confusionMatrix = zeros(6,6);

    forest = getDecisionTrees(trainExamples, trainTargets, attributes);

    for i = 1:length(testTargets)
        target = testTargets(i);
        example = testExamples(i, :);
        prediction = getPrediction(forest, example);
        confusionMatrix(target, prediction) = ...
            confusionMatrix(target, prediction) + 1;
    end
end
