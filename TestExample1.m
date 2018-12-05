clear
close all
cmap2 = colormap_cpt('Ccool-warm2');


%% Load data (real world topography data of arran island on a grid).
% This is a really simple example to give an idea how the MCMC works. We
% simple check topography values on a grid and see the height of that point
% using this as the 'probability'. 

%  Set as global for speed (instead of loading in each loop). 
global xgrd ygrd zgrd
load TestExample1Grid.mat

%Normalise
xgrd=(xgrd-min(xgrd(:)));
xgrd=xgrd./max(xgrd(:));

ygrd=(ygrd-min(ygrd(:)));
ygrd=ygrd./max(ygrd(:));

zgrd=(zgrd-min(zgrd(:)));
zgrd=zgrd./max(zgrd(:));


%% Bounds: 2 things we are inverting for:
XBnd=[min(xgrd(:)),max(xgrd(:))]; 
YBnd=[min(ygrd(:)),max(ygrd(:))];

Loops=2500;
%The function we inspect (external .m file) 
ObjFuncPointer = @TestExample1ObjFunc;
%The function we use to evaluate the probability (external .m file) 
CostFuncPointer = @TestExample1CostFunc;


%% Start Algorithm
draw=1; 
[ BestFit,Nrth,East ] = MetropolisHastingsAlgorithm( ObjFuncPointer,CostFuncPointer,Loops,[],draw,YBnd,XBnd );
%2nd chain if wanted:
%[ BestFit2,Nrth2,East2 ] = MetropolisHastingsAlgorithm( ObjFuncPointer,CostFuncPointer,Loops,2,YBnd,XBnd );


%% Draw best fit from the MCMC on actual grid:
h1=figure;
ax1=gca;
contourf(xgrd,ygrd,zgrd,5);
colormap(flipud(gray));colorbar;
axis('equal')
hold on
scatter(BestFit(2),BestFit(1),15,'g','filled');


%% Draw figs
%Plot autocorrelation:
lags=50;
PlotAutoCorrelation( lags,Nrth,East )

% %If you have multiple runs compare trace plots:
% figure;
% hold on
% plot(1:numel(Nrth),Nrth);
% plot(1:numel(Nrth2),Nrth2);
% hold off

%Plot result (densities)
Bins=40; %70
Smooth=2;
DrawPosteriorRelations( Bins,Smooth,BestFit,Nrth,East )
axis('equal');%view([90 -90]) %Flip so upright


