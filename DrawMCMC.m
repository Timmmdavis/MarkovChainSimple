function  [GraphicContainer]=DrawMCMC( GraphicContainer,varargin )
% DrawMCMC:  Draws the MCMC progressing on the fly (updating multiple
%            scatter plots in loop)
%               
% usage #1:
% [GraphicContainer]=DrawMCMC( GraphicContainer,[X,Y] )
%
% Arguments: (input)
% GraphicContainer      - Structure containing a index of the subplot
%
% varargin              - Data coming in from loop that we want to draw
%                         (vector with the different paramters)
%
% Arguments: (output)
% GraphicContainer      - The structure with index's so in the next loop it
%                         knows which subplot to place the data in
% 
% Example usage 1:
%
% N/A
%
%  Author: Tim Davis
%  Copyright 2018, Tim Davis, Potsdam University

% Could be sped up by taking these variables we recreate each loop outside
% of the function....

%Number of input variables 
Nvars=numel(varargin); 

%Set up matrix
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
        
        %Get the correct plot:
        GraphicContainer.num2str(Grid(i,j))=subplot(Nvars-1,Nvars-1,Grid(i,j));
        hold on
        scatter(a,b,'k.','MarkerEdgeAlpha',.2)
       
        %Draw in each loop
        drawnow
        
    end

end

