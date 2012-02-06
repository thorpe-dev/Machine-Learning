function [confusionMatrix] = buildConfusionMatrix(trainExamples, trainTargets, testExamples, testTargets, attributes)

    confusionMatrix = [];

    for emotion = 1:6
        newTargets = remap(trainTargets, emotion);
        tree = decisionTreeLearning(trainExamples, attributes, newTargets);

        confusionMatrix(emotion, :) = getPredictionVector(tree, testExamples, testTargets);

    end

end

function [vector] = getPredictionVector(tree, testExamples, testTargets)

    vector = zeros(6, 1);
    for i = 1:size(testExamples, 1)
        eg = testExamples(i, :);
        target = testTargets(i);
        currTree = tree;
        while size(currTree.kids) ~= 0
            currTree = currTree.kids{eg(currTree.op) + 1};
        end
        vector(target) = vector(target) + currTree.class;
    end

end
