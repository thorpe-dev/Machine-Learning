function calc_mean_squared_error = test_error(net, inputs, targets)

y = net(inputs);
calc_mean_squared_error = sum((y-targets).^2/length(y))

end