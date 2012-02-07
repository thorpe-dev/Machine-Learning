function [] = runner()

    [examples, targets] = loaddata('cleandata_students.txt');
    confMat = buildTotalConfusionMatrix(examples, targets)
end
