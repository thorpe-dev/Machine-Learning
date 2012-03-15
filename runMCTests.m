function [] = runMCTests()

load('data/anovaStats.mat');

mcData = cell(1,6);

for i = 1:6
   
    mcData{i} = multcompare(anovaStats{i}{3});
    
end

save('data/mcData.mat', 'mcData');

end

