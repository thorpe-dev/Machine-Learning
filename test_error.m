function[calc_mean_squared_error] = test_error(vary)

[x,y] = loaddata('cleandata_students.txt');
[x,y] = ANNdata(x,y);

%vary[1] = sizes
%vary[2] = learning rate

sizes = zeros(1,2) + 6

[net] = feedforwardnet(sizes, 'traingd');
[net] = configure(net, x, y);
net.trainParam.show = NaN;
net.trainParam.showWindow = 0;
net.trainParam.showCommandLine = 0;
net.trainParam.goal = 0;

net.trainParam.lr = abs(vary);

[net] = train(net, x, y);
        
[p] = sim(net, x);

calc_mean_squared_error = sum(sum((p-y).^2/length(p)))

end