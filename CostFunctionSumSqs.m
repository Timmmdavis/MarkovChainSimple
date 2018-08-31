function [Prob,LogProb,SumSqRes]=CostFunctionSumSqs(Pred,Obs,Stnd)
% CostFunctionSumSqs:  Compute the measure of the ability of the model to
%                      explain the data. Many thanks to Ian Murry from
%                      Edinburgh University for helping me with my
%                      questions.
%               
% usage #1:
% [Prob,LogProb,SumSqRes]=CostFunctionSumSqs(Pred,Obs,Stnd)
%
% Arguments: (input)
% Pred       - Vector or matrix of predicted values (from your model)
%
% Obs        - Vector or matrix of observed values (observations)
%
% Stnd       - Some typical standard devation, the resultant probability
%              coming our should be around '-1'
%
% Arguments: (output)
% Prob       - The sum of squares probability 
%
% LogProb    - Is a flag to say if we are using log or just normal probabilty
%
% Stnd       - Scales the results, without this set correctly the
%              acceptance rate becomes trash. 
% 
% Example usage 1:
%
% See test examples
%
%  Author: Tim Davis
%  Copyright 2018, Tim Davis, Potsdam University

%'abs' as we want the surfaces to touch. Any distance between is bad 
Res=abs(Obs-Pred); 
%histogram(Res);

%Sum of squared residuals
SumSqRes=sum(Res(:).^2); % 0 - perfect match

%Log probability:
Prob=-0.5*(SumSqRes)/Stnd^2;
%Set flag
LogProb=1;

