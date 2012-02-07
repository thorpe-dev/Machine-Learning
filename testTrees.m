function [targets] = testTrees(forest, examples)

    targets = []

    for i = 1:size(examples, 1)
        example = examples(i, :);
        targets = vetcat(targets, getPrediction(forest, eg);
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
    else
      prediction = positives(randi([1,length(positives)]));
    end


end
