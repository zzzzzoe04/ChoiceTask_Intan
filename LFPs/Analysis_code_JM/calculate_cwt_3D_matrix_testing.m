% calculate_cwt_3D_matrix_testing.m

P = cd;

% start with an LFP file
% get the trial structure for that session
% run this analysis

eventlist = {'nosein','cueon','noseout', 'sidein', 'sideout', 'foodretrievel'};
num_events = length(eventlist);

pts_per_event = size(event_triggered_lfps,3);
num_channels = size(event_triggered_lfps,2);
num_trials = size(event_triggered_lfps, 1);

flim = [1, 100];
Fs = 500;
t_win = [-2.5 2.5];
fb = cwtfilterbank('SignalLength', pts_per_event, ...
    'SamplingFrequency', Fs, ...
    'FrequencyLimits',flim, ...
    'Wavelet', 'amor');
f = centerFrequencies(fb);
num_freqs = length(f);
t = linspace(t_win(1),t_win(2),pts_per_event);

% at this point, event_triggered_lfps_ordered is an m x n x p array where
% m is the number of events (i.e., all the cueon OR nosein OR other...
% events) in a single session; n is the number of channels in that session
% (generally 64), and p is the number of time samples extracted around each
% event (i.e., p = 2001 if we extract +/- 2 seconds around each event).

% session_scalos = zeros(num_events, num_channels, num_trials, length(f), pts_per_event);
% in the above, num_events should be the number of DIFFERENT events you're
% interested in (i.e., cueon AND nose in AND others...)


% above here, the lfp file, trial structure never change
for i_event = 1 : num_events
    % write code here to get event_triggered_lfps_ordered for each separate
    % event
    
    event_triggered_lfps = extract_event_related_LFPs(LFP_fname, trials, eventlist{i_event}, 'fs', Fs, 'twin', t_win);
    % event_triggered_lfps should be an m x n x p array where m is the
    % number of trials, n is the number of channels, p is the number of
    % time points extracted around each LFP
    
    % get averages saved into a bunch of files
        
    for i_channel = 1 : num_channels

        channel_lfps = squeeze(event_triggered_lfps(:, i_channel, :));

        [scalograms, f] = calculate_single_channel_event_triggered_scalograms(channel_lfps, fb);
        
        % create a file name that includes ratID, session #, chXX,
        % eventname, scalograms
        % for example, 'R0326_20200228a_ch01_cueOn_scalos.mat'
        
        fname = fullfile(data_path, fname);
        
        save(fname, 'scalograms', 'Fs', 'f', 'fb');
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
    G = sprintf('session_scalos%u.mat',i_event);
    save(fullfile(P,G), 'session_scalos', 'Fs', 'f', '-v7.3') % change to fname
    
end

% now still have to write scalos either into another array for storage, or
% write to disk
