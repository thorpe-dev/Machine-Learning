function [c] = retrieve(cbr, newcase, k, metric)

  cases = retrieveCases(cbr, newcase, k, metric);
  n = size(cases, 2);
  mult_factor = 1.5;
  currentDistance = compareCases(newcase, cases{1}, metric);
  typ = mult_factor * cases{1}.typicality;

  for i = 2:n
    current = cases{i};
    if compareCases(current, newcase, metric) > currentDistance
      mult_factor = 1.5*(n + 1 - i) / n;
    end
    typ = typ + (mult_factor * current.typicality);
  end

  maxes = find(typ == max(typ));
  emotion = maxes(randi(size(maxes)));
  c =  createCase([], emotion);
end
