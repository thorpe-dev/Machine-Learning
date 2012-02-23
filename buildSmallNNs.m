[x,y] = loaddata('cleandata_students.txt');
[x,y] = ANNdata(x,y);

results = zeros(6,10);
for epochs = 1:10
    for i = 1:6

        y2 = y(i,:);
        perLayer = 7;
        numLayers = 2;
        sizes = zeros(1,numLayers) + perLayer;
        [net] = feedforwardnet(sizes, 'traingd');
        [net] = configure(net, x, y2);

        net.trainParam.epochs = epochs;
        net.trainParam.show = NaN;
        net.trainParam.showWindow = 0;
        net.trainParam.showCommandLine = 0;
        net.trainParam.goal = 0;
        net.trainParam.lr = 0.4;
            
            [net] = train(net, x, y2);
            [p] = sim(net, x);
            [z] = p > 0.5;
            [u] = z - y2;

            results(i,epochs) = results(i,epochs) + 1 - sum(abs(u));

        results(i, epochs) = results(i, epochs);
    end
end

save('testepochs','results');
