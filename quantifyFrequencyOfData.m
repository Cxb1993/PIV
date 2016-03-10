% In the graphs of horizontals and vertical velocity of a given position 
% (matCoordinates) in the grided matrix vs time, this function makes  a 
% subdivision the of the domain(time) of partition(2) and of partition(1) 
% for the range (vertical and horizontal velocity) and  calculates the 
% frequency of apartition of values in each partition of the space of
% velocity vs time for a given spacial domain in the matrix. It gives
% produces a contours and surf graph if the value graph is positive
function [axesU, axesV]=quantifyFrequencyOfData(matrix, time, ...
    matCoordinates,partition,drawVelocities,Nfigures,xlim,ylim)  

axesU=[];
axesV=[];
m=partition(1);
n=partition(2);
mat=matCoordinates;

    

% m=150;
% n=250;
% mat=[1 10];

u=reshape(matrix(mat(1),mat(2)).u,1,numel(matrix(mat(1),mat(2)).u));
v=reshape(matrix(mat(1),mat(2)).v,1,numel(matrix(mat(1),mat(2)).v));
t=reshape(repmat(time',size(matrix(mat(1),mat(2)).u,1),1),1,numel(u));
 
i=(u~=0 & v~=0);
j= i;

u=u(i);
v=v(j);
tu=t(i);
tv=t(j);


%regrouping data
if(nargin>=7 && ~isempty(xlim))
    mintu=min(min(tu(:)),min(xlim));
    maxtu=max(max(tu(:)),max(xlim));
    
    mintv=min(min(tv(:)),min(xlim));
    maxtv=max(max(tv(:)),max(xlim));
else
    mintu=min(tu(:));
    maxtu=max(tu(:));
    mintv=min(tv(:));
    maxtv=max(tv(:));
end
if(nargin>=8 && ~isempty(ylim))
    minu=min(min(u(:)),min(ylim(1,:)));
    minv=min(min(v(:)),min(ylim(2,:)));
    
    maxu=max(max(u(:)),max(ylim(1,:)));
    maxv=max(max(v(:)),max(ylim(2,:)));
else
    minu=min(u(:));
    minv=min(v(:));
    maxu=max(u(:));
    maxv=max(v(:));   
end


ui=linspace(minu,maxu,m);
vi=linspace(minv,maxv,m);
tui=linspace(mintu,maxtu,n);
tvi=linspace(mintv,maxtv,n);


ur=interp1(ui,1:numel(ui),u,'nearest');
vr=interp1(vi,1:numel(vi),v,'nearest');
tur=interp1(tui,1:numel(tui),tu,'nearest');
tvr=interp1(tvi,1:numel(tvi),tv,'nearest');

[T,UU]=meshgrid(tui,ui);
[T,VV]=meshgrid(tvi,vi);


Z1=accumarray([ur' tur'],1,[m n]);
Z2=accumarray([vr' tvr'],1,[m n]);

%Standarize data
Z1tot=repmat(sum(Z1),m,1);
Z2tot=repmat(sum(Z2),m,1);
Z1(Z1tot~=0)=Z1(Z1tot~=0)./Z1tot(Z1tot~=0);
Z2(Z2tot~=0)=Z2(Z2tot~=0)./Z2tot(Z2tot~=0);

%remove data with no statistical value
Z1(Z1tot<quantile(Z1tot(Z1tot>0),.025))=0;
Z2(Z1tot<quantile(Z1tot(Z1tot>0),.025))=0;
levelList=0:0.0015:0.15;
% Graph Data
if(~isempty(strfind(drawVelocities,'u')))
    [axesU]=ContourSurfVelocityGraph(T,UU, Z1,'Horizontal Velocity, U [ m/s ]',levelList,Nfigures(1));
end
if(~isempty(strfind(drawVelocities,'v')))
    [axesV]=ContourSurfVelocityGraph(T,VV, Z2,'Vertical Velocity, V [ m/s ]',levelList,Nfigures(2));
end








