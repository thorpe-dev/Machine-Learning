function [y] = testCBR(CBR, x)

    y = zeros(size(x,1), 1);

    for i = 1:size(x,1)

        AUs = find(x(i,:) == 1);
        [newcase] = createNovelCase(AUs);
        [bestcase] = retrieve(CBR, newcase, 1);
        [solvedcase] = reuse(bestcase, newcase);
        [CBR] = retain(CBR, solvedcase);
        y(i) = find(solvedcase.typicality == 1);

    end

end
