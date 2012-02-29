function [cbr] = retain(cbr, newcase)
% Adds a new case to the CBR, considering dupes

%    cbr = addCaseToBT(cbr, newcase);
    
    for i = 1:size(cbr, 2)
        if compareCases(newcase, cbr{i}) == 0
            t = cbr{i}.typicality;
            t = t + newcase.typicality;
            cbr{1}.typicality = t;
            return;
        end
    end

    cbr{end+1} = newcase;

end
