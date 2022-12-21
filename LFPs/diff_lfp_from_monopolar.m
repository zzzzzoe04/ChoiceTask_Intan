function diff_lfps = diff_lfp_from_monopolar(monopolar_ordered_lfp,probe_type)
%UNTITLED8 Summary of this function goes here
% INPUTS
%   monopolar_ordered_lfp: 

num_sites = size(monopolar_ordered_lfp, 1);
switch lower(probe_type)
    case 'nn8x8'
        % assume lfp is ordered such that monopolar_ordered_lfp(1:8,:) is
        % the signal from dorsal to ventral on shank 1,
        % monopolar_ordered_lfp(9:16,:) is the signal from dorsal to
        % ventral on shank 2, etc.

        sites_per_shank = 8;

        
end