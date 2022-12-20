function [outputArg1,outputArg2] = extract_perievent_data(ephys_data, trials, eventname, t_window, Fs)
%UNTITLED2 Summary of this function goes here
% INPUTS
%   ephys_data - num_channels x num_samples array
%   ts - vector of timestamps with times in seconds
%   
%   Detailed explanation goes here

center_samps = round(ts * Fs);
samp_windows = center_samps + t_window;
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end