function [emotionF1s] = transformF1Data(f1Data)

% Transforms the data into sets per emotion instead of per algorithm

emotionF1s = cell(0);
thisEmotion = zeros(size(f1Data{1}, 1), 3);

for i = 1:6
  for j = 1:size(f1Data{1}, 1)
    for k = 1:3
      thisEmotion(j,k) = f1Data{k}(j,i);
    end
  end
  emotionF1s{i} = thisEmotion;
end
