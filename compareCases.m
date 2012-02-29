function [measure] = compareCases(case1, case2)
% Given two cases, returns the Levenshtein Distance

    case1v = zeros(1, 45);
    case2v = zeros(1, 45);

    case1v(case1.problem) = 1;
    case2v(case2.problem) = 1;

    measure = 2*sum(abs(case2v - case1v)) - sum(case2v & case1v)^2;

end

