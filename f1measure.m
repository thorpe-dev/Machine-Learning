function[f1] = f1measure(recall, precision)

% Calculates the f1 measure using the recall and precision for all
% folds

fl = [];

for i = 1:6
    f1(i) = 2 * (recall(i) * precision(i))/ (recall(i) + precision(i));
end

end