function [Prob,LogProb,Hgh]=TestExample1CostFunction(Pred,Obs,Error)
%% Inputs:
%obs is a vector of the observations. 
%pred is a vector of the predicted data. 

%% Output:
% Prob is a 'probability'
% LogProb is a flag to say if we are using log or just normal probabilty
% function

%% Calc fit
Prob=abs(Obs-Pred); %'Abs' as we want the surfaces to touch. Any distance between is bad 

LogProb=0;

%Finding high point
Hgh=-Pred;

