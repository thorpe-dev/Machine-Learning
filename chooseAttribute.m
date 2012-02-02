function [ best ] = chooseAttribute( attributes, examples, targets )
    % attributes is a set of remaining attributes
    % examples a matrix, rows of examples, columns of set attributes
    % targets rows of examples true or false
    max_gain = 0;
    best = 0;
    for a = attributes
        attribute = examples(:,a);
        gain = Gain(attribute, targets);
        if gain >= max_gain
           max_gain = gain;
           best = attribute;
        end
    end  
    
end

function [entropy] = I(pos, neg)
    assert(pos + neg > 0.99 && pos + neg < 1.01);
    entropy = -pos * log2(pos) - neg * log2(pos);
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
    positive = sum(targets) / size(targets);
    negative = 1.0 - positive;
    gain = I(positive, negative) - Remainder(attribute, targets);
end