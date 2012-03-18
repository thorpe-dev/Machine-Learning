function [] = runStats()
  [f1s] = extractF1Data;
  [emotionF1s] = transformF1Data(f1s);
  save('data/noisyEmotionF1s.mat', 'emotionF1s');
  save('data/noisyf1Data.mat', 'f1s');
  runANOVATests;
  runTTests;
  runMCTests;
end

