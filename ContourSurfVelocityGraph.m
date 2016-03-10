function [axesX]=ContourSurfVelocityGraph(xdata1, ydata1, zdata1, ...
    velocityLabel, levelList, Nfigure)

%climmin=min(zdata1(zdata1>0));
climmin=0;
climmax=quantile(zdata1(zdata1>0),0.85);


% Create figure
figure1=Nfigure;
clf(figure1);
set(figure1,'Color',[1 1 1]);


% Create axes

axes1 = axes('Parent',figure1,...
    'Position',[0.04 0.11111234705228 0.4 0.815],...
    'Layer','top',...
    'FontSize',15,'Color','none');
xlim(axes1,[0 max(xdata1(:))]);
box(axes1,'on');
hold(axes1,'all');

% Create contour
contour(axes1,xdata1,ydata1,zdata1,'LevelStep',0.05,...
    'LevelList',levelList,...
    'Fill','on');
supe=100;
infe=1;
if(~isempty(levelList))
    maxZ=max(zdata1(:));
    maxL=max(levelList);
    minZ=min(zdata1(:));
    minL=min(levelList);
    if(maxZ<maxL && maxZ>0)
        supe=round((maxZ-minL)/(maxL-minL)*100);
    end
    if(minZ>minL)
        infe=round(minZ/(maxL-minL)*100);
    end
   
end
colmap=(1-jet(100))*0.25+jet(100);
colmap=jet(100);
colormap(figure1,colmap(infe:supe,:));

% Create xlabel
xlabel(axes1,'Time, t [ ms ]','FontSize',20);

% Create ylabel
ylabel(axes1, velocityLabel,'FontSize',20);

% Create zlabel
zlabel(axes1, 'Frequence [ - ]','Visible','off');

% Create axesContourSurfVelocityGraph

axes2 = axes('Parent',figure1,...
    'Position',[0.5625 0.11 0.4 0.815],...
    'FontSize',15,...
    'CLim',[climmin climmax]);

view(axes2,[-108.5 64]);
grid(axes2,'on');
hold(axes2,'all');

% Create surf
surf(xdata1,ydata1,zdata1,'Parent',axes2,'FaceLighting','phong',...
    'LineStyle','none',...
    'FaceColor','interp');

% Create xlabel
xlabel(axes2, 'Time, t, [ ms ]','HorizontalAlignment','right','FontSize',20,...
    'BackgroundColor',[1 1 1]);

% Create ylabel
ylabel(axes2, velocityLabel,'FontSize',20,...
    'HorizontalAlignment','left');

% Create zlabel
zlabel(axes2,'Frequency [ - ]','FontSize',20);

% Create colorbar
axes3=colorbar('peer',axes1,'FontSize',15);
pos=get(axes3,'Position');
set(axes3,'Position',[0.4525 pos(2) 0.025 pos(4) ]);
% Resize the axes in order to prevent it from shrinking.
set(axes1,'Position',[0.04 0.11111234705228 0.4 0.815]);

axesX(1)=axes1;
axesX(2)=axes2;
colmap=jet(100);

colormap(figure1,colmap(infe:supe,:));