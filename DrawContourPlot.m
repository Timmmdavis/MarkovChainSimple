function DrawContourPlot(X,Y,Bins,Smooth )
% DrawContourPlot:  Draws a contour plot of the data
%               
% usage #1:
% DrawContourPlot(X,Y,Bins,Smooth )
%
% Arguments: (input)
% X        - Datas X values
%
% Y        - Datas Y values
%
% Bins     - The amount of bins (grid spacing) for the 3d historgram.
%
% Smooth   - Smoothing the contours? Dont set too high. 
%
% Arguments: (output)
% N/A      - A figure will be produced (or add to figure with 'hold on')
% 
% Example usage 1:
%
% X = linspace(0,3*pi,200);
% Y = cos(X) + rand(1,200); 
% Bins=10;
% Smooth=1;
% DrawContourPlot(X,Y,Bins,Smooth )
% hold on;scatter(X,Y,'.k');
%
%  Author: Tim Davis
%  Copyright 2018, Tim Davis, Potsdam University

[n,c1,c2] = hist3(Y,X,Bins);

%Smoothing
n = smooth2a(n,Smooth);
%Contour
contourf(c2,c1,n')

end

