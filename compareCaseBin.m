function [x] = compareCaseBin(case1, case2)

  c1 = zeros(1,45);
  c2 = zeros(1,45);
  c1(case1.problem) = 1;
  c2(case2.problem) = 2;

  diff = c1 - c2;

  for i = 1:45
    x = diff(i);
    if ~x
      break;
    end
  end
end
