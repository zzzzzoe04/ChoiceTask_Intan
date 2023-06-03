function trial_ts = extract_trial_ts(trials, eventFieldname)
%
% INPUTS
%   trials - trials structure
%   eventFieldname - name of the event we're interested in
%       For a correct trial, eventFieldnames are as follows:
%         cueOn, centerIn, tone, centerOut, sideIn, sideOut, foodClick, foodRetrieval
%         - to find eventFieldnames for non-correct trials, check the
%         timestamps column in the trials structure.
%
% OUTPUTS
%   trial_ts - vector of timestamps for the given event in this trials
%       structure

trial_ts = NaN(1,numel(trials));
for iTrial = 1:numel(trials)
    try
        ts = getfield(trials(iTrial).timestamps, eventFieldname);
        trial_ts(iTrial) = ts;
    catch
    end
end


% trial_ts = NaN(numel(eventFieldnames),numel(trials));
% for iField = 1:numel(eventFieldnames)
%     for iTrial = 1:numel(trials)
%         try
%             ts = getfield(trials(iTrial).timestamps,eventFieldnames{iField});
%             trial_ts(iField, iTrial) = ts;
%         catch
%             % do nothing, filled with NaN
%         end
%     end
% end