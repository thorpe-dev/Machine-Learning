function [targets] = testTrees(forest, examples)

    targets = []

    for i = 1:size(examples, 1)
        example = examples(i, :);
        targets = vertcat(targets, getPrediction(forest, example));
    end

end

function[prediction] = getPrediction(forest, example)

    positives = []

    for emotion = 1:6
        if isClassifiedAs(forest{emotion}, example)
            positives(end + 1) = emotion;
        end
    end

    if length(positives) == 1
      prediction = positives(1);
    else if length(positives) == 0
      prediction = randi([1,6]);
    else
      prediction = positives(randi([1,length(positives)]));
    end


end

function[classified] = isClassifiedAs(tree, example)

    while size(tree.kids) ~= 0
        tree = tree.kids{example(tree.op) + 1};
    end
    classified = tree.class;

end
