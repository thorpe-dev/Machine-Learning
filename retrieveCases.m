function [cases] = retrieveCases(cbr, newcase, k, metric)
  cases = cell(0);
  sortedCases = buildSortedCases(cbr, newcase, metric);

  if isequal(sortedCases.nodeCase.problem, newcase.problem)
    cases{end + 1} = sortedCases.nodeCase;
  else
    for i = 1:k
      cases{i} = sortedCases.nodeCase;
      sortedCases = sortedCases.next;
    end
  end

  finalDistance = compareCases(cases{end}, newcase, metric);

  lastCases = cell(0);
  typ = zeros(1,6);
  while ~isequal(sortedCases, []) && sortedCases.distance == finalDistance
    lastCases{end + 1} = sortedCases.nodeCase;
    typ = typ + sortedCases.nodeCase.typicality;
    sortedCases = sortedCases.next;
  end

  if size(lastCases, 2) > 0
    maxes = find(typ == max(typ));
    emotion = maxes(randi(size(maxes)));
    maxTypForEmo = 0;
    maximalCases = cell(0);
    for i = 1:size(lastCases, 2)
      if(lastCases{i}.typicality(emotion) > maxTypForEmo)
        maximalCases = cell(0);
        maximalCases{1} = lastCases{i};
        maxTypForEmo = lastCases{i}.typicality(emotion);
      end
    end
    lastCases{end + 1} = maximalCases{randi(size(maximalCases, 2))};
  end
end
