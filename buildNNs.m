function[] = buildNNs()

[x,y] = loaddata('cleandata_students.txt');
[x,y] = ANNdata(x,y);

% create 6-output-NN
n = 10;
results = zeros(1,n);

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
    
    times = 10;
    
    for j = 1:times
        [net] = train(net, x, y);
        
        [p] = sim(net, x);
        
        [z] = round(p);
        
        [u] = z & y;
        
        [k] = sum(u);
        
        results(i) = results(i) + size(find(k==1), 2);
       
    end
    
    results(i) = results(i)/times
end

plot((1:n), results);

end