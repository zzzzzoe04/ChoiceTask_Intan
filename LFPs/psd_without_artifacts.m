function [mean_p, f] = psd_without_artifacts(lfp, Fs, valid_ranges)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

num_valid_ranges = size(valid_ranges, 1);

p = zeros(num_valid_ranges, 4096);
for i_range = 1 : num_valid_ranges
    valid_lfp = lfp(valid_ranges(i_range, 1) : valid_ranges(i_range, 2));

    [p(i_range, :), f] = pspectrum(valid_lfp, Fs);

end

mean_p = mean(p, 1);

end