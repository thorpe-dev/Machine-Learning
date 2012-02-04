function [] = runner()

    [examples, targets] = loaddata('cleandata_students.txt');
    targets = remap(example_labels, 1);
    tree = decisionTreeLearning(examples, 1:45, targets);
    DrawDecision(tree)

end
