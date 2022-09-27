function event_triggered_lfps = extract_event_related_LFPs(LFP_fname, trials, eventname, varargin)

%   LFP_fname - name of the LFP file
%   trials - trials structure
%   eventname - name of event for which to extract timestamps:
%       For a correct trial, eventname options are as follows:
%         cueOn, centerIn, tone, centerOut, sideIn, sideOut, foodClick, foodRetrieval
%         - to find eventFieldnames for non-correct trials, check the
%         timestamps column in the trials structure.
%
% VARARGs:
%   Fs
%   twin


if ~iscell(eventname)
    eventname = {eventname};
end

twin = [-2.5 2.5];
Fs = 500;

for iarg = 1 : 2 : nargin - 3
    switch lower(varargin{iarg})
        case 'fs'
            Fs = varargin{iarg + 1};
        case 'twin'
            twin = varargin{iarg + 1};
    end
end

ts = extract_trial_ts(trials, eventname);

event_triggered_lfps = extract_LFP_around_timestamps(LFP_fname, ts, twin, Fs);
