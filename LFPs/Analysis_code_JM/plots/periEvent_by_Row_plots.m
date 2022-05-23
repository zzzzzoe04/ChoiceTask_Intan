% This file plots all 8 channels in an NN8x8 probe in a single graph with
% each channel as its own row. (e.g. sites 1 - 8 as a single column)

t_win = trialRanges_final(3:4,1);
Fs = 500;

ts = 10;
sample_limits = (ts + t_win) * Fs;
lfp_to_plot = lfp_NNsite_order(:, round(sample_limits(1):sample_limits(2))); % used the round feature because the error "integer operands are required
% for colon operator when used as an index" came up. Round seemed like a solid fix?

rows = size(lfp_to_plot, 1);
t = linspace(t_win(1), t_win(2), size(lfp_to_plot, 2));
y_lim = [-2000,2000];

h = figure;

shank_num = 2;
for i_row = 1 : 8
    subplot(8,1,i_row);
    lfp_row = (shank_num - 1) * 8 + i_row;
    plot(t, lfp_to_plot(lfp_row, :));
    set(gca,'xlim', t_win, 'ylim',y_lim);
    grid on
    caption = sprintf('NNsite #%d', lfp_row); % input mapping file so its in the correct NNsite order (check mapping)
    title(caption, 'FontSize', 15);
end
%save file here as a pdf (print?)
saveas(h, 'R0372_lfp_NNsite_single_row', 'pdf');
close(h);