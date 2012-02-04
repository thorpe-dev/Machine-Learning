function [tree] = decisionTreeLearning(examples, attributes, targets)

    if same_label(targets)
        tree.op = [];
        tree.kids = [];
        tree.class = targets(1,1);
        return
    else if attributes == []
        tree.op = [];
        tree.kids = [];
        tree.class = majorityValue(targets);
        return
    else
        % DONE attributesLeft needs to be cut down to only those with 1 left in
        % DONE attributes
        attributesLeft = [];
        for a = attributes
            if a != 0
                attributesLeft(end + 1) = a;
            end
        end

        bestAttr = chooseAttribute(examples, attributesLeft, targets)
        tree.op = bestAttr;
        tree.class = [];

        for i = 0:1
            % DONE examples_i, targets_i = filter out all examples which bestAttr = i and their
            % DONE associated target
            examples_i = [];
            targets_i = [];
            n = length(examples);
            for j = 0:n
                k = n - i;
                if examples(k, bestAttribute) == i
                    examples_i(end + 1) = examples(k, :);
                    examples(k,:) = [];
                    targets_i(end + 1) = targets(k, :);
                    targets(k, :) = [];
                end
            end

            if examples_i == [] % does this block make sense? %
                tree.op = [];
                tree.kids = [];
                tree.class = majorityValue(targets);
                return
            else
                newAttr = attributes;
                newAttr(bestAttr) = 0;
                tree.kids(i + 1) = decisionTreeLearning(examples_i, newAttr, targets_i);
            end
        end
        return 
    end
end
