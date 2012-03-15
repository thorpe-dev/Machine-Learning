function [] = runMCTests()

load('data/anovaStatsNoisy.mat');

mcData = cell(1,6);

for i = 1:6
   
    mcData{i} = multcompare(anovaStats{i}{3});
    
end

save('data/mcDataNoisy.mat', 'mcData');

end

