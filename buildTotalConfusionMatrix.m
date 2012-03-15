function[confMat, F1folds] = buildTotalConfusionMatrix(examples, targets)

  confMat = zeros(6,6);
  recall = zeros(1,6);
  precision = zeros(1,6);
  F1folds = zeros(10,6);

  % Splits the data into ten folds, and sums the confusion
  % matrices for each fold


  examples = cell(1,10);
  for i = 1:10
    examples{i} = targets[round(91*(i-1)/10):round(91*i/10)];
  end


  for i = 1:10

    trainExamples = examples([examples{1:(i-1)}, examples{i+1:end}], :);
    trainTargets = targets(examples{i});
    testExamples = examples((bottomSplit + 1):topSplit, :);
    testTargets = targets((bottomSplit + 1):topSplit);
    thisConfMat =  buildConfusionMatrix(trainExamples, trainTargets, testExamples, testTargets, (1:45));
    [thisRecall, thisPrecision] = recall_precision(thisConfMat);
    F1folds(i,:) = f1measure(thisRecall, thisPrecision);

    recall = recall + thisRecall;
    precision = precision + thisPrecision;
    confMat = confMat + thisConfMat;
  end



  % Calculates recall, precision, and f1 measure
  recall = recall/10
  precision = precision/10
  f1 = f1measure(recall, precision)
  var  = cell(3);
  var{1} = confMat;
  var{2} = recall;
  var{3} = precision;
  var{4} = f1;

  % Saves these statistics to file

  save('data/stats.mat', 'var');

end
