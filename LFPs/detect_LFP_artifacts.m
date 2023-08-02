function artifact_bool = detect_LFP_artifacts(lfp_data, probe_type, varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

hilbert_width_time = 1;   % in seconds
artifact_padding_time = 0.5;   % in seconds
microvolt_conversion_factor = 0.195;
zthresh = 10;

for iarg = 1 : 2 : nargin - 2
    switch lower(varargin{iarg})

    end
end

if ~lfp_data.convert_to_microvolts
    lfp = lfp_data.lfp * microvolt_conversion_factor;
else
    lfp = lfp_data.lfp;
end
probe_site_mapping = probe_site_mapping_all_probes(probe_type);

num_samples = size(lfp, 2);
num_channels = size(lfp, 1);
hilbert_width_samples = hilbert_width_time * lfp_data.actual_Fs;
artifact_padding_samples = artifact_padding_time * lfp_data.actual_Fs;

% sort LFPs according to probe geometry and take transpose so operations
% can be run column-wise
sorted_lfps = lfp(probe_site_mapping, :)';

% calculate hilbert transform to get analytic signal and amplitude envelope
% of signal on each channel
lfps_envelope = envelope(sorted_lfps, hilbert_width_samples);
envelope_zscore = zscore(lfps_envelope);

% in fieldtrip toolbox, mean is taken by dividing by square root of number
% of channels
channel_mean = sum(envelope_zscore, 2) / sqrt(num_channels);

boolvec = channel_mean > zthresh;
artifact_pts = find(boolvec);

% pad the threshold crossing
artifact_bool = false(num_samples, 1);

for i_art = 1 : length(artifact_pts)

    pad_start = max(1, artifact_pts(i_art) - artifact_padding_samples);
    pad_end = min(artifact_pts(i_art) + artifact_padding_samples, num_samples);

    cur_bool = false(num_samples, 1);
    cur_bool(pad_start:pad_end) = true;

    artifact_bool = artifact_bool | cur_bool;

end

end

