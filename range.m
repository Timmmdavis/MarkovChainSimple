function [ r ] = range( V )
%range: Finds the range of the data in variable V

mnV=min(V);
mxV=max(V);
r=mxV-mnV;

end

