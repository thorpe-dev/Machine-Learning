function [newCase] = createCase(AUs, emotion)
% Given a vector of AUs and an emotion number (1-6),
% return a case structure

    newCase.problem = AUs;
    t = zeros(1,6);
    t(emotion) = 1;
    newCase.typicality = t;

end