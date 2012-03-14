function extractF1Data[f1s] = extractF1Data()

% Extract the data for the ANOVA tests

f1s = cell(0);

% Decision Tree data
f1s{1} = runner();

% NNs data
load('data/networks.mat');
f1s{2} = testNNs(networks);

% CBR data
f1s{3} = testCBRs(2,7);

end

