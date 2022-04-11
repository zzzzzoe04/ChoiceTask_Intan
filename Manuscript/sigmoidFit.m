function [fitresult, gof] = sigmoidFit(x,y,doplot)
%CREATEFIT1(X,Y)
%  Create a fit.
%
%  Data for 'sigmoidFit' fit:
%      X Input : x
%      Y Output: y
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 15-Aug-2017 20:13:57


%% Fit: 'sigmoidFit'.
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( 'a+( b-a )./ (1 +10.^((c-x)*d));', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
% opts.StartPoint = [0.2328 0.339736911364496 0.864522166215175 0.472386996496119];
opts.StartPoint = [.2 .2 .8 .8];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
if doplot
    % % figure( 'Name', 'sigmoidFit' );
    h = plot( fitresult, xData, yData );
    hold on;
    legend( h, 'y vs. x', 'sigmoidFit', 'Location', 'NorthEast' );
    % Label axes
    xlabel x
    ylabel y
    grid on
end

