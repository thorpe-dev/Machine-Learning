function [newCase] = createNovelCase(AUs)
% Given a vector of AUs and returns a case structure

    newCase.problem = AUs;
    newCase.typicality = zeros(1,6);

end