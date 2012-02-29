function [cases] = retrieveCases(cbr, newcase);

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
end
