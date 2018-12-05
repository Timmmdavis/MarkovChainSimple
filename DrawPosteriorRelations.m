function  DrawPosteriorRelations( Bins,Smooth,BestFit,varargin )
% DrawPosteriorRelations:  Draws the posterior of the data. Shows contours,
%                          scatter plots and the best fit location.
%               
% usage #1:
% DrawPosteriorRelations( Bins,Smooth,BestFit,X,Y )
%
% Arguments: (input)
%
% Bins     - The amount of bins (grid spacing) for the 3d historgram.
%
% Smooth   - Smoothing the contours? Dont set too high. 
%
% BestFit  - Vector of the best fits (will be shown as a green dot)
%
% varargin - Long vectors that are the results of the MCMC. 
%
% Arguments: (output)
% N/A      - A figure will be produced 
% 
% Example usage 1:
%
% X = linspace(0,3*pi,200);
% Y = cos(X) + rand(1,200); 
% Bins=10;
% Smooth=1;
% DrawPosteriorRelations( Bins,Smooth,[2*pi,0.5],X,Y )
%
%  Author: Tim Davis
%  Copyright 2018, Tim Davis, Potsdam University

%Number of input variables 
Nvars=nargin-3; 

Grid=1:(Nvars-1)^2;
Grid=reshape(Grid,[Nvars-1,Nvars-1]);
Grid=Grid';

%Arrays defining what is plotted where
zers=zeros(Nvars-1);
RowGrid=zers;
ColGrid=zers;
for i=1:Nvars-1
    ColGrid(:,i)=i;    
    RowGrid(i,:)=i;
end
%Add one so at no point is there a row col intersection with itself
ColGrid=ColGrid+1;

%Removing bit below diagonal (putting to nan as we dont want to draw this)
A = ones(Nvars-1);
C = tril(A,-1);
ColGrid(logical(C))=nan;
RowGrid(logical(C))=nan;
Grid(logical(C))=nan;


figure; 

for i=1:Nvars-1    
    for j=1:Nvars-1

        %Choose which vars to plot
        idx1=ColGrid(i,j);
        idx2=RowGrid(i,j);

        %skip loop as these are plots we dont draw
        if isnan(idx1) || isnan(idx2)
            continue 
        end  
        
        %Grab out of inputs
        a=varargin{idx1};
        b=varargin{idx2};        
        
        %Choose the correct subplot
        subplot(Nvars-1,Nvars-1,Grid(i,j))
        
        %Draw Plots
        DrawContourPlot(a,b,Bins,Smooth)
        hold on
        scatter(a,b,'k.','MarkerEdgeAlpha',.2)
        scatter(BestFit(idx1),BestFit(idx2),15,'g','filled');
        
        %Draw names:
        if j==Nvars-1
            ax=gca;
            ax.YAxisLocation = 'right';
            s = inputname(i+3); %+3 avoids our extra input args 
            ylabel(s)
        end

        if i==1
            ax=gca;
            ax.XAxisLocation = 'top';
            s = inputname(j+4); %+4 both index offset and input args (see ColGrid indxs)
            xlabel(s)
        end        
            
        
    end

end

%Draw cmap with the imported cmap if its around. 
bones=bone;
colormap(bones(30:end,:));
%if isempty(cmap2); colormap('default'); else; colormap(cmap2); end 

