function [measure] = compareCases(case1, case2)
% Given two cases, returns the edit distance

case1v = zeros(1, 45);
case2v = zeros(1, 45);

case1v(case1) = 1;
case2v(case2) = 1;

measure = sum(abs(case2v - case1v));

end

