% script for testing artifact rejection

intan_parent_directory = '\\corexfs.med.umich.edu\SharedX\Neuro-Leventhal\data\ChoiceTask';
rat_xldbfile = 'ProbeSite_Mapping_MATLAB.xlsx';
% summary_xls_dir = 'Z:\data\ChoiceTask\Probe Histology Summary';
summary_xls_dir = '\\corexfs.med.umich.edu\SharedX\Neuro-Leventhal\data\ChoiceTask\Probe Histology Summary';
rat_xldbfile = fullfile(summary_xls_dir, rat_xldbfile);

session_name = 'R0326_20200220a';
ratID = session_name(1:5);
rat_folder = fullfile(intan_parent_directory, ratID);

processed_folder = find_data_folder(ratID, 'processed', intan_parent_directory);

session_dir = fullfile(processed_folder, session_name);

pd_metadata = parse_processed_folder(session_dir);

lfp_fname = strcat(session_name, sprintf('_%s_lfp.mat', lfp_type));
lfp_name = fullfile(session_dir, lfp_fname);

lfp_data = load(lfp_name);

test_line = 1;

detect_LFP_artifacts(lfp_data.lfp(test_line, :), lfp_data.actual_Fs);