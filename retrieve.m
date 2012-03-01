function [c] = retrieve(cbr, newcase, k)

  cases = retrieveCases(cbr, newcase, k);

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
  c = typ_cases{randi(size(typ_cases,2))};

end
