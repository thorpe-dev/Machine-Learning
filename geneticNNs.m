[x,y] = loaddata('cleandata_students.txt');
[x,y] = ANNdata(x,y);

net = feedforwardnet(6);

net = configure(net, inputs, targets);

% create a function handle
handle = @(x) test_error(net, input,targets);

ga_opts = gaoptimset('TolFun', 1e-8,'display','iter');
[x_ga_opt, err_ga] = ga(handle,3*n+1, ga_opts);