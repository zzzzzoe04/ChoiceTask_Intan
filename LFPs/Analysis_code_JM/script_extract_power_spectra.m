% script_extract_power_spectra

intan_choicetask_parent = 'X:\Neuro-Leventhal\data\ChoiceTask';

% loop through all the processed data folders here, load the lfp file
valid_rat_folders = find_processed_folders(intan_choicetask_parent);
% probe_type = 'NN8x8'; % Need to edit this to reflect different probe types per ratID
Fs = 500;
% lfp_fname = dir(fullfile(intan_choicetask_parent,'**','*_lfp.mat')); % This
% generates a matrix of '*_lfp.mat' filenames

sessions_to_ignore = {'R0378_20210507a', 'R0425_20220728a'}; % R0425_20220728a debugging because the intan side was left on for 15 hours.

for i_ratfolder = 1 : length(valid_rat_folders)
    
    session_folders = valid_rat_folders(i_ratfolder).processed_folders;
    
    for i_sessionfolder = 1 : length(session_folders)
    % extract the ratID and session name from the LFP file
        session_path = session_folders{i_sessionfolder};
        pd_processed_data = parse_processed_folder(session_path);
        ratID = pd_processed_data.ratID;
        session_name = pd_processed_data.session_name;
        
        if any(strcmp(session_name, sessions_to_ignore))
            continue
        end
        
        if ratID == 'R0326'
            probe_type = 'NN8x8'; 
        elseif ratID == 'R0411'
            probe_type = 'ASSY156';
        elseif ratID == 'R0420'
            probe_type = 'ASSY236';
        elseif ratID == 'R0425'
            probe_type = 'ASSY236';
        elseif ratID == 'R0427'
            probe_type = 'ASSY236';
        end

        % create filenames to hold mono- and diff-LFPs
        mono_power_fn = [session_name, '_monopolar_power.mat'];
        mono_power_fn = fullfile(session_path, mono_power_fn);

        diff_power_fn = [session_name, '_diff_power.mat'];
        diff_power_fn = fullfile(session_path, diff_power_fn);
        
        % Might be good to add a check here to see if mono_power_fn and/or diff_power_fn
        % exists, if exists skip reading in the data to save time.
 
        lfp_file = dir(fullfile(session_path, '**', '*_lfp.mat'));
        cd(session_path);
        % lfp = load(lfp_fname.name); % I think the lfp needs to be loaded
        % in the lfp_NNsite_order script in the next line of this fxn.
       
        % LFP file needs to be loaded before the [power_lfps,f] function
        lfp_fname = fullfile(lfp_file.folder, lfp_file.name);
        
        power_fn = [session_name, '_monopolarpower.mat'];
        power_fn = fullfile(session_path, power_fn);
        
        diff_power_fn = [session_name, '_diffpower.mat'];
        diff_power_fn = fullfile(session_path, diff_power_fn);
        
        if exist(power_fn, 'file') && exist(diff_power_fn, 'file')
            continue
        end
        
        lfp_data = load(lfp_fname);
        Fs = lfp_data.actual_Fs;
        
        num_rows = size(lfp_data.lfp,1); % for now, skipping R0378_20210507a because the session only recorded 63 channels instead of 64. Need to rewrite lfp_NNsite_order and diff functions to fix this issue by determining which channel was not recorded. 
        if num_rows < 64
            continue
        end
        
              
        if ~exist(power_fn, 'file')
            [ordered_lfp, intan_site_order, site_order] = lfp_by_probe_site_ALL(lfp_data, probe_type); % lfp_by_probe_site_ALL has the three probe types listed. 
                % Working on changing probe_type to a list of rats with
                % each probe_type so it runs and writes the diff/monopolars
                % correctly
            % lfp_NNsite_order = lfp_by_probe_site(lfp_data, probe_type); % grandfathered code
            [power_lfps, f] = extract_power(ordered_lfp,Fs); % in the original code (LFP, Fs); 
            save(power_fn, 'power_lfps', 'f', 'Fs');
        end
        
        if ~exist(diff_power_fn, 'file')
            % Reorganize by NNsite and calculate the diffs
            lfp_NNsite_diff = diff_probe_site_mapping(lfp_data, probe_type); % calculates diffs
            [power_lfps_diff, f] = extract_power(lfp_NNsite_diff,Fs);
            save(diff_power_fn, 'power_lfps_diff', 'f', 'Fs');
        end
            
    end
    
end