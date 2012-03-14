function [emotionF1s] = transformF1Data(f1Data)

% Transforms the data into sets per emotion instead of per algorithm

emotionF1s = cell(0);
thisEmotion = zeros(10,3);

for i = 1:6
  for j = 1:3
    thisEmotion(:,j) = f1Data{j}(:,i);
  end
  emotionF1s{i} = thisEmotion;
end
