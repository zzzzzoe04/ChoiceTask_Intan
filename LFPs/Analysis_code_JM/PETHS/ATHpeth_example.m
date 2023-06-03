%I load the data that you sent me
spikeTimes=readNPY('spike_times.npy');
spikeClusters=readNPY('spike_clusters.npy');
%%
%Ignore this section, it just makes the structure (as far as I'm aware)that
%Dan wants you to use
units=unique(spikeClusters)';
unit_struct=struct('ts',[]);
ii=1;
for iUnit=units
  unit_struct(ii).ts=double(spikeTimes(spikeClusters==iUnit));
  ii=ii+1;
end
% trial_ts=trial_ts * 1000; % JM deleted this line, not needed as trial_ts
% is already input
%%
%The peth code we've been working on
pre=3;
post=3;
binW=0.050;
pethEntries=[];
% unitBehavior = cell(num_units, 1); % Jen you added this in
byUnit_Spikes4raster=struct('trial',[],'spike_times',[]);
for iUnit=1:length(unit_struct) % matrix for each neuron, could be for each channel
    unit_spike_times = unit_struct(iUnit).ts;% spike times for each unit
    unitBehavior=[]; % matrix of this unit's behavior-related activity
    %unitBehavior=nan(length(-pre:binW:post),length(trial_ts));
    %yPoints=[];
    ii=1;
    byUnit_Spikes4raster(iUnit).trial=[];
    byUnit_Spikes4raster(iUnit).spike_times=[];
    for bt=trial_ts %for each behavior instance; I think trial_ts is an m x n array where m is num_trials and n is samples. Is this relative to trial start or each event?
        ts_to_append = unit_spike_times(unit_spike_times>(bt-pre) & unit_spike_times<(bt+post))-bt;
        % thisN=[thisN, nt(nt>bt-pre & nt<bt+post)-bt];
        unitBehavior=[unitBehavior; ts_to_append];   % should be peri-event timestamps in a single vector
        %unitBehavior(:,ii)=ts_to_append;
        num_points = length(ts_to_append);           % number of timestamps being appended on this iteration
        byUnit_Spikes4raster(iUnit).trial=[byUnit_Spikes4raster(iUnit).trial;ii];%This is totally unneccessary, but it's there for you
        %The line below creates Bst (binary spike times) based on pre and
        %post with 1ms resolution. This is what you can use to make rasters
        Bst=ismember(-pre:post, ts_to_append);
        byUnit_Spikes4raster(iUnit).spike_times=[byUnit_Spikes4raster(iUnit).spike_times;Bst];
        ii=ii+1;
    end
    thisH=hist(unitBehavior, -pre:binW:post)./(length(trial_ts)); % vector that holds a trial averaged histogram, trial_ts is controlling for trial count
    pethEntries=[pethEntries; thisH*(1000/binW)]; % matrix that holds the trial-averaged histograms for each unit, adjusted to Hz
end
%Heatmap
figure;imagesc(zscore(pethEntries')');colorbar;
%individual unit peths
figure;
for iUnit=1:size(pethEntries,1)
    subplot(5,8,iUnit),plot(pethEntries(iUnit,:));ylabel('Fr (Hz)');xlabel('Time (bins)');title(['Unit ',char(string(iUnit))]);
end
%rasters
figure;
for iUnit=1:length(byUnit_Spikes4raster)
    subplot(5,8,iUnit),imagesc(abs(1-byUnit_Spikes4raster(iUnit).spike_times));colormap('bone');
    ylabel('trial');xlabel('Time (3001=event)');title(['Unit ',char(string(iUnit))]);
end