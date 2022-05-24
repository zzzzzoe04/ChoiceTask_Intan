% Plot spectral density (pWelch) of all 64 channels in an NN8x8 probe in a single graph

function power_lfps = extract_power(LFP,Fs)

% INPUTS
%   LFP - num_channels x num_samples array
%   Fs - sampling rate in Hz
%
% OUTPUTS
%   power_lfps - array containing power analysis

Fs = 500;
t_win = [0 3600];

ts = 10;
sample_limits = (ts + t_win) * Fs;
lfp_to_plot = pwelch('lfp_NNsite_order', Fs);
% lfp_to_plot = lfp_NNsite_order(:, round(sample_limits(1):sample_limits(2))); % used the round feature because the error "integer operands are required
% for colon operator when used as an index" came up. Round seemed like a solid fix?

rows = size(lfp_to_plot, 1);
t = linspace(t_win(1), t_win(2), size(lfp_to_plot, 2));
y_lim = [-2000,2000];

figure;

for i_row = 1 : rows
    subplot(8,8,i_row);
    plot(t, lfp_to_plot(i_row, :));
    set(gca,'xlim', t_win, 'ylim',y_lim);
    grid on
    caption = sprintf('NNsite #%d', i_row); % This names the channels 1 - 64; need to rename this section ...
    % so it names each one according to the actual NNsite mapping
    title(caption, 'FontSize', 15);
 end
