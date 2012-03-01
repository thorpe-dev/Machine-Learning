function [solvedcase] = reuse(bestcase, newcase)
% Attaches case's solution to newcase

    t = bestcase.typicality;
    maxes = find(t == max(t));
    emotion = maxes(randi(size(maxes)));
    solvedcase.problem = newcase.problem;
    typ = zeros(1,6);
    typ(emotion) = 1;
    solvedcase.typicality = typ;

end

