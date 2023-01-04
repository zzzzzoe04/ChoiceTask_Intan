function [bipolar_LFPs, probe_site_mapping] = calculate_bipolar_LFPs(lfp, probe_type)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% re-arrange the rows to reflect the order of LFPs
probe_site_mapping = probe_site_mapping_all_probes(probe_type);

% first, rearrange field potentials so they are sorted from dorsal to
% ventral

sorted_lfps = lfp(probe_site_mapping);
num_lfps = size(lfp, 1);   % assume each row is a recording channel
num_pts = size(lfp, 2);

switch lower(probe_type)
    case 'nn8x8'
        sites_per_column = 8;
    case 'assy156'
        sites_per_column = 16;
    case 'assy236'
        sites_per_column = 16;
end
num_columns = num_lfps / sites_per_column;
num_bipolar_lfps = num_lfps - num_columns;

bipolar_LFPs = zeros(num_bipolar_lfps, num_pts);

for i_sitecol = 1 : num_columns

    start_LFP_row = (i_sitecol - 1) * sites_per_column + 1;
    end_LFP_row = i_sitecol * sites_per_column;

    start_bipolar_row = (i_sitecol-1) * (sites_per_column-1) + 1;
    end_bipolar_row = i_sitecol * (sites_per_column-1);

    bipolar_LFPs(start_bipolar_row:end_bipolar_row, :) = diff(sorted_lfps(start_LFP_row:end_LFP_row, :), 1, 1);

end

end