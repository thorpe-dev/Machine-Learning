function [cbr] = CBRinit(x, y)
% Given x and y, creates the CBR
    %cbr.nodeCase = [];
    cbr = cell(0);
    for i = 1:size(x, 1)
        case_x = find(x(i,:) == 1);
        case_y = y(i);
        thisCase = createCase(case_x, case_y);
        cbr = retain(cbr, thisCase);
    end

end
