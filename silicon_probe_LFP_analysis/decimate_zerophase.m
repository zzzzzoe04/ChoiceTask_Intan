function decimated_signal = decimate_zerophase(data, r, n)

% uses an FIR filter (designed using fir1) to perform anti-aliasing filter
% before downsampling. Unlike the matlab decimate function, which filters
% in only one direction, this function uses filtfilt to eliminate phase
% distortion

% create an fir filter of order n with cutoff frequency 1/r
b = fir1(n, 1/r);

filtered_data = filtfilt(b, 1, data);

decimated_signal = downsample(filtered_data, r);