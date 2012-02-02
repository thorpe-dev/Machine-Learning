function [tree] = decisionTreeLearning(examples, attributes, targets)

if same_label(targets)
    tree.op = [];
    tree.kids = [];
    tree.class = targets(1,1);
    return
end

if attributes == []
    tree.op = [];
    tree.kids = [];
    tree.class = majorityValue(targets);
    return
end

% attributesLeft needs to be cut down to only those with 1 left in
% attributes
bestAttr = chooseAttribute(examples, attributesLeft, targets)
tree.op = bestAttr;
tree.class = [];

% 0 branch %

% examplesi, targetsi = filter out all examples which bestAttr = 0 and their
% associated target

if examplesi == [] % does this block make sense? %
    tree.op = [];
    tree.kids = [];
    tree.class = majorityValue(targets);
    return
end

newAttr = attributes;
newAttr(bestAttr) = 0;
tree.kids(1) = decisionTreeLearning(examplesi, newAttr, targetsi);

% 1 branch %

% examplesi, targetsi = filter out all examples which bestAttr = 1 and their
% associated target

if examplesi == [] % does this block make sense? %
    tree.op = [];
    tree.kids = [];
    tree.class = majorityValue(targets);
    return
end

newAttr = attributes;
newAttr(bestAttr) = 0;
tree.kids(2) = decisionTreeLearning(examplesi, newAttr, targetsi);

return

end
