function [] = allRunner()

    forest = cell(0);

    [examples, targets] = loaddata('cleandata_students.txt');
    for i = 1:6
        new_targets = remap(targets, i);
        tree = decisionTreeLearning(examples, (1:45), new_targets);
        DrawDecisionTree(tree)
        forest{i} = tree;
    end

    save('trees.mat', 'forest')
   
end