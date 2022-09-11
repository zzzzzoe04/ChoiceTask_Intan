% create an lfp_NNsite file
% lfp_original = load('R0372_20201125a_lfp.mat'); - sample line of code to
% load in the lfp_mat file

function [ordered_lfp, intan_site_order, site_order] = lfp_by_probe_site_ALL(lfp_data, probe_type)

% INPUTS - 
%   lfp_data - num_sites x num_points array containing the original lfp data 
%       ordered as recorded in the amplifier.dat file.
%   probe_type - probe type
%       'NN8x8' - Neuronexus 8x8 array
%       'ASSY156' - Cambridge Omnetics Connector H6 style probe 2 shank @ 4 column/shank @ 16 site/column
%       'ASSY236' - Cambridge Molex Connector H6 style probe 2 shank @ 4 column/shank @ 16 site/column
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
%   site_order - order of NeuroNexus sites for each shank. Note this is
%       DIFFERENT from the intan order (see
%       https://www.neuronexus.com/files/probemapping/64-channel/H64LP-Maps.pdf)

lfp_data = load('R0427_20220909_Test_lfp.mat');

if strcmpi(probe_type, 'nn8x8')
    if isstring(lfp_data)
        if exist(lfp_data, 'file')
            lfp = load(lfp_data);
            lfp_data = lfp.lfp;
        else
            intan_site_order = [];
            return
        end
    else
       lfp_data = lfp_data.lfp;
    end

    intan_amplifier = lfp_data([49:56,...%shank1, nn sites 1-8
            57:64,...%shank2
            33:35, 37:39, 41:42,...%shank3
            35,40,43:48,...%shank4
            17:22,26,30,...%shank5
            23:25, 27:29, 31:32,...%shank6
            1:8,...%shank7
            9:16],:); %shank8
    intan_site_order = [2,7,1,8,4,5,3,6,... %shank 1 % This is the postion of the NNsites
            10,15,9,16,12,13,11,14,... %shank2
            17,24,18,23,19,22,20,21,...%shank3
            27,25,29,26,30,28,31,32,...%shank4
            40,37,39,35,38,36,34,33,...%shank5
            42,47,41,48,43,46,45,44,...%shank6
            49,56,50,55,51,54,52,53,...%shank7
            57,64,58,63,59,62,60,61];  %shank8
   site_order = [1,8,2,7,3,6,4,5,...%shank1 % These are literal site numbers for the NN probes
            9,16,10,15,11,14,12,13,...%shank2
            17,24,18,23,19,22,20,21,...%shank3
            25,32,26,31,27,30,28,29,...%shank4
            33,40,34,39,35,38,36,37, ...%shank5
            41,48,42,47,43,46,44,45,...%shank6
            49,56,50,55,51,54,52,53,...%shank7
            57,64,58,63,59,62,60,61]; %shank8
        
ordered_lfp = intan_amplifier(intan_site_order, :);

elseif strcmpi(probe_type, 'ASSY156')
    if isstring(lfp_data)
        if exist(lfp_data, 'file')
            lfp = load(lfp_data);
            lfp_data = lfp.lfp;
        else
            intan_site_order = [];
            return
        end
    else
       lfp_data = lfp_data.lfp;
    end
     intan_amplifier = lfp_data([1:17,19:32,63,...% Shank A
        18,33:62, 64],:); % Shank B
    
     intan_site_order = [39,43,52,56,57,44,64,33,... % Shank B
            49,35,47,63,36,46,61,38,...
            50,54,41,45,59,55,40,51,...
            53,42,60,58,37,62,48,34,...
            5,29,17,2,32,19,9,21,... % Shank A
            10,8,20,12,24,16,14,22,...
            7,3,30,1,31,4,28,18,...
            6,26,27,36,23,11,13,25];
     site_order = [11,7,62,58,57,6,49,31,...
         1,15,3,51,14,4,53,12,...
         64,60,9,5,55,59,10,63,...
         61,8,54,56,13,52,2,16,...
         44,19,32,47,50,29,40,27,...
         39,41,28,37,24,33,35,26,...
         42,46,18,48,17,45,20,30,...
         43,22,21,34,25,38,36,23];
        
ordered_lfp = intan_amplifier(intan_site_order, :);   

elseif strcmpi(probe_type, 'ASSY236')
    if isstring(lfp_data)
        if exist(lfp_data, 'file')
            lfp = load(lfp_data);
            lfp_data = lfp.lfp;
        else
            intan_site_order = [];
            return
        end
    else
       lfp_data = lfp_data.lfp_data;
    end
    intan_amplifier = lfp_data([1:17,19:32,63,...% Shank A
        18,33:62, 64],:); % Shank B
    intan_site_order = [63,62,39,47,36,61,33,57,...
            49,41,51,34,37,59,46,54,...
            40,52,56,60,43,38,55,42,...
            45,64,50,35,53,44,58,48,...
            12,13,8,30,32,16,15,6,...
            27,20,5,26,4,21,9,1,...
            29,19,14,28,24,31,22,7,...
            18,10,2,23,3,17,25,11];  %shank8
    site_order = [50,51,3,17,5,52,8,56,...
        40,22,38,7,23,54,18,34,...
        2,37,33,53,21,4,35,1,...
        19,49,39,6,36,20,55,41,...
        45,44,57,9,24,42,32,59,...
        12,29,60,13,61,16,48,64,...
        11,28,43,25,26,10,27,58,...
        30,46,63,15,62,31,14,47];
    
ordered_lfp = intan_amplifier(intan_site_order, :);
end

end

