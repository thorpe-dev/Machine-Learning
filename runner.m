function [] = runner()

    % Builds the confusion matrix for the 10-fold cross-validation

    [examples, targets] = loaddata('cleandata_students.txt');
    confMat = buildTotalConfusionMatrix(examples, targets)
end
