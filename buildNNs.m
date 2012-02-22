function[results] = buildNNs()

[x,y] = loaddata('cleandata_students.txt');
[x,y] = ANNdata(x,y);

% create 6-output-NN
n = 8;
m = 45;
results = zeros(m,n);

for k = 10:18

    for i = 1:n
        sizes = zeros(1,i) + k;
        [net] = feedforwardnet(sizes, 'traingd');
        [net] = configure(net, x, y);
        
        % would change params here
        net.trainParam.epochs = 100;
        net.trainParam.show = NaN;
        net.trainParam.showWindow = 0;
        net.trainParam.showCommandLine = 0;
        net.trainParam.goal = 0;
        
        times = 100;
        
        for j = 1:times
        [net] = train(net, x, y);
        
        [p] = sim(net, x);
        
        [z] = round(p);
        
        [u] = z & y;
        
        [l] = sum(u);

            
            results(k,i) = results(k,i) + size(find(l==1), 2);
            
        end
        
        results(k,i) = results(k,i)/times;
        (((k - 1)*n+i)/(m*n)) * 100;
        
    end
    
end

    save('graph.mat', 'results');

    %grid on;
    
    %surfc((1:n),(1:m), results);
end