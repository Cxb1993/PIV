function [ matrixUV, It, ti ] = turbulenceIntensity( matrixUV,time,nti,plotCoord,name) 

%divide time in intervals for adding all the squares of u' and v'
if(iscell(plotCoord))
    plotCoord=mat2cell(unique(cell2mat(plotCoord),'rows'), ...
        ones(size(plotCoord,1),1)');
    graph=true;
elseif(plotCoord)
    [m, n]=size(matrixUV);
    r=repmat((1:m),[n,1]);
    r=r(:);
    
    plotCoord=[r repmat((1:n)',[m 1])];
    plotCoord=mat2cell(plotCoord,ones(m*n,1));
    graph=true;
else
    graph=false;

end
ti=linspace(min(time),max(time),nti);
tr=interp1(ti,1:numel(ti),time,'nearest');
j=unique(tr);
[trr, jj ]=meshgrid(tr,j);
k=trr==jj;
It=zeros([size(matrixUV) size(ti,2)]);



m=1;
plots=zeros(numel(plotCoord),size(ti,2));
urms=plots;
vrms=plots;
plotnames=cell(numel(plotCoord),1);
urmsnames=cell(numel(plotCoord),1);
vrmsnames=cell(numel(plotCoord),1);


for i=1:size(matrixUV,1)
    for j=1:size(matrixUV,2)
        
        matrixUV(i,j).u_prime=matrixUV(i,j).u;
        matrixUV(i,j).v_prime=zeros(size(matrixUV(i,j).v));

        nonzeros=matrixUV(i,j).v~=0 | matrixUV(i,j).u~=0;
        n=sum(nonzeros,1);
        vmean=repmat(matrixUV(i,j).fit.V.vmean',size(matrixUV(i,j).v,1),1);
        matrixUV(i,j).v_prime(nonzeros)=matrixUV(i,j).v(nonzeros)- ...
            vmean(nonzeros);

        sum_uprime_2=sum(matrixUV(i,j).u_prime.^2,1);
        sum_vprime_2=sum(matrixUV(i,j).v_prime.^2,1);

        sum_uprime_2=repmat(sum_uprime_2,[nti,1]);
        sum_vprime_2=repmat(sum_vprime_2,[nti,1]);
        n=repmat(n,[nti,1]);

        sumuprime2=zeros(size(sum_uprime_2));
        sumvprime2=zeros(size(sum_vprime_2));
        nn=zeros(size(n));

        sumuprime2(k)=sum_uprime_2(k);
        sumvprime2(k)=sum_vprime_2(k);
        nn(k)=n(k);

        sum_uprime_2=sum(sumuprime2,2);
        sum_vprime_2=sum(sumvprime2,2);
        n=sum(nn,2);

        matrixUV(i,j).urms=zeros(size(n));
        matrixUV(i,j).vrms=zeros(size(n));
% 
%         matrixUV(i,j).urms(:)=nan;
%         matrixUV(i,j).vrms(:)=nan;

        matrixUV(i,j).urms(n>0)=sqrt(sum_uprime_2(n>0)./n(n>0));
        matrixUV(i,j).vrms(n>0)=sqrt(sum_vprime_2(n>0)./n(n>0));

        K=matrixUV(i,j).fit.V.K;
        u0=matrixUV(i,j).fit.V.u0;
        vmean=VelocityParticule(ti, K, u0);
            
        matrixUV(i,j).It=sqrt(matrixUV(i,j).urms.^2+matrixUV(i,j).vrms.^2)./abs(vmean);
        
        It(i,j,:)=matrixUV(i,j).It;
        
        if(graph && sum(cellfun(@(x)isequal(x,[i j]),plotCoord)>0))
            plotnames{m}=[ 'y=( ' num2str(round(10*matrixUV(i,j).ylim(1))/10) ...
                ' , ' num2str(round(10*matrixUV(i,j).ylim(2))/10) ' )'];
            urmsnames{m}=[ 'u''_{rms} - ' plotnames{m} ];
            vrmsnames{m}=[ 'v''_{rms} - ' plotnames{m} ];
            
            plots(m,:)=matrixUV(i,j).It;                
            urms(m,:)=matrixUV(i,j).urms;
            vrms(m,:)=matrixUV(i,j).vrms;
            m=m+1;
        end
        
    end
end
if(graph)
    hdl=findobj('name','turbulence');
    if(isempty(hdl))
        hdl=figure('name','turbulence');
    else
        clf(hdl);
    end
    createfigure(hdl,ti,plots,plotnames);
    export_fig(hdl,['TurbulenceIntensity_' name ],'-pdf','-transparent');
    
    hdl=findobj('name','vrms and urms');
    if(isempty(hdl))
        hdl=figure('name','vrms and urms');
        
    else
        clf(hdl);
    end
    figure(hdl)
    createfigure(hdl,ti,plots,plotnames);
    
    hold off
    
    
    pos=get(hdl,'children');
    hdl2=pos(2);
    set(0,'DefaultAxesColorOrder',[0 0 0],'DefaultAxesLineStyleOrder',{'^','o','s'})
    hdl2=plot(hdl2,ti,[vrms;urms]);
    ylabel('u''_{rms} , v''_{rms} (m/s)','FontSize',20);
    xlabel('Time (ms)','FontSize',20);
    set(hdl2(1:3),'MarkerFaceColor',[0 0 0],'Color',[0 0 0]);
    set(hdl2(4:6),'MarkerFaceColor',[1 0 0],'Color',[1 0 0]);
    ylim([0 1.6])
    legend(hdl2,[vrmsnames;urmsnames]);
    
    export_fig(hdl,['UrmsVrms_' name ],'-pdf','-transparent');
 
end


function createfigure(hdl,X1, YMatrix1,plotnames)
%CREATEFIGURE(X1, YMATRIX1)
%  X1:  vector of x data
%  YMATRIX1:  matrix of y data

%  Auto-generated by MATLAB on 11-Feb-2014 23:20:20

% Create figure

figure1 = hdl;
clf
set(figure1,'PaperSize',[20.98404194812 29.67743169791],...
    'Color',[1 1 1],'position',[ 1 1 770 697]);
colormap('hsv');

% Create axes
axes1 = axes('Parent',figure1,'YGrid','on',...
    'XTickLabel',{'0','','100','','200','','300','','400','','500'},...
    'XTick',[0 50 100 150 200 250 300 350 400 450 500],...
    'XGrid','on',...
    'Position',[0.13 0.108357963875205 0.775 0.815],...
    'FontSize',14,...
    'ColorOrder',[1 0 0;0 1 0;0 0 1]);
%% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0 500]);
%% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0 200]);
box(axes1,'on');
hold(axes1,'all');

% Create xlabel
xlabel('Time  ( ms )','FontSize',18);

% Create ylabel
ylabel('Turbulence intensity ( - )','FontSize',18);

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'Parent',axes1,'LineStyle','none','Color',[0 0 0]);

set(plot1(1),'MarkerSize',10,'Marker','*','LineWidth',1.4,...
    'DisplayName','x=( -0.7 , 71.2 ) ; y=( 65.2 , 67.7 )');
set(plot1(2),'MarkerSize',20,'Marker','.',...
    'DisplayName','x=( -0.7 , 71.2 ) ; y=( 102 , 104.5 )');
set(plot1(3),'MarkerSize',8,'Marker','square','LineWidth',2,...
    'DisplayName','x=( -0.7 , 71.2 ) ; y=( 136.4 , 138.9 )');

% Create legend
legend1 = legend(axes1,plotnames);
%set(legend1,'Position',[0.4042    0.7759    0.4623    0.1129]);
















