function [fitresult, gof] = getFit4V3(time, V, weights, startpoint, graph, axesV,robust)

%% Fit: 'untitled fit 1'.
[xData, yData, weights1] = prepareCurveData( time, V, weights );

% Set up fittype and options.

ft = fittype('VelocityParticule(t*1e-3, K,u0)', 'independent', 't', 'dependent', 'V' );
opts = fitoptions( ft );
opts.Algorithm = 'Trust-Region';
opts.Display = 'Off';
opts.Lower = [0 0];
opts.Robust = robust;
opts.StartPoint =startpoint;
opts.Upper = [ 1 5];
opts.Weights = weights1;
% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
if(graph)
    % Plot fit with data.
    box(axesV,'on');
    hold(axesV,'all');
    h = plot(xData,fitresult(xData),'k','Parent',axesV,'LineWidth',2);
    h=plot(xData,yData,'+k','Parent',axesV,'LineWidth',2,'MarkerSize',5);
end
   


