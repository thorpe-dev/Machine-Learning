function [y] = testCBR2(cbr, x, k, metric)

    y = zeros(size(x,1), 1);

    for i = 1:size(x,1)
        AUs = find(x(i,:) == 1);
        [newcase] = createNovelCase(AUs);
        [cases] = retrieveCases(cbr, newcase, k, metric);
        typ = zeros(1,6);

        for c = 1:size(cases, 2)
          typ = typ + cases{c}.typicality;
        end
        typ
        maxes = find(typ == max(typ));
        y(i) = maxes(randi(size(maxes)));
    end


end
