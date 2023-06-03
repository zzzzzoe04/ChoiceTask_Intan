function [unitBehavior, event_idx, pethEntries]  = ATH_JM_peths(unit_struct, trial_ts)
% creating Alex's as a function

% INPUTS
%   unit_struct - matrix for each neuron, could be for each channel
%   trial_ts - trial_ts is an m x n array where m is num_trials and n is
%       samples. This is generated looking for a specific time of the trial
%       structure (e.g. correct trials). Units should be seconds
%
% OUTPUTS
%   unitBehavior - vector containing peri-event timestamps
%   event_idx = cell array of vectors containing the index of the event
%       around which unitBehavior is calculated (for example, if
%       unitBehavior is [-0.5, 0.1, 0.5, -0.6] and event_idx is [1, 1, 1,
%       2], that would mean the first 3 timestamps are around the first
%       event in the recording and the last timestamp (-0.6) is from the
%       second event. unitBehavior and event_idx can be input to 
%       plotSpikeRaster_color as xPoints and yPoints, respectively


pre=3;
post=3;
binW=0.050;
pethEntries=[];
% unitBehavior = cell(num_units, 1); % Jen you added this in
byUnit_Spikes4raster=struct('trial',[],'spike_times',[]);
num_units = length(unit_struct);
event_idx = cell(num_units, 1);
for iUnit=1:length(unit_struct) % matrix for each neuron, could be for each channel
    unit_spike_times = unit_struct(iUnit).ts;% spike times for each unit
    unitBehavior=[]; % matrix of this unit's behavior-related activity
    %unitBehavior=nan(length(-pre:binW:post),length(trial_ts));
    %yPoints=[];
    i_event=1;
    byUnit_Spikes4raster(iUnit).trial=[];
    byUnit_Spikes4raster(iUnit).spike_times=[];
    for bt=trial_ts %for each behavior instance; I think trial_ts is an m x n array where m is num_trials and n is samples. Is this relative to trial start or each event?
        ts_to_append = unit_spike_times(unit_spike_times>(bt-pre) & unit_spike_times<(bt+post))-bt;
        % thisN=[thisN, nt(nt>bt-pre & nt<bt+post)-bt];
        unitBehavior=[unitBehavior; ts_to_append];   % should be peri-event timestamps in a single vector
        %unitBehavior(:,ii)=ts_to_append;
        num_points = length(ts_to_append);           % number of timestamps being appended on this iteration
        byUnit_Spikes4raster(iUnit).trial=[byUnit_Spikes4raster(iUnit).trial;i_event];%This is totally unneccessary, but it's there for you
        %The line below creates Bst (binary spike times) based on pre and
        %post with 1ms resolution. This is what you can use to make rasters
        Bst=ismember(-pre*1000:post*1000, round(ts_to_append*1000));
        byUnit_Spikes4raster(iUnit).spike_times=[byUnit_Spikes4raster(iUnit).spike_times;Bst];
        i_event=i_event+1;
        event_idx{iUnit} = [event_idx{iUnit}, ones(1, num_points) * i_event];
    end
    thisH=hist(unitBehavior, -pre:binW:post)./(length(trial_ts)); % vector that holds a trial averaged histogram, trial_ts is controlling for trial count
    pethEntries=[pethEntries; thisH*(1000/binW)]; % matrix that holds the trial-averaged histograms for each unit, adjusted to Hz
end
% %Heatmap
% figure;imagesc(zscore(pethEntries')');colorbar;
% %individual unit peths
% figure;
% for iUnit=1:size(pethEntries,1)
%     subplot(5,8,iUnit),plot(pethEntries(iUnit,:));ylabel('Fr (Hz)');xlabel('Time (bins)');title(['Unit ',char(string(iUnit))]);
% end
% %rasters
% figure;
% for iUnit=1:length(byUnit_Spikes4raster)
%     subplot(5,8,iUnit),imagesc(abs(1-byUnit_Spikes4raster(iUnit).spike_times));colormap('bone');
%     ylabel('trial');xlabel('Time (3001=event)');title(['Unit ',char(string(iUnit))]);
% end