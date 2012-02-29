function [measure] = compareCases(case1, case2, metric)
% Given two cases, returns the Levenshtein Distance


    case1v = zeros(1, 45);
    case2v = zeros(1, 45);

    case1v(case1.problem) = 1;
    case2v(case2.problem) = 1;
    switch metric
    case 1
        measure = 2*sum(abs(case2v - case1v))^2 - sum(case2v & case1v)^2;
    case 2
        measure = 2*sum(abs(case2v - case1v)) - sum(case2v & case1v)^2;
    otherwise
        measure = sum(abs(case2v - case1v));
    end
            
end

