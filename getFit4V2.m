function [fitresult, gof] = getFit4V2(time, V, weights, stdV, Vt, tf,startpoint, graph, axesV)
%CREATEFIT(TIME,V3)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : time
%      Y Output: V
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 16-Jan-2013 14:03:58


%% Fit: 'untitled fit 1'.
[xData, yData, weights1] = prepareCurveData( time, V, weights );

% Set up fittype and options.
Vt=num2str(Vt);
tf=num2str(tf);
ft = fittype( [Vt '*(1+(V0-' Vt ')/(V0+' Vt ')*exp(-t/' tf '))/(1-(V0-' Vt ')/(V0+' Vt ')*exp(-t/' tf '))+Vair'], 'independent', 't', 'dependent', 'V' );
opts = fitoptions( ft );
opts.Algorithm = 'Trust-Region';
opts.Display = 'Off';
opts.Lower = [-inf -inf];
opts.Robust = 'Bisquare';
opts.StartPoint =startpoint;
opts.Upper = [inf inf];
opts.Weights = weights1;
% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
if(graph)
    % Plot fit with data.
    figure(6);
    box(axesV,'on');
    hold(axesV,'all');
    h = plot(xData,fitresult(xData),'k','Parent',axesV,'LineWidth',2);
    h=plot(xData,yData,'+k','Parent',axesV,'LineWidth',2,'MarkerSize',5);
    %h=errorbar(time,V,stdV,'k','Parent', axesV,'linestyle','none');

%     legend( h, 'V3 vs. time', 'untitled fit 1', 'Location', 'NorthEast' );
%     % Label axes
%     xlabel( 'time' );
%     ylabel( 'V' );
%     grid on
end
   

