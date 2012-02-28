function [cbr] = CBRinit(x, y)
% Given x and y, creates the CBR

cbr = cell(0);

for i = 1:size(x, 1)
    case_x = find(x(i,:) == 1);
    case_y = y(i);
    thisCase = createCase(case_x, case_y);
    cbr = addCase(cbr, thisCase);
end

end

function [cbr] = addCase(cbr, newcase)
% Adds a new case to the CBR, considering dupes

for i = 1:size(cbr, 1)
   if isequal(newcase.problem, cbr{i}.problem)
      t = cbr{i}.typicality;
      t = t + newcase.typicality;
      cbr{1}.typicality = t;
      %cbr = cbr;
      return;
   end
end

cbr{end+1} = newcase;
%cbr = cbr;

end