function [output] = remap(examples, emotion)
    output = arrayfun(@(x) map(x, emotion), examples);
end

function [result] = map(example, emotion)
    if example == emotion
        result = 1;
    else
        result = 0;
    end
end