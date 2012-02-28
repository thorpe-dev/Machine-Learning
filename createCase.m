function [newCase] = createCase(AUs, emotion)
% Given a vector of AUs and an emotion number (1-6),
% return a case structure

newCase.problem = AUs;
newCase.solution = emotion;
newCase.typicality = 1;

end