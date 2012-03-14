function [] = testNNsNoisy(networks)

% Load the data in for testing
[x,y] = loaddata('cleandata_students.txt');
[noisyX,noisyY] = loaddata('noisydata_students.txt');
[noisyX,noisyY] = ANNdata(noisyX,noisyY);
[x,y] = ANNdata(x,y);

% Cross validate the larger NN
[net] = networks{1};

% Set up variables to store the statistics for the larger NN
stats  = cell(0);
largeNNCM = zeros(6,6);

    % Configure and train
    [thisNetwork] = configure(net, x, y);
    [thisNetwork] = train(thisNetwork, x, y);

    % Simulate using the test data
    [out] = sim(thisNetwork, noisyX);

    % Transform the output
    [out] = NNout2labels(findMax(out));
    [t] = NNout2labels(noisyY);

    % Build the confusion matrix
    largeCM = buildCM(out, t)

    % Calculate the recall and precision

    % Add the recall and precision for averaging later



    % Initialise a matrix to store the output of each NN
    thisFold = zeros(6, length(noisyY));

    % Configure and train the networks for this fold
    for i = 1:6
        % Strip out the expected values for this NN
        [thisNetworkTrainTargets] = y(i,:);
        [thisNetwork] = networks{i+1};
        [thisNetwork] = configure(thisNetwork, x, thisNetworkTrainTargets);
        [thisNetwork] = train(thisNetwork, x, thisNetworkTrainTargets);
        [out] = sim(thisNetwork, noisyX);

        % Transform the data
        thisFold(i,:) = out > 0.5;
    end

    % Ensure only one emotion is selected for each example
    thisFold = getOneEmotion(thisFold);
    [thisFoldEmotions] = NNout2labels(thisFold);
    [t] = NNout2labels(noisyY);

    % Build the confusion matrix
    smallCM = buildCM(thisFoldEmotions, t)
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
