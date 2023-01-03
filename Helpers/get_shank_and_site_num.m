function [shank_num,site_num] = get_shank_and_site_num(probe_type, row_idx)
%UNTITLED7 Summary of this function goes here
% INPUTS
%   row_idx = the index of the row in the ordered_lfp array. It should be
%       ordered such that we start at shank 1, most dorsal site, then go
%       down the shank to site 8 (most ventral sitefor an NN8x8), then 
%       shank 2 running from dorsal to ventral, etc.
%   Detailed explanation goes here

switch lower(probe_type)
    case 'nn8x8_monopolar'
        % 8 shanks with 8 sites each
        shank_num = ceil(row_idx / 8);
        site_num = row_idx - (shank_num-1) * 8;

    case 'nn8x8_bipolar'
        % 8 shanks with 7 sites each (bipolar configuration for adjacent
        % sites)
        shank_num = ceil(row_idx / 7);
        site_num = row_idx - (shank_num-1) * 7;

    case 'assy156_monopolar'


    case 'assy156_bipolar'
end