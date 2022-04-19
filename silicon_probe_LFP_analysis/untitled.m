% script_extract_perievent_LFPs

probe_mapping_fname = '/Volumes/SharedX/Neuro-Leventhal/data/ChoiceTask/Probe Histology Summary/ProbeSite_Mapping.xlsx';

intan_parent_directory = '/Volumes/SharedX/Neuro-Leventhal/data/ChoiceTask/';

rats_with_intan_sessions = find_rawdata_folders(intan_parent_directory);

for i_rat = 1 : length(rats_with_intan_sessions)
    
    intan_folders = rats_with_intan_sessions(i_rat).intan_folders;
    
    for i_sessionfolder = 1 : length(intan_folders)