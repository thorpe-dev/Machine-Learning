function [ best ] = chooseAttribute(attributes, examples, targets)
    % attributes is a set of remaining attributes
    % examples a matrix, rows of examples, columns of set attributes
    % targets rows of examples true or false
    max_gain = -1;
    best = -1;
    for a = attributes
        attribute = examples(:,a);
        gain = Gain(attribute, targets);
        if gain >= max_gain
           max_gain = gain;
           best = a;
        end
    end
end

function [entropy] = I(pos, neg)
    count = pos + neg + eps;
    p = pos / count;
    n = neg / count;

    entropy = -p * log2(p+eps) - n * log2(n+eps);
end

function [remainder] = Remainder(attribute, targets)
    % attribute is the attribute column
    posPos = sum(attribute & targets);
    posNeg = sum(attribute & ~targets);
    negPos = sum(~attribute & targets);
    negNeg = sum(~attribute & ~targets);
    
    positivecount = posPos + posNeg;
    negativecount = negPos + negNeg;
    
    positive = positivecount / size(targets) * I(posPos / positivecount, posNeg / positivecount);
           
    negative = negativecount / size(targets) * I(negPos / negativecount, negNeg / negativecount);
        
    remainder = positive + negative;
end

function [gain] = Gain(attribute, targets)
    positive = sum(targets) / length(targets);
    negative = 1.0 - positive;
    gain = I(positive, negative) - Remainder(attribute, targets);
end
