function [] = allRunner()

    [examples, targets] = loaddata('cleandata_students.txt');
    for i = 1:6
        new_targets = remap(targets, i);
        tree = decisionTreeLearning(examples, (1:45), new_targets);
        DrawDecisionTree(tree)
    end

end