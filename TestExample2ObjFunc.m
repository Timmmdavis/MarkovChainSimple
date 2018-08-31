function [ pred,obs,error ] = TestExample2ObjFunc( RandomParams )
%TestExample2ObjFunc: Example of a shell function that calls the main function
%while setting the non random paramters and manipulating the random
%parameters before passing these to the proper function. In this case a
%function computing ground deformation due a pressurised penny in a half
%space. 

%East=Centre of penny in E coords
East=RandomParams(1);
%Nrth=Centre of penny in N coords
Nrth=RandomParams(2);
%Height=Depth to penny from ground surface
Height=RandomParams(3);
%Radius=Radius of the penny 
Radius=RandomParams(4);
%Pressure=Pressure inside crack
Pressure=RandomParams(5);

%Load global vars that define the location of points etc. Could load easily
%here but that would be slower if looping on this shell func. 
global X Y Z E nu

%Calculate radial distance from source
XPnts=X-East;
YPnts=Y-Nrth;
RadialDist=sqrt(XPnts.^2+YPnts.^2);

%Call function that computes ground deformation due to pressurised penny
[ur,uz]=sun69(RadialDist,Height,Radius,Pressure,E,nu);

%Compute the residuals. 
res=abs(Z-uz);
pred=uz;
obs=Z;

%Some standard deviation s that gives the typical size of a "reasonable
%residual". Without the results will scale badly. 
error=1000;


end

