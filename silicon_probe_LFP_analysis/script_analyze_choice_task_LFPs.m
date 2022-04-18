probe_mapping_fname = '/Volumes/SharedX/Neuro-Leventhal/data/ChoiceTask/Probe Histology Summary/ProbeSite_Mapping.xlsx';

intan_parent_directory = '/Volumes/SharedX/Neuro-Leventhal/data/ChoiceTask/';

test_folder = '/Volumes/SharedX/Neuro-Leventhal/data/ChoiceTask/R0327/R0327-rawdata/R0327_20191218a/R0327_20191218_ChVE_191218_140437';
cd(test_folder);

[lfp, actual_Fs] = calculate_NNprobe_monopolar_LFPs(test_folder, 500);

% lfp_name = 
probe_anatomy_info = read_probe_mapping_xls(probe_mapping_fname)