% try plotting channel 1 of a lfp_NNsite file for the first correctgo trial for eventFieldnames cueOn and centerIn of the data
% trialRanges_final(1:2,1); - [row, column]
t_win = trialRanges_final(3:4,1);
Fs = 500;

ts = 10;
sample_limits = (ts + t_win) * Fs;

lfp_to_plot = lfp_NNsite_order(:, ceil(sample_limits(1):sample_limits(2))); %used the round feature because the error "integer operands are required
% for colon operator when used as an index" came up. Round seemed like a solid fix?
nrows = size(lfp_to_plot, 1);
t = linspace(t_win(1), t_win(2), size(lfp_to_plot, 2));
y_lim = [-2000,2000];

figure;

for i_row = 1 : nrows
    subplot(8,8,i_row);
    plot(t, lfp_to_plot(i_row, :));
    set(gca,'xlim', t_win, 'ylim',y_lim);
end

% figure;
% subplot(8,1,1);
% plot(lfp_NNsite_order(1, 25539.15:27539.15));
% set(gca,'xlim', [0 80000], 'ylim',[-2000 2000]);
% hold on
% 
% subplot(8,1,2);
% plot(lfp_NNsite_order(2, 415093:495093));
% set(gca,'xlim', [0 80000], 'ylim',[-2000 2000]);
% 
% subplot(8,1,3);
% plot(lfp_NNsite_order(3, 415093:495093));
% set(gca,'xlim', [0 80000], 'ylim',[-2000 2000]);
% 
% subplot(8,1,4);
% plot(lfp_NNsite_order(4, 415093:495093));
% set(gca,'xlim', [0 80000], 'ylim',[-2000 2000]);
% 
% subplot(8,1,5);
% plot(lfp_NNsite_order(5, 415093:495093));
% set(gca,'xlim', [0 80000], 'ylim',[-2000 2000]);
% 
% subplot(8,1,6);
% plot(lfp_NNsite_order(6, 415093:495093));
% set(gca,'xlim', [0 80000], 'ylim',[-2000 2000]);
% 
% subplot(8,1,7);
% plot(lfp_NNsite_order(7, 415093:495093));
% set(gca,'xlim', [0 80000], 'ylim',[-2000 2000]);
% 
% subplot(8,1,8);
% plot(lfp_NNsite_order(7, 415093:495093));
% set(gca,'xlim', [0 80000], 'ylim',[-2000 2000]);
% 
% hold off
% 
% 
% figure;
% subplot(7,1,1);
% plot(lfp_NNsite_diff(1, 415093:495093));
% set(gca,'xlim', [0 80000], 'ylim',[-1000 1000]);
% hold on
% 
% subplot(7,1,2);
% plot(lfp_NNsite_diff(2, 415093:495093));
% set(gca,'xlim', [0 80000], 'ylim',[-1000 1000]);
% 
% subplot(7,1,3);
% plot(lfp_NNsite_diff(3, 415093:495093));
% set(gca,'xlim', [0 80000], 'ylim',[-1000 1000]);
% 
% subplot(7,1,4);
% plot(lfp_NNsite_diff(4, 415093:495093));
% set(gca,'xlim', [0 80000], 'ylim',[-1000 1000]);
% 
% subplot(7,1,5);
% plot(lfp_NNsite_diff(5, 415093:495093));
% set(gca,'xlim', [0 80000], 'ylim',[-1000 1000]);
% 
% subplot(7,1,6);
% plot(lfp_NNsite_diff(6, 415093:495093));
% set(gca,'xlim', [0 80000], 'ylim',[-1000 1000]);
% 
% subplot(7,1,7);
% plot(lfp_NNsite_diff(7, 415093:495093));
% set(gca,'xlim', [0 80000], 'ylim',[-1000 1000]);
% 
% hold off