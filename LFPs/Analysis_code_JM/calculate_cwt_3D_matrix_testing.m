% calculate_cwt_3D_matrix_testing.m

eventlist = {'nosein','cueon','noseout', 'sidein', 'sideout', 'foodretrievel'};
num_events = length(eventlist);

pts_per_event = size(event_triggered_lfps,3);
num_channels = size(event_triggered_lfps,2);
num_trials = size(event_triggered_lfps, 1);

flim = [1, 100];
fb = cwtfilterbank('SignalLength', pts_per_event, ...
    'SamplingFrequency', Fs, ...
    'FrequencyLimits',flim, ...
    'Wavelet', 'amor');
f = centerFrequencies(fb);
num_freqs = length(f);
t = linspace(-2,2,2001);

% at this point, event_triggered_lfps_ordered is an m x n x p array where
% m is the number of events (i.e., all the cueon OR nosein OR other...
% events) in a single session; n is the number of channels in that session
% (generally 64), and p is the number of time samples extracted around each
% event (i.e., p = 2001 if we extract +/- 2 seconds around each event).

% session_scalos = zeros(num_events, num_channels, num_trials, length(f), pts_per_event);
% in the above, num_events should be the number of DIFFERENT events you're
% interested in (i.e., cueon AND nose in AND others...)
session_scalos = zeros(num_channels, num_trials, length(f), pts_per_event);

for i_event = 1 : num_events
    % write code here to get event_triggered_lfps_ordered for each separate
    % event
    for i_channel = 1 : num_channels

        channel_lfps = squeeze(event_triggered_lfps(:, i_channel, :));

        [scalos, f] = calculate_single_channel_event_triggered_scalograms(channel_lfps, fb);
        session_scalos(i_event, :, :, :) = scalos; % does this need to be rewritten? Scalos is channels, trials, length, pts per event
        % session_scalos = scalos;
        
        % test that the scalogram looks reasonable; comment out for batch
        % processing
        figure(1)

        mean_scalogram = squeeze(mean(abs(scalos), 1));

        imagesc(t, f, mean_scalogram)
        set(gca,'ydir','normal','yscale','log','ylim',flim)

    end
    % you might want to create a separate file for each event and save
    % session_scalos here if it's too big with all the events and all the
    % channels in one file
    save(fname, 'session_scalos', 'Fs', 'f')
end

% now still have to write scalos either into another array for storage, or
% write to disk
