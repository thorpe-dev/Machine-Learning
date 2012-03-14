function [largeF1Folds] = testNNs(networks)

  % Load the data in for testing
  [x,y] = loaddata('cleandata_students.txt');
  [x,y] = ANNdata(x,y);

  % Cross validate the larger NN
  [net] = networks{1};

  % Set up variables to store the statistics for the larger NN
  stats  = cell(0);
  largeNNCM = zeros(6,6);
  largeRecall = zeros(1,6);
  largePrecision = zeros(1,6);
  largeF1Folds = zeros(10, 6);

  % Perform the 10-fold cross-validation for the larger NN
  for i = 1:10
    % Split the data for the fold
    bottomSplit = (i - 1) * length(x) * 0.1;
    topSplit = i * length(x) * 0.1;
    trainExamples = x(:, [1:bottomSplit, (topSplit + 1):end]);
    trainTargets = y(:, [1:bottomSplit, (topSplit + 1):end]);
    testExamples = x(:, (bottomSplit + 1):topSplit);
    testTargets = y(:, (bottomSplit + 1):topSplit);

    % Configure and train
    [thisNetwork] = configure(net, trainExamples, trainTargets);
    [thisNetwork] = train(thisNetwork, trainExamples, trainTargets);

    % Simulate using the test data
    [out] = sim(thisNetwork, testExamples);

    % Transform the output
    [out] = NNout2labels(findMax(out));
    [t] = NNout2labels(testTargets);

    % Build the confusion matrix
    largeCM = buildCM(out, t);


    [recallPerFold, precPerFold] = recall_precision(largeCM);
    largeF1Folds(i, :) = f1measure(recallPerFold, precPerFold);
    % Add the recall and precision for averaging later
    largeNNCM = largeNNCM + largeCM;
  end

  [largeRecall, largePrecision] = recall_precision(largeNNCM);
  largeNNCM

  largeF1 = f1measure(largeRecall, largePrecision)

  % Store the statistics to the stats variable for saving to file
  stats{1} = largeNNCM; stats{2} = largeRecall; stats{3} = largePrecision; stats{4} = largeF1;

  % Set up variables to store the statistics for the smaller NNs
  smallNNsCM = zeros(6,6);
  smallRecall = zeros(1,6);
  smallPrecision = zeros(1,6);

  % Perform the 10-fold cross-validation on the smaller NNs
  for j = 1:10

    % Split the data for this fold
    bottomSplit = (j - 1) * length(x) * 0.1;
    topSplit = j * length(x) * 0.1;
    trainExamples = x(:, [1:bottomSplit, (topSplit + 1):end]);
    trainTargets = y(:, [1:bottomSplit, (topSplit + 1):end]);
    testExamples = x(:, (bottomSplit + 1):topSplit);
    testTargets = y(:, (bottomSplit + 1):topSplit);

    % Initialise a matrix to store the output of each NN
    thisFold = zeros(6, length(testTargets));

    % Configure and train the networks for this fold
    for i = 1:6
      % Strip out the expected values for this NN
      [thisNetworkTrainTargets] = trainTargets(i,:);
      [thisNetwork] = networks{i+1};
      [thisNetwork] = configure(thisNetwork, trainExamples, thisNetworkTrainTargets);
      [thisNetwork] = train(thisNetwork, trainExamples, thisNetworkTrainTargets);
      [out] = sim(thisNetwork, testExamples);

      % Transform the data
      thisFold(i,:) = out > 0.5;
    end

    % Ensure only one emotion is selected for each example
    thisFold = getOneEmotion(thisFold);
    [thisFoldEmotions] = NNout2labels(thisFold);
    [t] = NNout2labels(testTargets);

    % Build the confusion matrix
    smallCM = buildCM(thisFoldEmotions, t);

    % Add the recall and precision for averaging later
    smallNNsCM = smallNNsCM + smallCM;
  end

  [smallRecall, smallPrecision] = recall_precision(smallNNsCM);
  smallF1 = f1measure(smallRecall, smallPrecision)

  % Store the statistics to the stats variable for saving to file
  stats{5} = smallNNsCM; stats{6} = smallRecall; stats{7} = smallPrecision; stats{8} = smallF1;

end

% Build a confusion matrix given the predictions and correct classifications
function [CM] = buildCM(predictions, testTargets)

  CM = zeros(6,6);

  for i = 1:length(predictions)
      CM(predictions(i), testTargets(i)) = CM(predictions(i), testTargets(i)) + 1;
  end

end

% Ensure only one emotion for eache example
function [fold] = getOneEmotion(foldData)

  [m,n] = size(foldData);

  sums = sum(foldData);

  for i = 1:n
    if sums(i) > 1
        ones = find(foldData(:,i) == 1);
        ind = ones(randi(1,length(ones)));
        f = zeros(6,1);
        f(ind) = 1;
        foldData(:,i) = f;
    elseif sums(i) == 0
        foldData(randi([1,6]),i) = 1;
    end
  end

  fold = foldData;

end

% Find the most likely classification for the 6-output NN
function[foldMaxes] = findMax(fold)
  [m,n] = size(fold);
  foldMaxes = zeros(m, n);
  for i = 1:n
    thisColumn = fold(:, i);
    maxVal = thisColumn(1);
    maxInd = 1;
    for j = 2:m
        if(thisColumn(j) > maxVal)
            maxVal = thisColumn(j);
            maxInd = j;
        end
    end
    foldMaxes(maxInd, i) = 1;
  end
end
