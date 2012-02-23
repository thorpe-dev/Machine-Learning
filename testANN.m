function [y] = testANN(net, x)

[y] = sim(net, x);
[y] = NNout2labels(y);

end

