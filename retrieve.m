function [c] = retrieve(cbr, newcase)
  cases = cell(0);
  if(size(cbr) > 0)
    cases{1} = cbr{1};
    min_distance = calculateDistance(cbr{1}, newcase);

    for i = 2:size(cbr,2)
      current = cbr{i};
      dist = calculateDistance(current, newcase);
      if(min_distance == dist)
        cases{end + 1} = current;
      elseif(dist < min_distance)
        min_distance = dist
        cases = {}
        cases{1} = current;
      end
    end

    c = cases{randi(size(cases,2))};

  end

end


function [dist] = calculateDistance(c1, c2)

  x1 = zeros(1,45);
  x2 = zeros(1,45);
  c11 = c1.problem
  c21 = c2.problem
  x1(c1.problem) = 1;
  x2(c2.problem) = 1;

  dist = sum(abs(x1 - x2))

end

