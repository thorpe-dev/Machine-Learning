function [c] = retrieve(cbr, newcase, k, metric)

  cases = retrieveCases(cbr, newcase, k, metric);
  typ = zeros(1,6);

  for i = 1:size(cases, 2)
    current = cases{i};
    typ = typ + current.typicality;
  end
  maxes = find(typ == max(typ));
  emotion = maxes(randi(size(maxes)));
  c =  createCase([], emotion);
end
