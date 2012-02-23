function drawCoolGraph(emo)

name = strcat('testLayers', num2str(emo), '_');

name1 = strcat(name, '1');

name2 = strcat(name, '2');

load(name1);

r = results;

load(name2)

r = r + results;

r = r/2;

surfc((1:8),(1:45), r');