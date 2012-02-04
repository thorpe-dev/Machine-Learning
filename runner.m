function [] = runner()

    [examples, targets] = loaddata('cleandata_students.txt');
    targets = remap(targets, 1);
    tree = decisionTreeLearning(examples, (1:45), targets);
    DrawDecisionTree(tree)

end
