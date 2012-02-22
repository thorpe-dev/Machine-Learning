function[] = buildNNs()

[x,y] = loaddata('cleandata_students.txt');
[x,y] = ANNdata(x,y);

% create 6-output-NN
n = 100;
results = (1:n) * 0;

for i = 1:n
    [net] = feedforwardnet([6,6],'traingd');
    [net] = configure(net, x, y);
    
    % would change params here
    net.trainParam.lr = i/n;
    net.trainParam.epochs = 100;
    net.trainParam.show = NaN;
    net.trainParam.showWindow = 0;
    net.trainParam.showCommandLine = 0;
    net.trainParam.goal = 0;
    
    times = 100;
    
    for j = 1:times
        [net] = train(net, x, y);
        
        [p] = sim(net, x);
        
        [z] = sum(round(p));
        
        results(i) = results(i) + size(find(z==1), 2);
       
    end
    
    results(i) = results(i)/times
end

plot((1:n), results);

end