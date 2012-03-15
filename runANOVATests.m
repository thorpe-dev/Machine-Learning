function [] = runANOVATests()

load('data/noisyEmotionF1s');

anovaStats = cell(1,6);

for i = 1:6
    anova = cell(1,3);
    [anova{1:3}] = anova1(emotionF1sNoisy{i});
    anovaStats{i} = anova;
end

save('data/anovaStatsNoisy.mat', 'anovaStats');

end

