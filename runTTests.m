function [] = runTTests()

  load('data/noisyEmotionF1s.mat');

  tData = zeros(6,3);

  for i = 1:6
    for j = 1:3
      tData(i,j) = ttest2(emotionF1s{i}(:,j), emotionF1s{i}(:,mod(j,3) + 1), 0.10);
    end
  end

  save('data/tTestDataNoisy.mat', 'tData');

end
