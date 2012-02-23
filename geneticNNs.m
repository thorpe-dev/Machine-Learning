%net = feedforwardnet(6);
%net = configure(net, x, y);

% create a function handle
handle = @(vary1,vary2) test_error(vary1,vary2);
nvars = 2;
LB = [0 1];
UB = [1 30];

ga_opts = gaoptimset('TolFun', 1e-3,'display','iter');
x_ga_opt = ga(handle,nvars,LB,UB);