function plot_NN_LFP_samples(LFP_file, probe_anatomy_info)

num_figs_per_recording = 10;
figwidth = 25.4;
figheight = 25.4;

t_win = [-2, 2];

if ~exists(LFP_file, 'file')
    error([LFP_file ' not found'])
    return
end

load(LFP_file)
num_samples = size(lfp, 2);
t = linspace(1 / actual_Fs, num_samples / actual_Fs, num_samples);

% find centers of sampling windows to extract LFPs
samp_t = linspace(max(t)/num_figs_per_recording, max(t) - 10, num_figs_per_recording);

% create 8 x 8 figures for LFP snippets
for i_fig = 1 : num_figs_per_recording
    
    [f, ax] = create_subplot_grid(nrows, ncols, figwidth, figheight);
    
    
    
end
end

function [f, ax] = create_plot_grid(nrows, ncols, figwidth, figheight)

f = figure('units', 'centimeters', 'position', [1 1 figwidth, figheight]);

ax = zeros(nrows, ncols);

for i_col = 1 : ncols
    for i_row = 1 : nrows
    
        p = (i_row - 1) * ncols + i_col;
        ax(i_row, i_col) = subplot(nrows, ncols, p);
        
    end
    
end

end