function intan_to_site_map_ASSY156 = cambridge_probe_site_mapping_156(probe_type)

% INPUTS:
    % probe_type - this current mapping is for the  NeuroNexus H64LP A8x8 probe.
% OUTPUTS:
    % intan_to_site_map - structure containing reorganization of the lfp_amplifier
    % variable ordering each shank from ventral to dorsal

if strcmpi(probe_type, 'ASSY156')
    %this is how the lfp.mat file is organized
    %    lfp_organization = [1:64];
            
    %shank number - organized based on lfp.mat files generated in -processed
    %folders to match the intan_ampflier number; remember Intan_amplifer
    %numbers are 0:63, while matlab (aka .mat files) are 1:64
        intan_amplifier_ASSY156 = [1:17,19:32,63,...% Shank A
        18,33:62, 64]; % Shank B
    
    
% Map sites ventral to dorsal on the NeuroNexus H64LP A8x8 probe.
% THIS SECTION ORDERS THE NN-SITE BASED ON THE ACTUAL AMPLIFIER ORDER FROM
% THE LFP.MAT FILE OR REARRANGE FROM LINE 14-21 ABOVE.
        Cambridge156_order = [39,43,52,56,57,44,64,33,... % Shank B
            49,35,47,63,36,46,61,38,...
            50,54,41,45,59,55,40,51,...
            53,42,60,58,37,62,48,34,...
            5,29,17,2,32,19,9,21,... % Shank A
            10,8,20,12,24,16,14,22,...
            7,3,30,1,31,4,28,18,...
            6,26,27,36,23,11,13,25]; 
  
  intan_to_site_map_ASSY156 = intan_amplifier_ASSY156(Cambridge156_order)';
   % intan_to_site_map = Cambridge156_order';
end