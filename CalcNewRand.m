function [ R ] = CalcNewRand( A )
%CalcNewRand Calculate new random number from chain of numbers in our
%Metropolis sequence. 

%Standard deviation (ignoring nans)
StanDev = std(A,'omitnan');
%Mean (ignoring nans)
Mean=nanmean(A);

%Calculate new random number from distribution. (more likley to be
%close to last point due to normal distribution). 
R= (randn(1)*(StanDev)) + Mean;


end

