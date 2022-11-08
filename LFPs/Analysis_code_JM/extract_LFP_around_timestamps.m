function event_triggered_lfps = extract_LFP_around_timestamps(ordered_lfp, trial_ts, t_win, Fs)

% INPUTS
%   LFP_fname - filename of the LFP file
%   ts - vector of timestamps. NOT an array of time ranges
%   t_win - 2-element vector with start and end time for each event
%   Fs - sampling rate in Hz
%
% OUTPUTS
%   event_triggered_lfps - num_events x num_channels x samples_per_event
%       containing lfp snips

% LFP_data = load(LFP_fname); grandfathered code when needing to load data
% in from fname
% LFP = LFP_data.ordered_lfp;

num_channels = size(ordered_lfp, 1);
num_samples = size(ordered_lfp, 2);
max_t = Fs * num_samples;
valid_ts = trial_ts(trial_ts > -t_win(1));
valid_ts = valid_ts(valid_ts < max_t - t_win(2));

num_events = length(valid_ts);
samples_per_event = range(t_win) * Fs + 1; 

event_triggered_lfps = zeros(num_events, num_channels, samples_per_event);

for i_ts = 1 : num_events
    
    start_sample = floor(trial_ts(i_ts) * Fs);
    end_sample = start_sample + samples_per_event - 1;
    
%     try
    current_lfp = ordered_lfp(:, start_sample:end_sample); % changed LFP to ordered_lfp for the calculate_cwt_3D_matrix script
%     catch
%         keyboard;
%     end
    
    event_triggered_lfps(i_ts, :, :) = current_lfp;
    
end

% mean_lfp = mean(event_triggered_lfps, 1);
    