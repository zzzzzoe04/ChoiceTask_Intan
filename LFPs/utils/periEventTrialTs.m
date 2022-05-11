function trialRanges = periEventTrialTs(trials,tWindow,eventFieldnames)
%
%
% INPUTS
%   trials - trials structure
%   tWindow - two-element array containng length of time (in seconds)
%       before and after each event to extract. Note that both numbers
%       should be positive
%   eventFieldnames - length of event fields for which to extract time
%       windows
%
% OUTPUTS
%   trialRanges - m x n x 2 array, where m is the number of fields being
%       analyzed, n is the number of trials, and the last two elements
%       contain the start and end time for each window

trialRanges = NaN(numel(eventFieldnames),numel(trials),2);
for iField = 1:numel(eventFieldnames)
    for iTrial = 1:numel(trials)
        try
            centerTs = getfield(trials(iTrial).timestamps,eventFieldnames{iField});
            trialRanges(iField,iTrial,1) = centerTs - tWindow;
            trialRanges(iField,iTrial,2) = centerTs + tWindow;
        catch
            % do nothing, filled with NaN
        end
    end
end