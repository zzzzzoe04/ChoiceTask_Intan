function [unitBehavior, event_idx]  = test_peths(unit_struct, trial_ts)
% INPUTS
%   sClust - matrix for each neuron, could be for each channel
%   trial_ts - trial_ts is an m x n array where m is num_trials and n is
%       samples. This is generated looking for a specific time of the trial
%       structure (e.g. correct trials). Units should be seconds
%
% OUTPUTS
%   unitBehavior - cell array of vectors containing peri-event timestamps
%   event_idx = cell array of vectors containing the index of the event
%       around which unitBehavior is calculated (for example, if
%       unitBehavior is [-0.5, 0.1, 0.5, -0.6] and event_idx is [1, 1, 1,
%       2], that would mean the first 3 timestamps are around the first
%       event in the recording and the last timestamp (-0.6) is from the
%       second event. unitBehavior and event_idx can be input to 
%       plotSpikeRaster_color as xPoints and yPoints, respectively

% This code assumes spike times and behavior initiation times in ms
pre=3; % in seconds
post=3; 
% pre (before the behavior of interest), post (after the behavior of interest), and bw (bin width) are all in milliseconds
binW=0.050;   % in seconds

trial_ts = sort(trial_ts);
pethEntries=[];
event_num = [];
num_units = length(unit_struct);
num_hist_bins = 1 + (pre + post) / binW;
unit_peths = zeros(num_units, num_hist_bins);
unitBehavior = cell(num_units, 1);
event_idx = cell(num_units, 1);
for iUnit=1:length(unit_struct) % matrix for each neuron, could be for each channel
    unit_spike_times = unit_struct(iUnit).ts;% spike times for each unit
    unitBehavior{iUnit}=[]; % matrix of this unit's behavior-related activity

    i_event = 0;
    for bt=trial_ts %for each behavior instance; I think trial_ts is an m x n array where m is num_trials and n is samples. Is this relative to trial start or each event?
        ts_to_append = unit_spike_times(unit_spike_times>(bt-pre) & unit_spike_times<(bt+post))-bt;

        % make sure ts_to_append is a row vector
        if iscolumn(ts_to_append)
            ts_to_append = ts_to_append';
        end

        % thisN=[thisN, nt(nt>bt-pre & nt<bt+post)-bt];
        unitBehavior{iUnit}=[unitBehavior{iUnit}, ts_to_append];   % should be peri-event timestamps in a single vector
        num_points = length(ts_to_append);           % number of timestamps being appended on this iteration
        i_event = i_event + 1;
        event_idx{iUnit} = [event_idx{iUnit}, ones(1, num_points) * i_event];
    end
    
%     thisH=hist(unitBehavior, -pre:binW:post)./(length(trial_ts)); % vector that holds a trial averaged histogram, trial_ts is controlling for trial count
%     unit_peths(iUnit, :)=thisH/(binW); % matrix that holds the trial-averaged histograms for each unit, adjusted to Hz
end
% figure;
% imagesc(unit_peths);colorbar;
% figure
% plot(unit_peths(end,:))


% nn is a matrix of spike times (columns) and units (rows)
% n1 is an iterator
% nt is the activity (spike times) of a given unit
% thisN is a matrix of this unit's behavior-related activity
% bt is an iterator
% st is a vector of behavior start times
% thisH is a vector that holds a trial-averaged histogram
% thisBresponse is a matrix that holds the trial-averaged histograms for each unit