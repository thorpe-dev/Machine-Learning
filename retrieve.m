function [c] = retrieve(cbr, newcase)
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
    max_typ = sum(cases{1}.typicality);
    typ_cases = cell(0);
    typ_cases{1} = cases{1};
    for i = 2:size(cases,2)
      current = cases{i};
      typ = sum(current.typicality);
      if(max_typ == typ)
        typ_cases{end + 1} = current;
      elseif(max_typ < typ)
        max_typ = typ;
        typ_cases = {};
        typ_cases{1} = current;
      end
    end
    typ_cases
    c = typ_cases{randi(size(typ_cases,2))};

  end
end


