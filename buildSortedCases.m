function [sortedCases] = buildSortedCases(cbr, newcase, metric)

  sortedCases.nodeCase = cbr{1};
  sortedCases.distance = compareCases(newcase, cbr{1}, metric);
  sortedCases.next = [];
  for i = 2:size(cbr, 2)
    distance = compareCases(newcase, cbr{i}, metric);
    sortedCases = insertCase(sortedCases, cbr{i}, distance);
  end

end

function [newSortedCases] = insertCase(sortedCases, newcase, distance)
  if distance > sortedCases.distance
    if isequal(sortedCases.next, [])
      newSortedCases.nodeCase = sortedCases.nodeCase;
      newSortedCases.distance = sortedCases.distance;
      newSortedCases.next.nodeCase = newcase;
      newSortedCases.next.distance = distance;
      newSortedCases.next.next = [];
    else
      newSortedCases.nodeCase = sortedCases.nodeCase;
      newSortedCases.distance = sortedCases.distance;
      newSortedCases.next = insertCase(sortedCases.next, newcase, distance);
    end
  else
    newSortedCases.nodeCase = newcase;
    newSortedCases.distance = distance;
    newSortedCases.next = sortedCases;
  end
end
