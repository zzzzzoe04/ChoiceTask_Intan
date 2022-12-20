% script to calculate scalograms for all of Jen's rats; store in files in
% the processed data folders

parent_directory = 'Z:\data\ChoiceTask\';
summary_xls = 'ProbeSite_Mapping_MATLAB.xlsx';
summary_xls_dir = 'Z:\data\ChoiceTask\Probe Histology Summary';
summary_xls = fullfile(summary_xls_dir, summary_xls);

probe_type_sheet = 'probe_type';
probe_types = read_Jen_xls_summary(summary_xls, probe_type_sheet);
% NOTE - UPDATE FUNCTION read_Jen_xls_summary WHEN WE NEED OTHER
% INFORMATION OUT OF THAT SPREADSHEET

[rat_nums, ratIDs, ratIDs_goodhisto] = get_rat_list();

num_rats = length(ratIDs);

for i_rat = 1 : num_rats
    ratID = ratIDs{i_rat};
    rat_folder = fullfile(parent_directory, ratID);

    if ~isfolder(rat_folder)
        continue;
    end

    probe_type = probe_types{probe_types.RatID == ratID, 2};
    processed_folder = find_data_folder(ratID, 'processed', parent_directory);
    session_dirs = dir(fullfile(processed_folder, strcat(ratID, '*')));
    num_sessions = length(session_dirs);

    % WORKING HERE-NOW LOOP THROUGH, ORGANIZE DATA, CALCULATE SCALOGRAMS

    for i_session = 1 : num_sessions
        
        session_name = session_dirs(i_session).name;
        cur_dir = fullfile(session_dirs(i_session).folder, session_name);
        cd(cur_dir)

        lfp_fname = strcat(session_name, '_lfp.mat');
        if ~isfile(lfp_fname)
            sprintf('%s not found, skipping', lfp_file)
            continue
        end

        lfp_data = load(lfp_fname);

        Fs = lfp_data.actual_Fs;
        [ordered_lfp, intan_site_order, intan_site_order_for_trials_struct, site_order] = lfp_by_probe_site_ALL(lfp_data, probe_type);

        % load trials structure
        trials_name = sprintf('%s_trials.mat', session_name);
        trials_name = fullfile(cur_dir, trials_name);

        if ~exist(trials_name)
            sprintf('no trials structure found for %s', session_name)
            continue
        end

        load(trials_name)
        
        selected_trials = 
        extract_perievent_data(ephys_data, ts, t_window, Fs)

    end

end