function intan_to_site_map = probe_site_mapping(probe_type)

% INPUTS:
    % ratID - string containing the rat ID (e.g., 'R0001'). Should have 5
    %       characters
    % lfp - lfp.mat file read in for a particular session
% OUTPUTS:
    % lfp_amplifier - structure containing reorganization of the lfp.mat
        % file ordering lines by shank number AND amplifier number (lfp.mat is strictly
        % ordered by amplifier number 0-63). lfp_amplifier will be ordered 1-64
    % lfp_NNsite - structure containing reorganization of the lfp_amplifier
        % variable ordering each shank from ventral to dorsal

if strcmpi(probe_type, 'NN8x8')
    %shank number
    intan_amplifier = [49:56,...%shank1, nn sites 1-8
        57:64,...%shank2
        33:35, 37:39, 41:42,...%shank3
        35,40,43:48,...%shank4
        17:22,26,30,...%shank5
        23:25, 27:29, 31:32,...%shank6
        1:8,...%shank7
        9:16]; %shank8

    %Reorganize lfp by NNsite
%     NNsite_order = [2,7,1,8,4,5,3,6,... %shank 1
%         10,15,9,16,12,13,11,14,... %shank2
%         17,24,18,23,19,22,20,21,...%shank3
%         27,25,29,26,30,28,31,32,...%shank4
%         40,37,39,35,38,36,34,33,...%shank5
%         42,47,41,48,43,46,45,44,...%shank6
%         49,56,50,55,51,54,52,53,...%shank7
%         57,64,58,63,59,62,60,61];%shank8
    
        NNsite_order = [1,8,2,7,3,6,4,5,... %shank 1
        9,16,10,15,11,14,12,13,... %shank2
        17,24,18,23,19,22,20,21,...%shank3
        27,25,29,26,30,28,31,32,...%shank4
        40,37,39,35,38,36,34,33,...%shank5
        42,47,41,48,43,46,45,44,...%shank6
        49,56,50,55,51,54,52,53,...%shank7
        57,64,58,63,59,62,60,61];%shank8

    intan_to_site_map = intan_amplifier(NNsite_order);
end

