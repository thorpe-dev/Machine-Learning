function [ label ] = majorityValue( targets )
    % if no majority return 1
    if sum(targets) <= size(targets) / 2
        label = 1;
    else
        label = 0;
    end
end

