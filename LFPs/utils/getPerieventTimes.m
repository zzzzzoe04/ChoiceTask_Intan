function trialTimes = getPerieventTimes(trials,eventFieldnames,refEvent)
%
% INPUTS
%   trials - trials structure
%   eventFieldNames - field names of all possible events
%   refEvent - reference event to compare other events against
%
% OUTPUTS
%   trialTimes - m x n array, where m is the number of trials, and n is the
%       total number of events. Contains the time differences between each
%       event and the reference event

trialTimes = [];
for iTrial = 1:size(trials,2)
    timestamps = trials(iTrial).timestamps;
    refTime = getfield(timestamps,eventFieldnames{refEvent});
    for iEvent = 1:7
        trialTimes(iTrial,iEvent) = getfield(timestamps,eventFieldnames{iEvent}) - refTime;
    end
end