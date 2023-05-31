function unit_struct = sort_ts_to_units(spike_clusters, spike_times, Fs)
% INPUTS
%   spike_clusters - npy file read in from kilosort output with cluster IDs
%   spike_times - npy file read in from kilosort output with timestamps for
%       the cluster IDs
%   Fs - sampling frequency in Hz
%
% OUTPUT
%   unit_sruct - array of structures with the following fields:
%       .id - the unit ID from phy
%       .ts - timestamps for that unit in seconds

unit_ids = unique(spike_clusters);
for i_unit = 1 : length(unit_ids)

    unit_struct(i_unit).id = unit_ids(i_unit);
    unit_bools = (spike_clusters == unit_ids(i_unit));
    unit_struct(i_unit).ts = double(spike_times(unit_bools)) / Fs;

end