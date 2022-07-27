function intan_to_site_map_ASSY236 = cambridge_probe_site_mapping_236(probe_type)

% INPUTS:
    % probe_type - this current mapping is for the  NeuroNexus H64LP A8x8 probe.
% OUTPUTS:
    % intan_to_site_map - structure containing reorganization of the lfp_amplifier
    % variable ordering each shank from ventral to dorsal

if strcmpi(probe_type, 'ASSY236')
    %this is how the lfp.mat file is organized
    %    lfp_organization = [1:64];
            
    %shank number - organized based on lfp.mat files generated in -processed
    %folders to match the intan_ampflier number; remember Intan_amplifer
    %numbers are 0:63, while matlab (aka .mat files) are 1:64
        intan_amplifier_ASSY236 = [1:17,19:32,63,...% Shank A
        18,33:62, 64]; % Shank B
    
    
% Map sites ventral to dorsal on the NeuroNexus H64LP A8x8 probe.
% THIS SECTION ORDERS THE NN-SITE BASED ON THE ACTUAL AMPLIFIER ORDER FROM
% THE LFP.MAT FILE OR REARRANGE FROM LINE 14-21 ABOVE.
        Cambridge236_order = [63,62,39,47,36,61,33,57,...
            49,41,51,34,37,59,46,54,...
            40,52,56,60,43,38,55,42,...
            45,64,50,35,53,44,58,48,...
            12,13,8,30,32,16,15,6,...
            27,20,5,26,4,21,9,1,...
            29,19,14,28,24,31,22,7,...
            18,10,2,23,3,17,25,11];  %shank8
    
   intan_to_site_map_ASSY236 = intan_amplifier_ASSY236(Cambridge236_order)';
end