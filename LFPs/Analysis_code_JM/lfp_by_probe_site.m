% create an lfp_NNsite file
% lfp_original = load('R0372_20201125a_lfp.mat'); - sample line of code to
% load in the lfp_mat file

function [ordered_lfp, intan_site_order, NNsite_order] = lfp_by_probe_site(lfp, probe_type)
%
% This function rearranges an lfp matrix to be in the order of recording
% sites on each shank (ventral to dorsal)
%
% INPUTS - 
%   lfp - num_sites x num_points array containing the original lfp data 
%       ordered as recorded in the amplifier.dat file.
%   probe_type - probe type
%       'NN8x8' - Neuronexus 8x8 array
%       OTHER PROBE TYPE LABELS GO HERE
%
% OUTPUTS -
%   ordered_lfp - m x n array of *_lfp.mat file rearranged by shank #
%       and site # along the shank. That is, first 8 rows should be the 
%       lfp at each site on shank 1, ordered from ventral to dorsal
%   intan_site_order - order of electrode sites by shank from ventral to
%       dorsal. That is, the first 8 elements are the shank 1 sites from
%       ventral to dorsal, indicating which row of the original LFP file is
%       at each site
%   NNsite_order - order of NeuroNexus sites for each shank. Note this is
%       DIFFERENT from the intan order (see
%       https://www.neuronexus.com/files/probemapping/64-channel/H64LP-Maps.pdf)

if strcmpi(probe_type, 'nn8x8')
    
    intan_amplifier = lfp([49:56,...%shank1, nn sites 1-8
            57:64,...%shank2
            33:35, 37:39, 41:42,...%shank3
            35,40,43:48,...%shank4
            17:22,26,30,...%shank5
            23:25, 27:29, 31:32,...%shank6
            1:8,...%shank7
            9:16],:); %shank8
    intan_site_order = [2,7,1,8,4,5,3,6,... %shank 1
            10,15,9,16,12,13,11,14,... %shank2
            17,24,18,23,19,22,20,21,...%shank3
            27,25,29,26,30,28,31,32,...%shank4
            40,37,39,35,38,36,34,33,...%shank5
            42,47,41,48,43,46,45,44,...%shank6
            49,56,50,55,51,54,52,53,...%shank7
            57,64,58,63,59,62,60,61];
    NNsite_order = [
                   ];
           
end

ordered_lfp = intan_amplifier(intan_site_order, :);  %shank8
% lfp_NNsite_order = intan_amplifier([2,7,1,8,4,5,3,6,... %shank 1
%         10,15,9,16,12,13,11,14,... %shank2
%         17,24,18,23,19,22,20,21,...%shank3
%         27,25,29,26,30,28,31,32,...%shank4
%         40,37,39,35,38,36,34,33,...%shank5
%         42,47,41,48,43,46,45,44,...%shank6
%         49,56,50,55,51,54,52,53,...%shank7
%         57,64,58,63,59,62,60,61], :);  %shank8
end
