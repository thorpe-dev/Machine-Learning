function[forest] = getDecisionTrees(examples, targets, attributes)
    forest = cell(0);
    for i = 1:6
        new_targets = remap(targets, i);
        forest{i} = decisionTreeLearning(examples, attributes, new_targets);
    end
end

