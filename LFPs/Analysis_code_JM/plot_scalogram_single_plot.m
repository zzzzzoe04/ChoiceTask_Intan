% calculate many scalograms and average them

% [numtrials, numchannels, numevents] = size(event_triggered_lfps);
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

plot_scalogram = plot_scalogram_single_plot_B;
%       monopolar_fname - filename of the file to plot

% OUTPUTS
%       cfs_mean - m x n array of monopolar power
%       f - 

% [cfs_mean,f] = cwt(myData_channel_one,'amor',500);

naming_convention; %  This needs to be changed based on probe type
% Shouldn't we have a line about probe_site_mapping somewhere here? Or how
% does the code below account  for probe site mapping?

figure;

time = linspace(-2,2,2001); % time (x-axis)
Fs = 500;
f = flip(linspace(0,60,81))'; % frequency (y-axis); writing it this way allows for the high frequencies to actually plot correctly

% ts = 10;
% sample_limits = (ts + t_win) * Fs;
% % lfp_to_plot = power_lfps(:, round(sample_limits(1):sample_limits(2))); % used the round feature because the error "integer operands are required
% % for colon operator when used as an index" came up. Round seemed like a solid fix?

num_rows = size(myData2, 1);
num_points = size(myData2,2);
y_lim = f;
x_lim = time;

% Plot the data
LFPs_per_shank = num_rows / 8;   % will be 8 for 64 channels, 7 for 56 channels (diff)
for i_row = 1 : num_rows

    plot_col = ceil(i_row / LFPs_per_shank);
    plot_row = i_row - LFPs_per_shank * (plot_col-1);
    plot_num = (plot_row-1) * 8 + plot_col;
    
    subplot(LFPs_per_shank,8,plot_num);
    plot_scalogram = surface(time,f, 10*log10(abs(cfs_mean(i_row, :)))); % Dan suggested plotting the log so trying here
    % surface(time,f,abs(cfs_mean))
    set(gca,'xlim', x_lim, 'ylim',y_lim);
    grid on
    caption = sprintf('ASSY236 #%d', ASSY236_order(i_row)); % Make a catch so this doesn't need to be edited every graph
    %caption = sprintf('NNsite #%d', NNsite_order(i_row)); % using naming_convention for monopolar plot captions (naming_convention_diffs for diffs plot)
    title(caption, 'FontSize', 8);
    title('Signal and Scalogram')
    
    if plot_row < LFPs_per_shank
        set(gca,'xticklabels',[])
    end
    
    if plot_col > 1
        set(gca,'yticklabels',[])
    end
end