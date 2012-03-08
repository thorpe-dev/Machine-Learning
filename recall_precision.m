function[recall, precision] = recall_precision(confMat)

% Calculates the recall and precision for the confusion matrix
% for *one* fold

recall = zeros(1,6);
precision = zeros(1,6);

for i = 1:size(confMat, 2)
    
    truePositives = confMat(i, i);
    falseNegatives = sum(confMat(i, :)) - truePositives;
    falsePositives = sum(confMat(:, i)) - truePositives;
    
    recall(i) = truePositives / (truePositives + falsePositives + eps);
    precision(i) = truePositives / (truePositives + falseNegatives ...
        + eps);
    
end

end