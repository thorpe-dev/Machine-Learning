function [tree] = decisionTreeLearning(examples, attributes, targets)

    if same_label(targets)
        tree.op = [];
        tree.kids = cell(0);
        tree.class = targets(1,1);
    elseif isequal(attributes, [])
        tree.op = [];
        tree.kids = cell(0);
        tree.class = majorityValue(targets);
    else
        attributesLeft = [];
        for a = attributes
            if a ~= 0
                attributesLeft(end + 1) = a;
            end
        end

        bestAttr = chooseAttribute(examples, attributesLeft, targets);
        tree.op = bestAttr;
        tree.kids = cell(0);
        for i = 0:1
            examples_i = [];
            targets_i = [];
            n = size(examples, 1);
            for j = 0:(n-1)
                k = n - j;
                if examples(k, bestAttr) == i
                    examples_i(end + 1, :) = examples(k, :);
                    examples(k,:) = [];
                    targets_i(end + 1, :) = targets(k, :);
                    targets(k, :) = [];
                end
            end

            if isequal(examples_i, [])
                tree.op = [];
                tree.kids = cell(0);
                tree.class = majorityValue(targets);
                return
            else
                newAttr = attributes;
                newAttr(bestAttr) = 0; 
                tree.kids{i + 1} = decisionTreeLearning(examples_i, newAttr, targets_i);
                tree.class = [];
            end
        end
    end
end


function [r] = same_label(targets)
  % Current implementation only works when targets are either 0 or 1
  % If this changes then the implementation will have to change
  r = ((length(targets)*targets(1)) == sum(targets));
end
