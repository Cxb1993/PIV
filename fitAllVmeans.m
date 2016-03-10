function [matrix, a,r]= fitAllVmeans(matrix,time,drawVelocities,saveGraph)
warning off

global mass param


detailed=~isempty(strfind(drawVelocities,'u')) || ...
    ~isempty(strfind(drawVelocities,'v'));
    
saveGraph=saveGraph & detailed;

 a=zeros(size(matrix));
 a(:,:)=nan;
 b=a;
 r=a;
 umean=a;
startpoint= [0.366372 0];
startpoint1=startpoint;
figure(5)
clf(5)
set(5, 'Position', get(0,'Screensize'));
set(5,'Visible','off')

figure(6)
clf(6)
set(6, 'Position', get(0,'Screensize'));
set(6,'Visible','off')
for i=1:size(matrix,1)
    for j=1:size(matrix,2)%j=size(matrix,2):-1:1
        tic
        
        axesV=zeros(1,2);
        axesU=zeros(1,2);
        
        if(detailed)
            partition=[100 167]; %[50 50] glass  -  [100 167] starch
            [axesU, axesV]=quantifyFrequencyOfData(matrix, time, [i j], ...
                partition,drawVelocities,[5 6],[0 max(time)],[-2 2;-1 4]);
            
        end

        method='Bisquare';
        [fitresult, gof] = getFit4V3(time, matrix(i,j).Vmean, ... 
            matrix(i,j).weight,startpoint1,false,axesV(1),method);
  
        t=0:max(time)/(numel(time)-1):max(time(:));
  
        [ vel, vair, vsed, t_sonic, t_subsonic, tau_choked,tau_p, ...
            v_choked0,v_chokedf,phi]=VelocityParticule(t*1E-3,fitresult.K,fitresult.u0);
%         if(t_subsonic==0)
%             t2=0:max(time)/(numel(time)-1):2E3*t_sonic;
%             [ vel2, vair2, vsed2, t_sonic,t_subsonic,phi] =VelocityParticule(t2*1E-3,fitresult.K,fitresult.u0);
% 
%         end

        matrix(i,j).fit.V.vmean=fitresult(time);
        matrix(i,j).fit.V.K=fitresult.K;
        matrix(i,j).fit.V.u0=fitresult.u0;      
        matrix(i,j).fit.V.tau_choked=tau_choked;     
        matrix(i,j).fit.V.tau_p=tau_p;     
        matrix(i,j).fit.V.v_choked0=v_choked0;     
        matrix(i,j).fit.V.v_chokedf=v_chokedf;   
        matrix(i,j).fit.V.phi=phi;     
        matrix(i,j).fit.V.t_sonic=t_sonic;     
        matrix(i,j).fit.V.t_subsonic=t_subsonic;     
        matrix(i,j).fit.V.rsquare=gof.rsquare;
        bounds=confint(fitresult);
        matrix(i,j).fit.V.K_upper=bounds(1,1);
        matrix(i,j).fit.V.K_lower=bounds(2,1);
        matrix(i,j).fit.V.u0_upper=bounds(1,2);
        matrix(i,j).fit.V.u0_lower=bounds(2,2);
        

        a(i,j)=fitresult.K;
        b(i,j)=fitresult.u0;
        umean(i,j)=mean(matrix(i,j).Umean(~isnan(matrix(i,j).Umean)));
        fprintf('[ %d,%d]:\n\tK= %f\n\tu0= %f\n\tr^2= %f\n',i,j,matrix(i,j).fit.V.K,matrix(i,j).fit.V.u0,matrix(i,j).fit.V.rsquare)     
%put coordinates on vertical velocity graph
        if (~isempty(strfind(drawVelocities,'v')))
            
            
            plot(t,vel,'k','Parent',axesV(1),'LineWidth',3);
            plot(t,vair,'k--','Parent',axesV(1),'LineWidth',3);
            plot(t,vsed,'k-.','Parent',axesV(1),'LineWidth',3);
            plot(time,matrix(i,j).Vmean,'+k','Parent',axesV(1), ...
                'LineWidth',2,'MarkerSize',5);
            plot([t_sonic*1000 t_sonic*1000],[-1 4],'k','Parent',axesV(1),'LineWidth',1)
            plot([t_subsonic*1000 t_subsonic*1000],[-1 4],'k','Parent',axesV(1),'LineWidth',1)
            box(axesV(1),'on');
            ylim(axesV(1),[-1 4]);
            
            
            font='Helvetica';

            hdlv1=annotation(6,'textbox',...
                [0.2 0.80 0.16 0.08],...
                'String', ...
                   {['x=( ' num2str(round(matrix(i,j).xlim(1)*10)/10) ...
                    'mm, ' num2str(round(matrix(i,j).xlim(2)*10)/10) ...
                    'mm) ', 'y=(' num2str(round(matrix(i,j).ylim(1)*10)/10)...
                    'mm,' num2str(round(matrix(i,j).ylim(2)*10)/10) 'mm)']},...
                'FontName',font,...
                'FontSize',20,'Parent',axesV(1),...
                'FitBoxToText','off',...
                'EdgeColor','none',...
                'Color',[0.87058824300766 0.921568632125854 0.980392158031464]);
            
            
            hold(axesV(2),'all');
            hdlv2=annotation(6,'textbox',...
                [0.6 0.8 0.18 0.14],...
                'String', ...
                   {['x=( ' num2str(round(matrix(i,j).xlim(1)*10)/10) ...
                    'mm, ' num2str(round(matrix(i,j).xlim(2)*10)/10) ...
                    'mm) ', 'y=(' num2str(round(matrix(i,j).ylim(1)*10)/10)...
                    'mm,' num2str(round(matrix(i,j).ylim(2)*10)/10) 'mm)']},...
                'FontName',font,...
                'FontSize',20,...
                'FitBoxToText','off',...
                'LineStyle','none');        
            if(strcmp(get(6,'Visible'),'off'))
                set(6,'Visible','on')
                set(6,'units','normalized','outerposition',[0 0 1 1])
            end
        end
        
%put coordinates and points on horizontal velocity graph
        if(~isempty(strfind(drawVelocities,'u')))
            ylim(axesU(1),[-2 2]);        
            box(axesU(1),'on');
            hold(axesU(1),'all');
            plot(time,matrix(i,j).Umean,'+k','Parent',axesU(1), ...
                'LineWidth',2,'MarkerSize',5);
            zero=[0 time(size(time,1))];
            plot(zero,[0 0],'k','Parent',axesU(1),'LineWidth',2);
            hold(axesU(1),'off');
            hold off

            
            hdlu2=annotation(5,'textbox',...
                [0.2 0.80 0.16 0.08],...
                'String', ...
                   {['x=( ' num2str(round(matrix(i,j).xlim(1)*10)/10) ...
                    'mm, ' num2str(round(matrix(i,j).xlim(2)*10)/10) ...
                    'mm) ', 'y=(' num2str(round(matrix(i,j).ylim(1)*10)/10)...
                    'mm,' num2str(round(matrix(i,j).ylim(2)*10)/10) 'mm)']},...
                'FontSize',20,...
                'FontName',font,...
                'FitBoxToText','off',...
                'EdgeColor','none',...
                'Color',[0.87058824300766 0.921568632125854 0.980392158031464]);
            hdlu2=annotation(5,'textbox',...
                [0.6 0.8 0.18 0.14],...
                'String', ...
                   {['x=( ' num2str(round(matrix(i,j).xlim(1)*10)/10) ...
                    'mm, ' num2str(round(matrix(i,j).xlim(2)*10)/10) ...
                    'mm) ', 'y=(' num2str(round(matrix(i,j).ylim(1)*10)/10)...
                    'mm,' num2str(round(matrix(i,j).ylim(2)*10)/10) 'mm)']},...
                'FontSize',20,...
                'FontName',font,...
                'FitBoxToText','off',...
                'LineStyle','none'); 
            
            if(strcmp(get(5,'Visible'),'off'))
                set(5,'Visible','on')
                set(5,'units','normalized','outerposition',[0 0 1 1])
            end
        end
        
        pause(0.5)
%% Save Images
        if(saveGraph)

            if(ispc)
                folder='Figures\';
            elseif(isunix)
                folder='Figures/';
            end
            
            x_lim=matrix(i,j).xlim;
            x_lim=['(' num2str(x_lim(1)) ' , ' num2str(x_lim(2)) ')'];
            y_lim=matrix(i,j).ylim;
            y_lim=['(' num2str(y_lim(1)) ' , ' num2str(y_lim(2)) ')'];
            
    %%Save Images for vertical Velocity
            
            set(hdlv2,'Visible','off');
            fprintf('\tSaving Contours Figure for Vertical Speed...');
            export_fig([axesV(1); get(hdlv1,'Parent')], ...
                [folder 'Vspeed_C_' mass '_X=' x_lim '_Y=' y_lim], ...
                                    '-png','-eps','-pdf','-transparent');        
            set(hdlv2,'Visible','on');
            set(hdlv1,'Visible','off');
            fprintf(' Done\n\tSaving Surf Figure for Vertical Speed...');
            export_fig([axesV(2); get(hdlv2,'Parent')], ...
                [folder 'Vspeed_S_' mass '_X=' x_lim '_Y=' y_lim], ...
                                    '-png','-eps','-pdf','-transparent');
                                
            set(hdlv1,'Visible','on');
            pause(0.5)
            fprintf(' Done\n\tSaving Contours and Surf Figure for Vertical Speed...');
            export_fig(6, ...
                [folder 'Vspeed_CS_' mass '_X=' x_lim '_Y=' y_lim], ...
                                    '-png','-eps','-pdf','-transparent');

            fprintf(' Done\n\tSaving Matlab Figure for Vertical Speed...\n');
            saveas(6, [folder...
                'Vspeed_Mat_' mass '_X=' x_lim '_Y=' y_lim '.fig'],'fig');
        end %if(saveGraph)
        toc
    end
    
end
warning on
