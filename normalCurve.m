function [ p hdl]=normalCurve(figurename,mu,sigma,alims,x_label)


n=500;

zlims=[-3 3];
xlims=sigma*zlims+mu;
azlims=(alims-mu)/sigma;

x = [xlims(1):(xlims(2)-xlims(1))/n:xlims(2)];
z = [zlims(1):(zlims(2)-zlims(1))/n:zlims(2)];

ax = [alims(1):(alims(2)-alims(1))/n:alims(2)];
az = [azlims(1):(azlims(2)-azlims(1))/n:azlims(2)];

norm = normpdf(x,mu,sigma);
anorm = normpdf(ax,mu,sigma);

znorm = normpdf(z,0,1);
aznorm = normpdf(az,0,1);

hdl=getFigureHdl(figurename);

p = diff(normcdf(alims,mu,sigma));

figure(hdl);
subplot(1,2,1)
h=area(ax, anorm);
set(h,'FaceColor',[ 0.3 ,0.3, 0.3]);
set(get(h,'parent'),'xlim',xlims)
set(get(h,'parent'),'fontsize',16);
xlabel(x_label);
hold on
h=plot(x,norm,'k');
set(get(h,'parent'),'ytick',[]);
set(gca,'ylim',get(gca,'ylim')*1.1);

arrow=annotation('textarrow',[0.25 0.25], [0.3 0.2],'String',num2str(alims(1)));
set(arrow,'parent',gca);
set(arrow,'X',[alims(1) alims(1)]);
len=diff(get(gca,'ylim'));
set(arrow,'Y',[ normpdf(alims(1),mu,sigma)+len*0.1  normpdf(alims(1),mu,sigma)]);
set(arrow,'headstyle','none');
set(arrow,'linestyle','--');

arrow=annotation('textarrow',[0.25 0.25], [0.3 0.2],'String',num2str(alims(2)));
set(arrow,'parent',gca);
set(arrow,'X',[alims(2) alims(2)]);
len=diff(get(gca,'ylim'));
set(arrow,'Y',[ normpdf(alims(2),mu,sigma)+len*0.1  normpdf(alims(2),mu,sigma)]);
set(arrow,'headstyle','none');
set(arrow,'linestyle','--');

hold off


subplot(1,2,2)
h=area(az, aznorm);
set(h,'FaceColor',[ 0.3 ,0.3, 0.3]);
set(get(h,'parent'),'xlim',zlims);
set(get(h,'parent'),'fontsize',16);
xlabel('z');
hold on
h=plot(z,znorm,'k');
set(get(h,'parent'),'ytick',[]);
set(gca,'ylim',get(gca,'ylim')*1.1);

arrow=annotation('textarrow',[0.25 0.25], [0.3 0.2],'String',num2str(azlims(1)));
set(arrow,'parent',gca);
set(arrow,'X',[azlims(1) azlims(1)]);
len=diff(get(gca,'ylim'));
set(arrow,'Y',[ normpdf(azlims(1),0,1)+len*0.1  normpdf(azlims(1),0,1)]);
set(arrow,'headstyle','none');
set(arrow,'linestyle','--');


arrow=annotation('textarrow',[0.25 0.25], [0.3 0.2],'String',num2str(azlims(2)));
set(arrow,'parent',gca);
set(arrow,'X',[azlims(2) azlims(2)]);
len=diff(get(gca,'ylim'));
set(arrow,'Y',[ normpdf(azlims(2),0,1)+len*0.1  normpdf(azlims(2),0,1)]);
set(arrow,'headstyle','none');
set(arrow,'linestyle','--');
hold off
end





function [hdl ] = getFigureHdl(name)
%returns the handle for a figure with the name given, if the figure doen't
%exist, it creates one figure with that name,
hdl=findobj('name',name);
if(isempty(hdl))
    hdl=figure('name',name);
end


end

