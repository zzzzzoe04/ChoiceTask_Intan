% fxn to plot '*_monopolar_power.mat' files by shank
% lfp_NNsite_order, NNsite_order = lfp_by_probe_site(lfp_fname, probe_type);
% [power_lfps, f] = extract_power(LFP,Fs);

% intan_choicetask_parent = 'X:\Neuro-Leventhal\data\ChoiceTask';
% ratID = 'R0326';
% direct=dir([ratID '*']);
% numFolders = length(direct);
% parentFolder = fullfile(intan_choicetask_parent, ...
%          ratID, ...
%          [ratID '-rawdata']);
% 
% % load in the log file to create the title for each session?
% logData = readLogData(fname);

figure;
% plot(f, 10*log10(power_lfps(:,1)))

% edit the following to match line 7 but in subplotting format
t_win = [0 3600];
Fs = 500;

ts = 10;
sample_limits = (ts + t_win) * Fs;
% lfp_to_plot = power_lfps(:, round(sample_limits(1):sample_limits(2))); % used the round feature because the error "integer operands are required
% for colon operator when used as an index" came up. Round seemed like a solid fix?

num_rows = size(power_lfps_diff, 1);
num_points = size(power_lfps_diff,2);
t = linspace(t_win(1), t_win(2), size(power_lfps_diff, 2));
 y_lim = [0 1500];
 x_lim = [0 100];

% Plot the data
LFPs_per_shank = num_rows / 7;   % will be 8 for 64 channels, 7 for 56 channels (diff)
for i_row = 1 : num_rows

    plot_col = ceil(i_row / LFPs_per_shank);
    plot_row = i_row - LFPs_per_shank * (plot_col-1);
    plot_num = (plot_row-1) * 7 + plot_col;
    
    subplot(LFPs_per_shank,7,plot_num);
    plot(f, power_lfps_diff(i_row, :));
    set(gca,'xlim', x_lim, 'ylim',y_lim);
    grid on
    caption = sprintf('Diff #%d', NNsite_order_diffs(i_row)); % This names the channels 1 - 64; need to rename this section ...
    % so it names each one according to the actual NNsite mapping
    title(caption, 'FontSize', 10);
    %nexttile(p);
    
    if plot_row < LFPs_per_shank
        set(gca,'xticklabels',[])
    end
    
    if plot_col > 1
        set(gca,'yticklabels',[])
    end
        
end
