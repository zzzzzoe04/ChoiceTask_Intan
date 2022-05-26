% script_extract_power_spectra

intan_choicetask_parent = 'X:\Neuro-Leventhal\data\ChoiceTask';

% loop through all the processed data folders here, load the lfp file
valid_rat_folders = find_processed_folders(intan_choicetask_parent);

for i_ratfolder = 1 : length(valid_rat_folders)
    
    session_folders = valid_rat_folders(i_ratfolder).processed_folders;
    
    for i_sessionfolder = 1 : length(session_folders)
    % extract the ratID and session name from the LFP file
        session_path = session_folders{i_sessionfolder};
        pd_processed_data = parse_processed_folder(session_path);
        ratID = pd_processed_data.ratID;
        session_name = pd_processed_data.session_name;
        
        % create filenames to hold mono- and diff-LFPs
        mono_power_fn = [session_name, '_monopolar_power.mat'];
        mono_power_fn = fullfile(session_path, mono_power_fn);

        diff_power_fn = [session_name, '_diff_power.mat'];
        diff_power_fn = fullfile(session_path, diff_power_fn);l
        
        [power_lfps, f] = extract_power(LFP,Fs);

        power_fn = [session_name, '_monopolar_power.mat'];
        power_fn = fullfile(session_path, power_fn);
        save(power_fn, 'power_lfps', 'f')
        
    end
    
end



% check if this power




%