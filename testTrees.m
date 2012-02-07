function [targets] = testTrees(forest, examples)

    targets = []
    for i = 1:size(examples, 1)
        example = examples(i, :);
        targets = vertcat(targets, getPrediction(forest, example));
    end

end
