%net = feedforwardnet(6);
%net = configure(net, x, y);

% create a function handle
handle = @(vary) test_error(vary);
nvars = 1;
LB = 1;
UB = 25;

ga_opts = gaoptimset('TolFun', 1e-8,'display','iter');
[x_ga_opt, err_ga] = ga(handle,nvars,LB,UB);