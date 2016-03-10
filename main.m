clear
clc
global mass
mass=input(['Please indicate the product and mass analysed, ex:' ...
        '\n\n              Starch_800mg\n>'],'s');
%% Reading of files
% Recognition of the operative system

if(ispc)
    folder='txt files new\';
    %files=ls(folder);
elseif(isunix)
    javadir=[matlabroot '/java/jar/poi_library'];
    javaaddpath([javadir '/poi-3.8-20120326.jar']);
    javaaddpath([javadir '/poi-ooxml-3.8-20120326.jar']);
    javaaddpath([javadir '/poi-ooxml-schemas-3.8-20120326.jar']);
    javaaddpath([javadir '/xmlbeans-2.3.0.jar']);
    javaaddpath([javadir '/dom4j-1.6.1.jar']);
    javaaddpath([javadir '/stax-api-1.0.1.jar']);
    folder='txt files new/';    
else
    folder='Unknown operative system';
end

fprintf('Loading velocity fields data from txt files folder... ')
files=struct2cell(dir(folder));
files=files(1,3:size(files,2))';
A=cell(size(files,1) ,4);
time=zeros(size(files,1),1);
n=size(files,1);
for i=1:size(files,1)
   t=cell2mat(strrep(files(i,:),'.txt', ''));
   t=regexp(t, '-', 'split');
   A{i,1}=cell2mat(files(i,:));
   A{i,2}=t{1};
   A{i,3}=t{2};
   A{i,4}=t{3};
   time(i)=str2double(A{i,4});
   
end

fprintf('Done\n')   
% Analysis of PIV data
fprintf('Analysing velocity fields... ')
[time j]=sort(time);
graph=false;
saveGraph=true;
for i=1:n
    [X(:,i) Y(:,i) U(:,i) V(:,i) v(:,i)]=analysePIV(folder, ...
        cell2mat(files(j(i))), time(i),0:0.025:3,graph,saveGraph);
end
fprintf('Done\n')
%% Regresion of the vertical field
plotData='vu';
safePlot=false;
gridIt=[1 1];

% Regresion of data
global param
param.Solid.rho=2500; %particule density 2500 glass / 490 Starch
param.Solid.D=86e-6; %particle diameter mean([83 90])*1-6 86e-6 glass 25e-6 Starch
param.g=9.81; %gravity
param.Cd=1.5; %friction coefficient for particle and air
param.R=8.314; %ideal gas constant
param.Va=50e-6; %Volume of gas reservoir
param.Atube=pi*(3.23E-3/2).^2; %3.23E-3
param.Afinal=7e-2^2;
param.Air.rho=1.14; %air density
param.Air.Cp=29; %air heat capacity
param.Air.T0=298; %initial air temprature
param.Air.P0=8e5; %initial air pressure
param.Air.Pf=1e5; %final air pressure
param.Air.M=29E-3; %molar weight
param.Air.mu=1.9E-5; %Dynamic viscosity Pa*s

matrixV=getGridedField(X,Y, U,V,time, gridIt);
fprintf('Getting mean values for velocities... ');
[Umean,Vmean,Weight]=getVelocityMean(matrixV, time, 'uv', 'all');
fprintf('Done\n\n');
fprintf('Doing regression of data for vertical Velocity\n\n')
[matrixV,MK,rsquare]=fitAllVmeans(matrixV,time,plotData, safePlot );
%% Save relevant data in xls
folder='Results';
filename='starch.xlsx';
sheetname=mass;
data=extractMatrixData(matrixV,true);
if(ispc)
    
    folder=[folder '\'];
    xlswrite([folder filename],data,sheetname);
elseif(isunix)
    folder=[folder '/'];
    xlwrite([folder filename],data,sheetname);
end

fprintf('\nThe file has been saved\n\n')

%% Complete analysis for horizontal velocity
plotU=false; 
safePlot=false;
gridIt=[1 15];

fprintf('Partition of field in a matrix... ');
tic
[matrixUV, XX, YY]=getGridedField(X,Y, U,V,time, gridIt);
fprintf('Done\n\n');
toc
matrixUV=transferRegresionData(matrixV, matrixUV,time, plotU,safePlot);
%% analize turbulence
plotTurb=false;
saveplot=false;

plotCoord=mat2cell([ 1 1; 1 8 ;1 15 ],ones(3,1));
[ matrixUV It ti ] = turbulenceIntensity( matrixUV,time,30,plotCoord,mass);
XX=linspace(min(X(:)),max(X(:)),size(matrixUV,1));
YY=linspace(min(Y(:)),max(Y(:)),size(matrixUV,2));
q95=quantile(It(:),0.95);
if(plotTurb)
    plotTurbulence(It,XX,YY,ti,0:q95/99:q95,saveplot)
end
