function [Pred,Obs,err]=TestExample1ObjFunc(Inp)

%Global Data (Real topography)
%This is a XYZ of points on a grid
global xgrd ygrd zgrd

%Current points in min func
ReX=Inp(2);
ReY=Inp(1);

%Calculate the index of the closest X and Y to the current location
[~,ind_y]=min(abs(xgrd(1,:)-ReX)); 
[~,ind_x]=min(abs(ygrd(:,1)-ReY)); 

%Z value at this index
Pred=zgrd(ind_x,ind_y);

% %Expected low (data):
Obs=0;

err=0;


