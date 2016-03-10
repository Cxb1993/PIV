%Analizes the data of 1 PIV txt double pulse result given in the form:
%X Y U V where X and Y contain the coordinate vectors and U and V are the
%speed vectors on those coordinates.
function [X Y U V v]=analysePIV(folder,fileName, t, levelList, graph,saveGraph)
global mass
saveGraph=saveGraph & graph;
if(graph)
    tic
end
fid = fopen([folder fileName]);
C = textscan(fid, '%f %f %f %f');
fclose(fid);

if(size(C{1},1)==0)
    fid = fopen([folder fileName]);
    C = textscan(fid, '%f %f %f %f','HeaderLines',3);
    fclose(fid);
    if(size(C{1},1)~=1722)
        input(['Caution with file ' fileName ' the size if the column read is '  num2str(size(C{1},1)) ...
             '\nit is possible that the reading instruction does not agree with the structure of the file.\n>>']);
    end
end

X=C{1};
Y=C{2};
U=C{3};
V=C{4};

v=(U.^2+V.^2).^0.5;
if(graph)
    %dispersionFigure(theta/pi,v,t);
    hdl=findobj('name','Vectorial Field');
    if(isempty(hdl))
        hdl=figure('name','Vectorial Field');
        position=get(0,'Screensize');
        position(1,1)=int32(position(1,3)/2);
        position(1,3)=int32(position(1,3)/2);
        set(hdl, 'Position', position);
        
    end
    tit=vectorialFieldFigure(X,Y,U,V,[0 70],[50 125], t,levelList,hdl);
    pause(0.5)
    %saveas(1,['Images\' fileName(1: strfind(fileName,'.')-1)],'png');
end
if(saveGraph)
    if(ispc)
        folderFig='Figures\';
    elseif(isunix)
        folderFig='Figures/';
    end
    nameFig=strsplit(fileName,'.txt');
    nameFig=nameFig{1};
    
    fprintf(['\tSaving plot for setup ' nameFig ' ...']);
    set(tit,'visible','off')
    pause(1)
    try
        export_fig(hdl,[folderFig 'VectField_' mass '_' nameFig], ...
                                        '-png','-eps','-pdf','-transparent');
    catch err
        fprintf(['Failed to save image ...']);
    end
    fprintf(['Done\n\t\tsaving matlab figure...']);
    try
        saveas(hdl,[folderFig 'VectField_' mass '_' nameFig '.fig'],'fig');
    catch err
        fprintf(['Failed to save matlab figure ...']);
    end
    fprintf('Done\n');
end
       
if(graph)
    toc
end




function dispersionFigure(X1, Y1,t)
%CREATEFIGURE(X1,Y1)
%  X1:  vector of x data
%  Y1:  vector of y data

%  Auto-generated by MATLAB on 03-Dec-2012 12:03:15

% Create figure
%close(figure(2))
figure1 = figure(2);
clf(figure1);



% Create axes
axes1 = axes('Parent',figure1);
ylim(axes1,[0 6]);
xlim(axes1,[0 2]);
box(axes1,'on');
hold(axes1,'all');

% Create plot
plot(X1,Y1,'Marker','.','LineStyle','none');

% Create xlabel
xlabel('Angle of speed vectors (radians)');

% Create ylabel
ylabel('Speed (m/s)');

% Create title
title(['time=' num2str(t) 'ms']);

