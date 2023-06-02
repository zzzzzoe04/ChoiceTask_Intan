function plotSpikeRaster_color(unitBehavior,event_idx,groups,colors,figPos,markerSize)
% INPUTS
%   xPoints (unitBehavior) - vector of x coordinates at which to put a raster mark
%       (timestamps relative to a behavioral event for an entire session)
%   yPoints (event_idx) - vector of y coordinates at which to put a raster mark
%       xPoints and yPoints should have the same length, and xPoints(1)
%       goes with yPoints(1), xPoints(2)-->yPoints(2), etc.
%       the unique values of yPoints indicates a single trial, so all
%       indicates of yPoints with the same value can be used to find
%       xPoints that go with them, and plot them all the same color along
%       the same row
%       yPoints should be integers representing trial #'s (i.e., 1, 2, 3,
%       ...)
%   groups - vector containing num_trials (number of unique yPoints) list
%       integers, with each integer representing a different group (for
%       example, maybe 1 - leftward movement, 2-rightward movement, then
%       they will show up as different colors in the raster
%   colors - vector of colors corresponding to groups (i.e., colors(1) is
%       the color that all members of group 1 will be plotted)
%   figPos - figure position
%   markerSize - size of the marker to use for each raster point


% % if numel(xPoints) ~= numel(yPoints) || numel(unique(yPoints)) ~= numel(groups) ||...
% %         numel(unique(groups)) ~= size(colors,1)
% %     error('check input dimensions');
% % end

yPoints_unique = unique(event_idx);

if ~isempty(figPos)
    figure('position',figPos);
end
for iTrial = 1:numel(unique(event_idx))
    cur_y = yPoints_unique(iTrial);
    pointIdxs = find(event_idx == cur_y);
    plot(unitBehavior(pointIdxs),event_idx(pointIdxs),'.','color',colors(groups(iTrial) == unique(groups),:),'markerSize',markerSize);
    hold on;
end
ylim([1 numel(unique(event_idx))]);
set(gca,'ydir','reverse');
if ~isempty(figPos)
    xlabel('time (s)');
    ylabel('trials');
end