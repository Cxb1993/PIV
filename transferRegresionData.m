function matrixUV=transferRegresionData(matrixV, matrixUV,time, plotU,savePlots)
savePlots=savePlots & plotU;
global mass
    if(plotU)
        figure(5)
        clf
        figure(6)
        clf
        font='Helvetica';
        set(5,'position',get(0,'Screensize'))
        set(6,'position',get(0,'Screensize'))
    end
for i=1:size(matrixUV,1)
    for j=1:size(matrixUV,2)
    
    matrixUV(i,j).fit.V=matrixV.fit.V;
    
    if(plotU)
        tic
    end
    if(plotU && sum(matrixUV(i,j).u(:)~=0)>numel(matrixUV(i,j).u)*.1)    

        
        fprintf('Ploting data for [%d,%d] ... ',i,j)
        [axesU, axesV]=quantifyFrequencyOfData(matrixUV, time, [i j], ...
            [60 100],'uv',[5 6],[0 max(time)],[-2 2;-1 4]);
        
        box(axesU(1),'on');
        hold(axesU(1),'all');
        
        box(axesV(1),'on');
        hold(axesV(1),'all');
        
        %%Plot scatered data over conturs
        plot(time,matrixUV(i,j).Umean,'+k','Parent',axesU(1),'LineWidth',2,'MarkerSize',5);
        plot(time,matrixUV(i,j).Vmean,'+k','Parent',axesV(1),'LineWidth',2,'MarkerSize',5);
        %%Plot mean data over conturs
        plot([0 time(size(time,1))],[0 0],'k','Parent',axesU(1),'LineWidth',2);
        plot(time,matrixUV(i,j).fit.V.vmean,'k','Parent',axesV(1),'LineWidth',2);
        
        hold(axesU(1),'off');
        hold off
        
        %put coordinate labels
        x1=num2str(round(matrixUV(i,j).xlim(1)*10)/10);
        x1=[repmat(' ',[1 5-numel(x1)]) x1];
        x2=num2str(round(matrixUV(i,j).xlim(2)*10)/10);
        x2=[repmat(' ',[1 5-numel(x2)]) x2];
        y1=num2str(round(matrixUV(i,j).ylim(1)*10)/10);
        y1=[repmat(' ',[1 5-numel(y1)]) y1];
        y2=num2str(round(matrixUV(i,j).ylim(2)*10)/10);
        y2=[repmat(' ',[1 5-numel(y2)]) y2];
        
        coords=['x=( ' x1 'mm , ' x2 'mm )' ; 'y=( ' y1 'mm , ' y2 'mm )'];

        hdlu(1)=annotation(5,'textbox',[0.2 0.80 0.18 0.08],...
            'String', {coords},'FontSize',20,'FontName',font,...
            'FitBoxToText','off','EdgeColor','none',...
            'HorizontalAlignment','center', ...
            'Color',[0.87058824300766 0.921568632125854 0.980392158031464]);
        
        hdlu(2)=annotation(5,'textbox',[0.6 0.8 0.18 0.14],...
            'String', {coords},'FontSize',20,'FontName',font,...
            'FitBoxToText','off','EdgeColor','none',...
            'HorizontalAlignment','center', ...
            'Color',[0 0 0]);
        hdlv(1)=annotation(6,'textbox',[0.2 0.80 0.18 0.08],...
            'String', {coords},'FontSize',20,'FontName',font,...
            'FitBoxToText','off','EdgeColor','none',...
            'HorizontalAlignment','center', ...
            'Color',[0.87058824300766 0.921568632125854 0.980392158031464]);
        
        hdlv(2)=annotation(6,'textbox',[0.6 0.8 0.18 0.14],...
            'String', {coords},'FontSize',20,'FontName',font,...
            'FitBoxToText','off','EdgeColor','none',...
            'HorizontalAlignment','center', ...
            'Color',[0 0 0]);
        
        if(strcmp(get(5,'Visible'),'off'))
            set(5,'Visible','on')
        end
        ylim(axesU(1),[-2 2]);
        %ylim(axesU(2),[-1 1]);
        xlim(axesU(1),[0 max(time(:))]);
        xlim(axesU(2),[0 max(time(:))]);
        
        ylim(axesV(1),[-1 4]);
        %ylim(axesU(2),[-1 1]);
        xlim(axesV(1),[0 max(time(:))]);
        xlim(axesV(2),[0 max(time(:))]);
        
        fprintf('Done\n')
       pause(1)

       if(savePlots)
            if(ispc)
                folder='Figures\';
            elseif(isunix)
                folder='Figures/';
            end

            x_lim=matrixUV(i,j).xlim;
            x_lim=['(' num2str(x_lim(1)) ' , ' num2str(x_lim(2)) ')'];
            y_lim=matrixUV(i,j).ylim;
            y_lim=['(' num2str(y_lim(1)) ' , ' num2str(y_lim(2)) ')'];

            set(hdlu(2),'Visible','off');
            set(hdlv(2),'Visible','off');
            fprintf('\tSaving Contours Figure for Horizontal Speed...');
            export_fig([axesU(1); get(hdlu(1),'Parent')], ...
                [folder 'Uspeed_C_' mass '_X=' x_lim '_Y=' y_lim], ...
                                    '-png','-eps','-pdf','-transparent');
            fprintf(' Done\n\tSaving Contours Figure for Vertical Speed...');
            export_fig([axesV(1); get(hdlv(1),'Parent')], ...
                            [folder 'Vspeed_C_' mass '_X=' x_lim '_Y=' y_lim], ...
                                                '-png','-eps','-pdf','-transparent');                              
                                            
            set(hdlu(2),'Visible','on');
            set(hdlv(2),'Visible','on');
            
            set(hdlu(1),'Visible','off');
            set(hdlv(1),'Visible','off');
            
            fprintf(' Done\n\tSaving Surf Figure for Horizontal Speed...');
            export_fig([axesU(2); get(hdlu(2),'Parent')], ...
                [folder 'Uspeed_S_' mass '_X=' x_lim '_Y=' y_lim], ...
                                    '-png','-eps','-pdf','-transparent');
            
            fprintf(' Done\n\tSaving Surf Figure for Vertical Speed...');
            export_fig([axesV(2); get(hdlv(2),'Parent')], ...
                [folder 'Vspeed_S_' mass '_X=' x_lim '_Y=' y_lim], ...
                                    '-png','-eps','-pdf','-transparent');

            set(hdlu(1),'Visible','on');
            set(hdlv(1),'Visible','on');
            pause(0.5)
            
            fprintf(' Done\n\tSaving Contours and Surf Figure for Horizontal Speed...');
            export_fig(5, ...
                [folder 'Uspeed_CS_' mass '_X=' x_lim '_Y=' y_lim], ...
                                    '-png','-eps','-pdf','-transparent');
            fprintf(' Done\n\tSaving Contours and Surf Figure for Vertical Speed...');
            export_fig(6, ...
                [folder 'Vspeed_CS_' mass '_X=' x_lim '_Y=' y_lim], ...
                                    '-png','-eps','-pdf','-transparent');
                                
            fprintf(' Done\n\tSaving Matlab Figure for Horizontal Speed...\n');
            saveas(5, [folder...
                'Uspeed_Mat_' mass '_X=' x_lim '_Y=' y_lim '.fig'],'fig');
            fprintf(' Done\n\tSaving Matlab Figure for Vertical Speed...\n');
            saveas(6, [folder...
                'Vspeed_Mat_' mass '_X=' x_lim '_Y=' y_lim '.fig'],'fig');
        end
    end


    if(plotU)
        toc
    end
    end
end

            