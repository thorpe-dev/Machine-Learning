function[results] = buildSmallNNs(joke)

[x,y] = loaddata('cleandata_students.txt');
[x,y] = ANNdata(x,y);

times = 10;
m = 5*(joke - 1) + 1;
n = 5*joke;
results = zeros(6,20);
for numLayers = m:n
    for i = 1:6

        y2 = y(i,:);
        perLayer = 7;
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

            results(i,numLayers) = results(i,numLayers) + 1 - sum(abs(u))/100;
        end
        results(i, numLayers) = results(i, numLayers)/times;
        100*(i + (numLayers - 1)*6)/(5*6)
    end
end

save(strcat('testLayers',num2str(joke)),'results');

