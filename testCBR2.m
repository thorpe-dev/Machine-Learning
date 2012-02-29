function [y] = testCBR2(cbr, x)

    y = zeros(size(x,1), 1);

    for i = 1:size(x,1)
        AUs = find(x(i,:) == 1)
        [newcase] = createNovelCase(AUs);
        [cases] = retrieveCases(cbr, newcase);
        typ = zeros(1,6);

        for c = 1:size(cases)
          typ = typ + cases{c}.typicality;
        end
        maxes = find(typ == max(typ));
        y(i) = maxes(randi(size(maxes)));
    end


end
