probe_mapping_fname = '/Volumes/SharedX/Neuro-Leventhal/data/ChoiceTask/Probe Histology Summary/ProbeSite_Mapping_MATLAB.xlsx';

intan_parent_directory = '/Volumes/SharedX/Neuro-Leventhal/data/ChoiceTask/';

rats_with_intan_sessions = find_rawdata_folders(intan_parent_directory);

% test_folder = '/Volumes/SharedX/Neuro-Leventhal/data/ChoiceTask/R0327/R0327-rawdata/R0327_20191218a/R0327_20191218_ChVE_191218_140437';
% cd(test_folder);

%%
for i_rat = 1 : length(rats_with_intan_sessions)
    
    intan_folders = rats_with_intan_sessions(i_rat).intan_folders;
    
    for i_sessionfolder = 1 : length(intan_folders)
        rd_metadata = parse_rawdata_folder(intan_folders{i_sessionfolder});
        pd_folder = create_processed_data_folder(rd_metadata, intan_parent_directory);
        
        lfp_fname = fullfile(pd_folder, create_lfp_fname(rd_metadata))
        
        if exist(lfp_fname, 'file')
            continue
        end
        
        [lfp, actual_Fs] = calculate_NNprobe_monopolar_LFPs(intan_folders{i_sessionfolder}, 500);
        
        save(lfp_fname, 'lfp', 'actual_Fs');
        
    end
    
end

%%
% get the sheet names for the probe mapping file

sheets = sheetnames(probe_mapping_fname);
num_sheets = size(sheets, 1);

num_rat_sheets = 0;
for i_sheet = 1 : num_sheets
    
    cur_sheet = char(sheets(i_sheet));
    if cur_sheet(1) == 'R'
        num_rat_sheets = num_rat_sheets + 1;
        rat_sheets{num_rat_sheets} = cur_sheet;
    end
    
end
% lfp_name = 
probe_anatomy_info = read_probe_mapping_xls(probe_mapping_fname, sheetname);

%%