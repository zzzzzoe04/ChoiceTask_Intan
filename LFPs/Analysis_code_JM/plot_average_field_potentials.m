% calculate average field potentials for a single trial type in a session
% and plot the data.

% trialRanges_final contains the vectors with beginning time point row 1,
% end of the time point row 4 e.g write code as [1 4]. During these time
% points calculate the average of lfp_NNsite_order in a matrix

%should be a 64 column matrix (64 channels).

t_win = trialRanges_final([1 4],:);
Fs = 500;
ts = 10;
sample_limits = (ts + t_win) * Fs;

num_shanks = 8; %number of shanks on NN probe
num_sites = size(lfp, 1);
sites_per_shank = num_sites/num_shanks;
num_lfp_points = size(lfp, 2);
% pre-allocate memory for differential LFPs
num_diff_rows = num_sites - num_shanks;
average_lfps = zeros(num_diff_rows, num_lfp_points); 


extract_data_I_care_about = lfp_NNsite_order(sample_limits);
