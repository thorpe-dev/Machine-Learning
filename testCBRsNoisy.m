function [] = testCBRsNoisy(metric, k)


    % Load the data in for testing
    [x,y] = loaddata('cleandata_students.txt');

    % Set up variables to store the statistics for the larger NN
    stats  = cell(0);
    
    % Set up the CBR
    [cbr] = CBRinit(x, y);

    [tx,ty] = loaddata('noisydata_students.txt');
    
    % Simulate using the test data
    [pred] = testCBR(cbr, tx, k, metric);

    % Build the confusion matrix
    confusionMatrix = buildCM(pred, ty)

    % Averages recall and precision, and calculates the f1 measure
    [recall, precision] = recall_precision(confusionMatrix);
    recall
    precision
    f1 = f1measure(recall, precision)
    
    avgf1 = sum(f1)/6
    
    % Store the statistics to the stats variable for saving to file
    stats{1} = confusionMatrix;
    stats{2} = recall;
    stats{3} = precision;
    stats{4} = f1;

    save('tests/testCBRsNoisy', 'stats');

end

function [CM] = buildCM(predictions, testTargets)

    CM = zeros(6,6);

    for i = 1:length(predictions)
        CM(predictions(i), testTargets(i)) = CM(predictions(i), testTargets(i)) + 1;
    end

end
