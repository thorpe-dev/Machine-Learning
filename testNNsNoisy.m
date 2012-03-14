function [] = testNNsNoisy(networks)

% Load the data in for testing
[cleanX,cleanY] = loaddata('cleandata_students.txt');
[noisyX,noisyY] = loaddata('noisydata_students.txt');
[cleanX,cleanY] = ANNdata(cleanX,cleanY);
[noisyX,noisyY] = ANNdata(noisyX,noisyY);

[net] = networks{1};

% Set up variables to store the statistics for the larger NN
stats  = cell(0);
largeCM = zeros(6,6);

% Configure and train the larger NN
[thisNetwork] = configure(net, cleanX, cleanY);
[thisNetwork] = train(thisNetwork, cleanX, cleanY);

% Simulate using the noisy data
[out] = sim(thisNetwork, noisyX);

% Transform the output
[out] = NNout2labels(findMax(out));
[t] = NNout2labels(noisyY);

% Build the confusion matrix
largeCM = buildCM(out, t)

% Calculate the recall and precision
[largeRecall, largePrecision] = recall_precision(largeCM);
largeRecall
largePrecision
largeF1 = f1measure(largeRecall, largePrecision)

largeF1avg = sum(largeF1)/6

% SMALL NNS

% Initialise a matrix to store the output of each NN
pred = zeros(6, length(noisyY));

% Configure and train the networks for this fold
for i = 1:6
    % Strip out the expected values for this NN
    [thisNetworkTrainTargets] = cleanY(i,:);
    [thisNetwork] = networks{i+1};
    [thisNetwork] = configure(thisNetwork, cleanX, thisNetworkTrainTargets);
    [thisNetwork] = train(thisNetwork, cleanX, thisNetworkTrainTargets);
    [out] = sim(thisNetwork, noisyX);
    
    % Transform the data
    pred(i,:) = out > 0.5;
end

% Ensure only one emotion is selected for each example
pred = getOneEmotion(pred);
[thisFoldEmotions] = NNout2labels(pred);
[t] = NNout2labels(noisyY);

% Build the confusion matrix
smallCM = buildCM(thisFoldEmotions, t)

[smallRecall, smallPrecision] = recall_precision(smallCM);
smallRecall
smallPrecision
smallF1 = f1measure(smallRecall, smallPrecision)

smallF1avg = sum(smallF1)/6

stats{1} = largeCM;
stats{2} = largeRecall;
stats{3} = largePrecision;
stats{4} = largeF1;
stats{5} = smallCM;
stats{6} = smallRecall;
stats{7} = smallPrecision;
stats{8} = smallF1;

end

% Build a confusion matrix given the predictions and correct classifications
function [CM] = buildCM(predictions, noisyY)

CM = zeros(6,6);

for i = 1:length(predictions)
    CM(predictions(i), noisyY(i)) = CM(predictions(i), noisyY(i)) + 1;
end

end

% Ensure only one emotion for each example
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
