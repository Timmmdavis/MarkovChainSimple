function PlotAutoCorrelation( lags,varargin )
%Plots a graph of the auto correlation for each static variable. 

% ACF code taken from: MATLAB file exchange: 
% Autocorrelation Function (ACF)
% version 1.0.0.0 (2.01 KB) by Calvin Price

%Should drop down towards 0 when chains are mixing well.  

%Init figure:
figure; hold on
title('Auto Correlation');hold on


%Number of input variables 
Nvars=nargin-1;
strVarName= cell(1,Nvars);

for i=1:Nvars

    y=varargin{i};
    %Remove nans
    y=y(~isnan(y));
    
    p=lags;
    
    %% Computing auto correlation
    %Init some vars
    ta = zeros(p,1) ;
    N = max(size(y)) ;
    ybar = mean(y); 

    % Collect ACFs at each lag i
    for k = 1:p
       ta(k) = acf_k(y,k,ybar,N) ; 
    end

    %% Drawing the results
    %scatter(1:lags,ta,'filled');
    plot(1:lags,ta,'-o');
    
    %Create legend:
    strVarName{i} = inputname(i+1);

end

%Add line at 0
plot([0,lags],[0,0],'--k');

%Create legend
legend(strVarName)

% ---------------
% SUB FUNCTION
% ---------------
function ta2 = acf_k(y,k,ybar,N)
% ACF_K - Autocorrelation at Lag k
% acf(y,k)
%
% Inputs:
% y - series to compute acf for
% k - which lag to compute acf
% 
cross_sum = zeros(N-k,1) ;

% Numerator, unscaled covariance
for l = (k+1):N
    cross_sum(l) = (y(l)-ybar)*(y(l-k)-ybar) ;
end

% Denominator, unscaled variance
yvar = (y-ybar)'*(y-ybar) ;

ta2 = sum(cross_sum) / yvar ;


end
end
