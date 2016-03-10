function matrixUV=transferVerticalData(matrixV, matrixUV,time, plotU,savePlots)
savePlots=savePlots & plotU;
global mass
    if(plotU)
        figure(5)
        clf
        font='Helvetica';
    end
for i=1:size(matrixUV,1)
    for j=1:size(matrixV,2)
        
        if(abs(matrixV(1,j).fit.V.rsquare)>1)
            matrixV(1,j).fit.V=getStructMean(matrixV(1,j-1).fit.V, ...
                matrixV(1,j+1).fit.V)
        end
        
        matrixUV(i,j).fit.V=matrixV(1,j).fit.V;
        if(plotU)
            tic
        end
        if(plotU && ... 
                sum(matrixUV(i,j).u(:)~=0)>prod(size(matrixUV(i,j).u))*.1)    
            fprintf('Ploting data for [%d,%d] ... ',i,j)
            [axesU]=quantifyFrequencyOfData(matrixUV, time, [i j], ...
                [60 100],'u',[5 6],[0 max(time)],[-1 1;nan nan]);
            box(axesU(1),'on');
            hold(axesU(1),'all');
            plot(time,matrixUV(i,j).Umean,'+k','Parent',axesU(1), ...
                'LineWidth',2,'MarkerSize',5);
            zero=[0 time(size(time,1))];
            plot(zero,[0 0],'k','Parent',axesU(1),'LineWidth',2);
            hold(axesU(1),'off');
            hold off


            hdlu1=annotation(5,'textbox',...
                [0.2 0.80 0.16 0.08],...
                'String', ...
                   {['x=( ' num2str(round(matrixUV(i,j).xlim(1)*10)/10) ...
                    'mm, ' num2str(round(matrixUV(i,j).xlim(2)*10)/10) ...
                    'mm) ', 'y=(' num2str(round(matrixUV(i,j).ylim(1)*10)/10)...
                    'mm,' num2str(round(matrixUV(i,j).ylim(2)*10)/10) 'mm)']},...
                'FontSize',20,...
                'FontName',font,...
                'FitBoxToText','off',...
                'EdgeColor','none',...
                'Color',[0.87058824300766 0.921568632125854 0.980392158031464]);
            hdlu2=annotation(5,'textbox',...
                [0.6 0.8 0.18 0.14],...
                'String', ...
                   {['x=( ' num2str(round(matrixUV(i,j).xlim(1)*10)/10) ...
                    'mm, ' num2str(round(matrixUV(i,j).xlim(2)*10)/10) ...
                    'mm) ', 'y=(' num2str(round(matrixUV(i,j).ylim(1)*10)/10)...
                    'mm,' num2str(round(matrixUV(i,j).ylim(2)*10)/10) 'mm)']},...
                'FontSize',20,...
                'FontName',font,...
                'FitBoxToText','off',...
                'LineStyle','none'); 
            
            if(strcmp(get(5,'Visible'),'off'))
                set(5,'Visible','on')
            end
            ylim(axesU(1),[-1 1]);
            %ylim(axesU(2),[-1 1]);
            xlim(axesU(1),[0 max(time(:))]);
            xlim(axesU(2),[0 max(time(:))]);
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
                
                set(hdlu2,'Visible','off');
                fprintf('\tSaving Contours Figure for Horizontal Speed...');
                export_fig([axesU(1); get(hdlu1,'Parent')], ...
                    [folder 'C_Uspeed_' mass '_X=' x_lim '_Y=' y_lim], ...
                                        '-png','-eps','-pdf','-transparent');

                set(hdlu2,'Visible','on');
                set(hdlu1,'Visible','off');
                fprintf(' Done\n\tSaving Surf Figure for Horizontal Speed...');
                export_fig([axesU(2); get(hdlu2,'Parent')], ...
                    [folder 'S_Uspeed_' mass '_X=' x_lim '_Y=' y_lim], ...
                                        '-png','-eps','-pdf','-transparent');

                set(hdlu1,'Visible','on');
                pause(0.5)
                fprintf(' Done\n\tSaving Contours and Surf Figure for Horizontal Speed...');
                export_fig(5, ...
                    [folder 'CS_Uspeed_' mass '_X=' x_lim '_Y=' y_lim], ...
                                        '-png','-eps','-pdf','-transparent');

                fprintf(' Done\n\tSaving Matlab Figure for Horizontal Speed...\n');
                saveas(5, [folder...
                    'Mat_Uspeed_' mass '_X=' x_lim '_Y=' y_lim '.fig'],'fig');
            end
        end
        

        if(plotU)
            toc
        end
    end
end
function V2=getStructMean(V1,V3)        
            V2.u0=mean(V1.u0,V3.u0);
            V2.Cd=mean(V1.Cd,V3.Cd);
            V2.vcor=mean(V1.vcor,V3.vcor);
            V2.rsquare=0;
            V2.u0_upper=mean(V1.u0_upper,V3.u0_upper);
            V2.u0_lower=mean(V1.u0_lower,V3.u0_lower);
            V2.Cd_upper=mean(V1.Cd_upper,V3.Cd_upper);
            V2.Cd_lower=mean(V1.Cd_lower,V3.Cd_lower);
            V2.vcor_upper=mean(V1.vcor_upper,V3.vcor_upper);
            V2.vcor_lower=mean(V1.vcor_lower,V3.vcor_lower);
            V2.mean=VelocityParticule(time,V2.Cd,V2.u0,V2.vcor);
            