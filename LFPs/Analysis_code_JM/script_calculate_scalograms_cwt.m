% calculate many scalograms and average them

[numtrials, numchannels, numevents] = size(event_triggered_lfps);
% numtrials - number of trials in the array pulled out from
%   ChoiceTask_intan_workflow trial structure for a given trial type (e.g.
%   CorrectGo

% numchannels - number of channels/amplifier channels (pulling from the LFP
%   data)

% numevents - number of events pulled based on time e.g. if LFP data is at 
%   Fs = 500 and you pull out [-2 2], there will be 2001 numevents

% create 'if' or 'for' loop to loop through 1:145 (loop through numtrials).
% Then take the mean of numtrials for that channel. Then squeeze that and
% plot it. mean(data,dim)

myData2 = squeeze(mean(event_triggered_lfps, 1)); % sample is mean(data,dim) - we want the mean of the 1st dimension
myData_channel_one = myData2(1,:);
[cfs_mean,f] = cwt(myData_channel_one,'amor',500);

