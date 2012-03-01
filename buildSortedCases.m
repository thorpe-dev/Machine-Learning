function [sortedCases] = buildSortedCases(cbr, newcase)

  sortedCases.nodeCase = cbr{1};
  sortedCases.distance = compareCases(newcase, cbr{1};
  sortedCases.next = []

  for i = 2:size(cbr, 2);
    distance = compareCases(newcase, cbr{i});
    sortedCases = insertCase(sortedCases, cbr{i}, distance);
  end

end

function [sortedCases] = insertCase(sortedCases, newcase, distance)
  if sortedCases.distance < distance
    if isequal(sortedCases.next, [])
      sortedCases.next.nodecase = newcase;
      sortedCases.next.distance = distance;
      sortedCases.next.next = [];
    else
      insertCases(sortedCases.next, newcase, distance);
    end
  end

end
