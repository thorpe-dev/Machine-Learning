function [] = runTTests()

load('data/noisyEmotionF1s.mat');

tData = zeros(6,3);

for i = 1:6
   for j = 1:3
     tData(i,j) = ttest2(emotionF1sNoisy{i}(:,j), emotionF1sNoisy{i}(:,mod(j,3) + 1), 0.05);
   end
end

save('data/tTestDataNoisy.mat', 'tData');

end

