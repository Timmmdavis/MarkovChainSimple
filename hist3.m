function [allN,edgesX,edgesY] = hist3(x,y,bins)
%hist3.m	Jonathan C. Lansey	2015	
%https://uk.mathworks.com/matlabcentral/fileexchange/45325-efficient-2d-histogram-no-toolboxes-needed

% 2D histogram which is actually kind of fast making use of matlab's histc

    %Get the axis lims
    temp = [max(x)-min(x), max(y)-min(y)]*[-1 1 0 0 ; 0 0 -1 1]*.05;
    axisXY = [min(x) max(x) min(y) max(y)]+temp; % do some padding with one matrix equation woo!

    % finally set the bins
    edgesX=axisXY(1):((axisXY(2)-axisXY(1))/bins):axisXY(2);
    edgesY=axisXY(3):((axisXY(4)-axisXY(3))/bins):axisXY(4);


    allN = zeros(length(edgesY),length(edgesX));
    [~,binX] = histc(x,edgesX);
    for ii=1:length(edgesX)
        I = (binX==ii);
        N = histc(y(I),edgesY);
        allN(:,ii) = N';
    end
end % BAM how small is this function? sweet peas!