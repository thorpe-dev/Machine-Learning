function[results] = buildNNs()

[x,y] = loaddata('cleandata_students.txt');
[x,y] = ANNdata(x,y);

% create 6-output-NN
numLayers = 2;
perLayer = 25;
results = zeros(1,100);

for i = 1:100
    sizes = zeros(1,numLayers) + perLayer;
    [net] = feedforwardnet(sizes, 'traingd');
    [net] = configure(net, x, y);
    
    % would change params here
    net.trainParam.epochs = 100;
    net.trainParam.show = NaN;
    net.trainParam.showWindow = 0;
    net.trainParam.showCommandLine = 0;
    net.trainParam.goal = 0;
    net.trainParam.lr = i/100;
    
    times = 10;
    
    for j = 1:times
        [net] = train(net, x, y);
        
        [p] = sim(net, x);
        
        [z] = round(p);
        
        [u] = z & y;
        
        [l] = sum(u);
       
        results(i) = results(i) + size(find(l==1), 2);
        
    end
    
    results(i) = results(i)/times;
    i
    
end