function [cases] = retrieveCases(cbr, newcase, k)

  cases = Cell(0);
  sortedCases = buildSortedCases(cbr, newcase);

  for i = 1:k
    cases{end + 1} = sortedCases.nodeCase;
    sortedCases = sortedCases.next;
  end
  finalDistance = compareCases(cases{end + 1}, newcase);

  while sortedCases.nodeCase.distance == finalDistance
    cases{end + 1} = sortedCases.nodeCase;
    sortedCase = sortedCase.next;
  end


%{
  cases = cell(0);
  if(size(cbr) > 0)
    cases{1} = cbr{1};
    min_distance = compareCases(cbr{1}, newcase);
    for i = 2:size(cbr,2)
      current = cbr{i};
      dist = compareCases(current, newcase);
      if(min_distance == dist)
        cases{end + 1} = current;
      elseif(dist < min_distance)
        min_distance = dist;
        cases = {};
        cases{1} = current;
      end
    end
  end
  %}
end
