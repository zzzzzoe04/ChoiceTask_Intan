% fxn to plot '*_monopolar_power.mat' files by shank
% lfp_NNsite_order = lfp_by_probe_site(lfp_fname, probe_type);
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

 rows = size(power_lfps, 1);
% t = linspace(t_win(1), t_win(2), size(lfp_to_plot, 2));
y_lim = [-2000,2000];
x_lim = [0 250];

shank_num = 1;
for i_row = 1 : 8
    subplot(8,1,i_row);
    plot(f, power_lfps(i_row, :));
    % set(gca,'xlim', t_win, 'ylim',y_lim);
    grid on
    caption = sprintf('NNsite #%d', i_row); % This names the channels 1 - 64; need to rename this section ...
    % so it names each one according to the actual NNsite mapping
    title(caption, 'FontSize', 15);
end

shank_num = 2;
for i_row = 9 : 16
    subplot(8,1,i_row);
    lfp_row = (shank_num - 1) * 8 + i_row;
    plot(f, power_lfps(i_row, :));
    % set(gca,'xlim', t_win, 'ylim',y_lim);
    grid on
    caption = sprintf('NNsite #%d', lfp_row); % input mapping file so its in the correct NNsite order (check mapping)
    title(caption, 'FontSize', 15);
end