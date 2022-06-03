% fxn to plot '*_monopolar_power.mat' files by shank
% lfp_NNsite_order, NNsite_order = lfp_by_probe_site(lfp_fname, probe_type);
% [power_lfps, f] = extract_power(LFP,Fs);


figure;
% plot(f, 10*log10(power_lfps(:,1)))

% edit the following to match line 7 but in subplotting format
t_win = [0 3600];
Fs = 500;

ts = 10;
sample_limits = (ts + t_win) * Fs;
% lfp_to_plot = power_lfps(:, round(sample_limits(1):sample_limits(2))); % used the round feature because the error "integer operands are required
% for colon operator when used as an index" came up. Round seemed like a solid fix?

num_rows = size(power_lfps, 1);
num_points = size(power_lfps,2);
t = linspace(t_win(1), t_win(2), size(power_lfps, 2));
 y_lim = [0, 150000];
 x_lim = [0 150];

% a = figure;

% p = tiledlayout(8,8);
LFPs_per_shank = num_rows / 8;   % will be 8 for 64 channels, 7 for 56 channels (diff)
for i_row = 1 : num_rows
    % subplot(8,8,i_row);
%     nexttile(p);
    plot_col = ceil(i_row / LFPs_per_shank);
    plot_row = i_row - LFPs_per_shank * (plot_col-1);
    plot_num = (plot_row-1) * 8 + plot_col;
    
    subplot(LFPs_per_shank,8,plot_num);
    plot(f, power_lfps(i_row, :));
    set(gca,'xlim', x_lim, 'ylim',y_lim);
    grid on
    caption = sprintf('NNsite #%d', NNsite_order(i_row)); % This names the channels 1 - 64; need to rename this section ...
    % so it names each one according to the actual NNsite mapping
    title(caption, 'FontSize', 15);
    %nexttile(p);
end
