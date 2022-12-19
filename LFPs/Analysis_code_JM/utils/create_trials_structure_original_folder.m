function session_trials_folder_original = create_trials_structure_original_folder(rd_metadata, parent_directory)

trials_folder= strcat(rd_metadata.ratID, '-LFP-trials-structures-original');
session_trials_folder_original = fullfile(parent_directory, rd_metadata.ratID, trials_folder, rd_metadata.session_name);

if ~isfolder(session_trials_folder_original)
    
    mkdir(session_trials_folder_original)
    
end