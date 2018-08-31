function [ BestSol,varargout ] = MetropolisHastingsAlgorithm( ObjFuncPointer...
    ,CostFuncPointer,Loops,SaveAppend,display,varargin )
% MetropolisHastingsAlgorithm:  Runs a very simple example of the
% MetropolisHastingsAlgorithm. For more info see: 
% http://helper.ipam.ucla.edu/publications/gss2012/gss2012_10791.pdf 
%               
% usage #1:
% [ BestSol,varargout ] = MetropolisHastingsAlgorithm( ObjFuncPointer...
%    ,CostFuncPointer,Loops,SaveAppend,display,varargin )
%
% Arguments: (input)
% ObjFuncPointer        - Pointer to the objective function that we
%                         evalulate. This can be a shell with subfunctions
%                         in if needed. We pass a vector into this (single
%                         argument) where each part of the vector is the
%                         random variables for that loop (passed in the
%                         same order as 'varargin' of this function.
%                         Pointer is defined in a line such as "ObjFunc =
%                         @ShellFunction;".
%
% CostFuncPointer       - Pointer to the cost function that we evalulate. 
%
% Loops                 - The amount of loops the algorithm performs.
%
% SaveAppend            - We save a file called 'BackUpArray[n]' where n is
%                         the number defined with this variable. If empty
%                         i.e. [] the script runs faster but you may loose
%                         a long run if it throws an error...
%
% display               - a flag, set to 1 if you want visually see the
%                         progress.
%
% varargin              - The random variables we are evalulating in our
%                         objective function. Supply as two element vectors
%                         that are the bounds you want to evaluate. The
%                         function may go outside the bounds unless this is
%                         set later on (but its unlikely too).
%
% Arguments: (output)
% BestSol               - Vector containing the best solutions seen in the
%                         loop. Same order as the inputs in 'varargin' of
%                         this function. Best being the smallest cost
%                         function value. 
%
% varargout             - Call as the input varargin. This is long chains
%                         (vectors) where each row represents the values
%                         from each iteration of the loop.
% 
% Example usage 1:
%
% See test examples
%
%  Author: Tim Davis
%  Copyright 2018, Tim Davis, Potsdam University

%If you want to see the input names:
%s=inputname(1);

%Number of input variables 
Nvars=nargin-5;

%Init vars for loop, cols the size of the number of vars and rows the size
%of our loop. 
XDistribution=nan(Loops,Nvars);

%% Set Prior distribution. 
%Here we use a uniform distribution for each var between its min and max extents: 
Sample=round(Loops/6);  % size of starting distribution in the array. 
BurnIn=round(Loops/3);
%Fill our distribution with this up the the length sample. 
XDistribution(1:Sample,1:Nvars)=rand(Sample,Nvars);
%Now scale this accordingly so it fits the data extents
for i=1:Nvars
    XDistribution(1:Sample,i)=(XDistribution(1:Sample,i)*range(varargin{i}))+min(varargin{i});
end

%Start value for reject criteria
Mi=0;
BestSol=inf(1,Nvars+1);
%Set up probabilities
Prob=nan(Loops,1);
Prob(1:Sample,:)=0;

%Create some empty arrays
RandomParams=zeros(Nvars,1);

%Set step sizes based on ranges:
NoSteps=10; %Higher means that jumps will be less
Stepsizes=nan(1,Nvars);
for i=1:Nvars
    Stepsizes(:,i)=range(varargin{i})/NoSteps;
end

AreWeSaving=~isempty(SaveAppend);
if AreWeSaving
    %% Saving paramter during loop
    %Setting up saving stuff (if loop crashes data is still there). 
    %Create a Version 7.3 MAT-file with variables 'models' 'logP'.
    filename=strcat('BackUpArray',num2str(SaveAppend));
    save(filename,'XDistribution','-v7.3')
    %Construct a MatFile object from the MAT-file, example.mat.
    BackUpArrayObject = matfile(filename);
    %Object is there and we set Properties.Writable so its Writable 
    BackUpArrayObject.Properties.Writable = true;
end

%% Drawing progress
if display==1
    figure; 
    hold on
    GraphicContainer=struct ;
    GraphicContainer=DrawMCMC( GraphicContainer, varargin{1:Nvars} );
end

acceptrate = 0;

%% Start Loop
for i=Sample:Loops

    skiplp=0;
    
    %% Choose random parameter from normal distribution of each var:    
    for j=1:Nvars
        
        %Create a random distribution with its mean at the last point its
        %standard devation our set step size.
        RandomParams(j)= (randn(1)*Stepsizes(j))+XDistribution(i-1,j);
        
        %Turn on line belowif you want to skip loop iteration when data is out of bounds...
        if RandomParams(j)>max(varargin{j}) || RandomParams(j)<min(varargin{j})
            skiplp=skiplp+1;
        end        
    end

    if skiplp>0
        %Set to last distribution and restart loop
        XDistribution(i,:)=XDistribution(i-1,:);
        continue
    end

    %% Evalulate the objective function:
    %to retrive the observations and predictions. Typically the
    %observations are preloaded as globalvars.
    
    %Parameters not randomised should be inside function (or a shell) and
    %the parameters passed into this function should be the same order as
    %those passed into THIS function in the varargin arguments
    [ Pred,Obs,Error ]=ObjFuncPointer(RandomParams);

    
    %Now check how good the fit is within our cost function
    [CostFunc,LogProb,SumSqRes]=CostFuncPointer(Pred,Obs,Error);
    
    %Reassign var
    Mstr=CostFunc;
    
    %% Now accept or reject    
    %random number generated from a uniform distribution on the interval [0, 1].
    Wstr=rand;    
        
    %Change acceptance criterion based on if we are in log or not log
    %probability space
    if LogProb 
        A=(Mstr-Mi);
        Wstr=log(Wstr);
    else       %using normal prob dist
        A=(Mstr/Mi);
    end
        
    %USING 's' make sure the original Mstr is close to -1; 
    AcceptanceRatio= A > Wstr;
    
    %Accept or not
    if AcceptanceRatio
        

        
        if SumSqRes<BestSol(1)
            %Grab best solution is Mstr is bigger than the current best
            BestSol=[SumSqRes;RandomParams];
        end

        %Update the function        
        Mi=Mstr;
        
        %Accept the candidate by setting xt + 1 = x'
        XDistribution(i,:)=RandomParams;
        
        acceptrate = acceptrate + 1;
        
        if display==1
            C = num2cell(RandomParams);
            GraphicContainer=DrawMCMC( GraphicContainer,C{1:Nvars} );
        end
        
    %reject
    else

        %Skip this one
        if i==1
            continue
        end
        
        %Reject the candidate and set xt + 1 = xt, instead.
        XDistribution(i,:)=XDistribution(i-1,:);        
        
    end
    
    %Update List of Probabilities
    Prob(i)=Mi;            
    
    %% Extras: 
   
    if AreWeSaving
        %Save stuff: save to file incrementally. Turn off to speed up!
        BackUpArrayObject.XDistribution(i,:)=XDistribution(i,:);
    end
    
    %progress. Very simple, counts up to 1. 
    i/Loops
end

disp('Acceptance rate:')
disp(acceptrate/Loops)

%Remove burn in
XDistribution(1:BurnIn,:)=nan;     
BackUpArrayObject.XDistribution(1:BurnIn,:)=nan;

%Thin chain:
TakeEveryNth=2; 
XDistribution=XDistribution(1:TakeEveryNth:end,:);

%Remove objective function values from the front of the best solution (we just want
%it like the inputs a col vector list).
BestSol=BestSol(2:end);

for j=1:Nvars
    varargout{j} = XDistribution(:,j);
end

end

