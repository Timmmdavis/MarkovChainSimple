clear
close all
cmap2 = colormap_cpt('Ccool-warm2');


%% Load data (resurgent dome at Campi flegri).
% This is example inverts for deformation of a resurgent dome in the campi
% flegri caldera. Its assumes that the material is elastic (infinitesimal
% deformation), the defromation source is a flat penny shaped crack and
% points only moved in 'z'. Most of these assumptions are invalid in some
% sense but it gives a nice example of how the method works. 

% We use root mean square error as our proxy for the probability of the
% result being correct.
global X Y Z E nu
load('TestExample2Data.mat')

%Moving our 'dome' so the base is at the ground surface. 
MnZ=min(Z);
Z=(Z-MnZ);


%% Bounds: 5 things we are inverting for:
Xbnds=[min(X),max(X)];
Ybnds=[min(Y),max(Y)];
Hbnds=[10,8000];
Rbnds=[10,4000];
Pbnds=[1E5,1E10];

%Extra parameters our shell function needs to pass to our real objective
%function:
nu = 0.25;              %Poisson's ratio, Nu or V. Rubber 0.5, Cork 0, Rock 0.1-0.3;
E=5.12E9;           	%Shear Mod, mu or G. Relates shear stress to shear strain. 

Loops=5000;
%The function we inspect (external .m file) 
ObjFuncPointer = @TestExample2ObjFunc;
%The function we use to evaluate the probability (external .m file) 
CostFuncPointer = @CostFunctionSumSqs;

draw=0;
[ BestFit,East,Nrth,Height,Radius,Pressure ] = MetropolisHastingsAlgorithm( ObjFuncPointer,CostFuncPointer,Loops,[],draw,Xbnds,Ybnds,Hbnds,Rbnds,Pbnds );


%% Draw figs
Bins=20;
Smooth=1;
DrawPosteriorRelations( Bins,Smooth,BestFit,East,Nrth,Height,Radius,Pressure  )

%% Draw best fit:
XPnts=X-BestFit(1);
YPnts=Y-BestFit(2);
PntsR=sqrt(XPnts.^2+YPnts.^2);

    %SUN69(R,H,A,P,E,nu)
    %		  R: radial distance of observation,
    %		  H: depth of the center of the source from the surface,
    %		  A: radius of the source with the hydrostatic pressure,
    %		  P: change of the hydrostatic pressure in the crack.
    %		  E: Young's modulus,
    %		 nu: Poisson's ratio (default is 0.25 for isotropic medium).
[ur,uz]=sun69(PntsR,BestFit(3),BestFit(4),BestFit(5),E,nu);

figure
scatter3(X,Y,uz);
hold on
scatter3(X,Y,Z,15,'g');
WhiteFigure
title('Best fit surface')

figure
subplot(2,1,1);
scatter(X,Y,15,uz);
WhiteFigure;title('model');caxis([0,150])

subplot(2,1,2);
scatter(X,Y,15,Z);
colormap(cmap2);
WhiteFigure;title('data');caxis([0,150])