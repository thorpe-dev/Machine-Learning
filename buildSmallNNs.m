function[results] = buildSmallNNs()

[x,y] = loaddata('cleandata_students.txt');
[x,y] = ANNdata(x,y);

times = 10;

results = zeros(6,times+1);

for i = 1:6
    
    y2 = y(i,:);
    
    numLayers = 2;
    perLayer = 25;
    
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
        
        [z] = round(p)
        
        [u] = z - y2;
        
        results(i,j) = 1 - abs(sum(u))/100;
        results;
        
    end
    
    results(i, times+1) = sum(results(i, (1:times))/times);
    i
    
end