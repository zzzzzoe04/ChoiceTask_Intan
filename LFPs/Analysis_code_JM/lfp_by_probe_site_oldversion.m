% create an lfp_NNsite file
% lfp_original = load('R0372_20201125a_lfp.mat'); - sample line of code to
% load in the lfp_mat file

function lfp_NNsite_order = lfp_by_probe_site_oldversion(lfp_data, probe_type)

% INPUTS - 
%   lfp_fname - num_channels x num_samples array 
%   probe_type - probe type, e.g. NeuroNexus 8x8 array
%
% OUTPUTS -
%   intan_amplifier - m x n array of *_lfp.mat file rearranged by shank #
%   lfp_NNsite_order - m x n array of intan_amplifier array arranged by
%       shank number then NNsite order (with neighboring sites next to each
%       other)

% if isstring(lfp_data)
%     if exist(lfp_data, 'file')
%         lfp = load(lfp_data);
%         lfp = lfp.lfp;
%     else
%         lfp_NNsite_order = [];
%         return
%     end
% else
%     lfp = lfp_data.lfp;
% end

intan_amplifier = lfp_data([49:56,...%shank1, nn sites 1-8
        57:64,...%shank2
        33:35, 37:39, 41:42,...%shank3
        35,40,43:48,...%shank4
        17:22,26,30,...%shank5
        23:25, 27:29, 31:32,...%shank6
        1:8,...%shank7
        9:16],:); %shank8
lfp_NNsite_order = intan_amplifier([2,7,1,8,4,5,3,6,... %shank 1
        10,15,9,16,12,13,11,14,... %shank2
        17,24,18,23,19,22,20,21,...%shank3
        27,25,29,26,30,28,31,32,...%shank4
        40,37,39,35,38,36,34,33,...%shank5
        42,47,41,48,43,46,45,44,...%shank6
        49,56,50,55,51,54,52,53,...%shank7
        57,64,58,63,59,62,60,61], :);  %shank8
end
