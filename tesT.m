function [count] = tesT()
count = 100;
  [x,y] = loaddata('cleandata_students.txt');
  for i = 1:100
    for j = (i+1):100
      if sum(abs(x(i,:) - x(j,:))) == 0
        count = count - 1;
        break;
      end
    end
  end
end

