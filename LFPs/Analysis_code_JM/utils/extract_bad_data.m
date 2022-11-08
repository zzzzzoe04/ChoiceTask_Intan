% Run Choice_Task_Workflow
% Run getTrialEventParams.m (allgo)
% Run extractTrials.m
% Create Variable trials_to_run = trials(trIdx)
% load data


threshold = 1500;
excluded_trials = [];

eventFieldnames = {'cueOn'};
t_win = [-2.5 2.5];

for i_event = 1 : num_events
    trial_ts = extract_trial_ts(trials(trIdx), eventFieldnames{i_event});
    event_triggered_lfps = extract_event_related_LFPs(lfp_data, trials(trIdx), eventFieldnames{i_event}, 'fs', Fs, 'twin', t_win); 

end

