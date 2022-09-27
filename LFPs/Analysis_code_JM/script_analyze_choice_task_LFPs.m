% probe_mapping_fname = '/Volumes/SharedX/Neuro-Leventhal/data/ChoiceTask/Probe Histology Summary/ProbeSite_Mapping_MATLAB.xlsx';

intan_parent_directory = 'X:\Neuro-Leventhal\data\ChoiceTask';

rats_with_intan_sessions = find_rawdata_folders(intan_parent_directory);

% test_folder = '/Volumes/SharedX/Neuro-Leventhal/data/ChoiceTask/R0327/R0327-rawdata/R0327_20191218a/R0327_20191218_ChVE_191218_140437';
% cd(test_folder);

sessions_to_ignore = {'R0427_20220920_Testing_220920_150255'}; % R0425_20220728a debugging because the intan side was left on for 15 hours; 
% R0427_20220920a does not have an 'info.rhd' file

%%
for i_rat = 1 : length(rats_with_intan_sessions)
    
    intan_folders = rats_with_intan_sessions(i_rat).intan_folders;
    
    for i_sessionfolder = 1 : length(intan_folders)
        rd_metadata = parse_rawdata_folder(intan_folders{i_sessionfolder});
        pd_folder = create_processed_data_folder(rd_metadata, intan_parent_directory);
        
        lfp_fname = fullfile(pd_folder, create_lfp_fname(rd_metadata));
        
        if exist(lfp_fname, 'file')
            continue
        end
        
        session_path = intan_folders{i_sessionfolder};
        pd_processed_data = parse_processed_folder(session_path);
        ratID = pd_processed_data.ratID;
        session_name = pd_processed_data.session_name;
        
        if any(strcmp(session_name, sessions_to_ignore))
            continue
        end
        
        [lfp, actual_Fs] = calculate_NNprobe_monopolar_LFPs(intan_folders{i_sessionfolder}, 500);
        
        save(lfp_fname, 'lfp', 'actual_Fs');
        
    end
    
end
%%