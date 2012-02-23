function[results] = buildSmallNNs(emo, index)

[x,y] = loaddata('cleandata_students.txt');
[x,y] = ANNdata(x,y);

times = 50;

results = zeros(8,45);
for numLayers = 1:8
    for perLayer = 1:45

        y2 = y(emo,:);
        sizes = zeros(1,numLayers) + perLayer;
        [net] = feedforwardnet(sizes, 'traingd');
        [net] = configure(net, x, y2);

        net.trainParam.epochs = 100;
        net.trainParam.show = NaN;
        net.trainParam.showWindow = 0;
        net.trainParam.showCommandLine = 0;
        net.trainParam.goal = 0;
        net.trainParam.lr = 0.4;
        for j = 1:times
            [net] = train(net, x, y2);
            [p] = sim(net, x);
            [z] = p > 0.5;
            [u] = z - y2;

            results(numLayers, perLayer) = results(numLayers, perLayer) + 1 - sum(abs(u))/100;
        end
        results(numLayers, perLayer) = results(numLayers, perLayer)/times;
        (numLayers + (perLayer * 8))/(8*45) * 100
    end
end

save(strcat('testLayers',num2str(emo), '_', num2str(index)),'results');

