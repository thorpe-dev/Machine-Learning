function [networks] = buildNNs(NNlayers, NNperLayer, NNLR, smallNNlayers, smallNNperLayer, smallNNLR)

networks = cell(0);

% Create the large Neural Network
NNsizes = zeros(1, NNlayers) + NNperLayer;
[net] = feedforwardnet(NNsizes, 'traingd');

% Set the configuration of the large NN using arguments
net.trainParam.epochs = 100;
net.trainParam.show = NaN;
net.trainParam.showWindow = 0;
net.trainParam.showCommandLine = 0;
net.trainParam.goal = 0;
net.trainParam.lr = NNLR;

networks{1} = net;

% Create the smaller Neural Networks
for i = 1:6
    
    smallNNsizes = zeros(1, smallNNlayers) + smallNNperLayer;
    [net] = feedforwardnet(smallNNsizes, 'traingd');
    
% Set the configuration of the smaller NNs using arguments
    net.trainParam.epochs = 100;
    net.trainParam.show = NaN;
    net.trainParam.showWindow = 0;
    net.trainParam.showCommandLine = 0;
    net.trainParam.goal = 0;
    net.trainParam.lr = smallNNLR;
    
    networks{i+1} = net;
    
end

% Save the networks to a file
save('networks.mat', 'networks');

end

