function [] = runner()

    % Builds the confusion matrix for the 10-fold cross-validation

    [examples, targets] = loaddata('cleandata_students.txt');
    [confMat, F1folds] = buildTotalConfusionMatrix(examples, targets);
    F1folds
end
