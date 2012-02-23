function[results] = buildSmallNNs(joke)

[x,y] = loaddata('cleandata_students.txt');
[x,y] = ANNdata(x,y);

times = 50;
m = 0.2*(joke - 1) + 0.01;
n = 0.2*joke;
results = zeros(6,100);
for lr = m:0.01:n
    for i = 1:6

        y2 = y(i,:);
        perLayer = 7;
        numLayers = 2;
        sizes = zeros(1,numLayers) + perLayer;
        [net] = feedforwardnet(sizes, 'traingd');
        [net] = configure(net, x, y2);

        net.trainParam.epochs = 100;
        net.trainParam.show = NaN;
        net.trainParam.showWindow = 0;
        net.trainParam.showCommandLine = 0;
        net.trainParam.goal = 0;
        net.trainParam.lr = lr;
        for j = 1:times
            [net] = train(net, x, y2);
            [p] = sim(net, x);
            [z] = p > 0.5;
            [u] = z - y2;

            results(i,lr*100) = results(i,lr*100) + 1 - sum(abs(u))/100;
        end
        results(i, lr*100) = results(i, lr*100)/times;
        100*(i + (lr*100 - 1)*6)/(20*6)
    end
end

save(strcat('testLR',num2str(joke)),'results');

