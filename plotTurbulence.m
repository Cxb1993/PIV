function plotTurbulence(It,X,Y,ti,levelList,save)
global mass
fig=findobj('name','Turbulence Map');
if(isempty(fig))
    fig=figure('name', 'Turbulence Map','Color',[1 1 1]);
    position=get(0,'screensize');
    position(1,3)=position(1,3)/2;
    set(fig,'position',position);
end
colormap(fig,jet(100))


for i=1:size(ti,2)
    
    clf(fig);
set(fig,'Color',[1 1 1]);


% Create axes

axes1 = axes('Parent',fig,...
    'Position',[0.1 0.11111234705228 0.85 0.815],...
    'Layer','top',...
    'FontSize',15,'Color','none');
    
    
    YTickLabel=cellfun(@(x)num2str(x),mat2cell(round(10*Y')/10, ...
        ones(size(Y,2),1))','UniformOutput',false);
    XTickLabel=cellfun(@(x)num2str(x),mat2cell(round(10*X')/10, ...
        ones(size(X,2),1))','UniformOutput',false);
    XTickLabel(2:2:numel(XTickLabel))={''};
    
    [C,hdl]=contour(axes1,X,Y,It(:,:,i)','Fill','on');
    %[hdl]=surf(axes1,X,Y,It(:,:,i)');
    
    supe=100;
    infe=1;
    if(~isempty(levelList))
        maxZ=max(max(It(:,:,i)));
        maxL=max(levelList);
        minZ=min(min(It(:,:,i)));
        minL=min(levelList);
        if(maxZ<maxL && maxZ>0)
            supe=round((maxZ-minL)/(maxL-minL)*100);
        end
        if(minZ>minL)
            infe=round(minZ/(maxL-minL)*100);
        end
        set(hdl,'LevelList',levelList)
    end
    colmap=jet(100);
    colormap(fig,colmap(infe:supe,:));
    
    
    set(axes1,'YtickLabel', YTickLabel, ...
                   'YTick',Y, ...
                   'YGrid','on', ...
                   'XtickLabel', XTickLabel, ...
                   'XTick',X, ...
                   'XGrid','on', ...
                   'Layer','top',...
                   'GridLineStyle','-',...
                   'FontSize',15)
               xlabel('X (mm)','FontSize',20);

    % Create ylabel
    ylabel('Y (mm)','FontSize',20);

    % Create colorbar
    colorbar('peer',axes1,'FontSize',15);

    % Create textbox
    hdl=annotation(fig,'textbox',...
        [0.3 0.926027397260274 0.5 0.0506849315068493],...
        'String',{['Turbulence Intensity at ' num2str(round(10*ti(i))/10) ' ms']},...
        'FontSize',20,...
        'FitBoxToText','off',...
        'LineStyle','none');
    pause(0.5)
    if(save)
        
        position=get(0,'screensize');
        position(1,3)=position(1,3)/2;
        if(~isequal(get(fig,'position'),position))
            set(fig,'position',position);
        end
        fprintf(['\tSaving Turbulence intensity map for ' ...
            num2str(round(10*ti(i))/10) '...']);
            set(hdl,'visible','off');
            pause(0.5)
            if(ispc)
                folder='Figures\';
            elseif(isunix)
                folder='Figures/';
            end
        export_fig(fig, ...
                [folder 'TurbulenceIntensity_' mass '_' ...
                num2str(round(10*ti(i))/10) 'ms'], ...
                                    '-png','-eps','-pdf','-transparent');
    %    export_fig(2,[folder 'TurbulenceIntensityvstime_' mass '_'],'-png','-eps','-pdf','-transparent');
     %saveas(2,[folder 'TurbulenceIntensityvstime_' mass '.fig'],'fig');

    fprintf('Done\n');
        
    end
end
