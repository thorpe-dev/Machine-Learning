function [cbr] = retain(cbr, newcase)
% Adds a new case to the CBR, considering dupes

    for i = 1:size(cbr, 1)
        if isequal(newcase.problem, cbr{i}.problem)
            t = cbr{i}.typicality;
            t = t + newcase.typicality;
            cbr{1}.typicality = t;
            return;
        end
    end

    cbr{end+1} = newcase;

end