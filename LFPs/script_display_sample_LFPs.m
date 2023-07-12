% script to display sample LFPs from each session from each rat

rats_to_analyze = [326, 327, 372, 374, 376, 378, 379, 394, 395, 396, 411, 412, 413, 419, 420, 425];

rows_per_page = 16;

% parent_directory = 'Z:\data\ChoiceTask\';
intan_parent_directory = '\\corexfs.med.umich.edu\SharedX\Neuro-Leventhal\data\ChoiceTask';
rat_xldbfile = 'ProbeSite_Mapping_MATLAB.xlsx';
% summary_xls_dir = 'Z:\data\ChoiceTask\Probe Histology Summary';
summary_xls_dir = '\\corexfs.med.umich.edu\SharedX\Neuro-Leventhal\data\ChoiceTask\Probe Histology Summary';
rat_xldbfile = fullfile(summary_xls_dir, rat_xldbfile);

% change the line below to allow looping through multiple trial types,
% extract left vs right, etc.
trials_to_analyze = 'correct';
lfp_types = {'monopolar', 'bipolar'};
lfp_type = 'monopolar';
% trials_to_analyze = 'all';

t_window = [-2.5, 2.5];
event_list = {'cueOn', 'centerIn', 'tone', 'centerOut' 'sideIn', 'sideOut', 'foodClick', 'foodRetrieval'};

probe_type_sheet = 'probe_type';
probe_types = read_Jen_xls_summary(rat_xldbfile, probe_type_sheet);
% NOTE - UPDATE FUNCTION read_Jen_xls_summary WHEN WE NEED OTHER
% INFORMATION OUT OF THAT SPREADSHEET

[ratIDs, ratIDs_goodhisto] = get_rat_list(rats_to_analyze);

num_rats = length(ratIDs);

for i_rat = 1 : num_rats
    ratID = ratIDs{i_rat};
    rat_folder = fullfile(intan_parent_directory, ratID);

    if ~isfolder(rat_folder)
        continue;
    end

    probe_type = probe_types{probe_types.ratID == ratID, 2};
    probe_site_mapping = probe_site_mapping_all_probes(probe_type);

    processed_folder = find_data_folder(ratID, 'processed', intan_parent_directory);
    session_dirs = dir(fullfile(processed_folder, strcat(ratID, '*')));
    num_sessions = length(session_dirs);

    for i_session = 1 : num_sessions
        
        session_name = session_dirs(i_session).name;
        cur_dir = fullfile(session_dirs(i_session).folder, session_name);
        cd(cur_dir)

%         % load trials structure
%         trials_name = sprintf('%s_trials.mat', session_name);
%         trials_name = fullfile(cur_dir, trials_name);
% 
%         if ~exist(trials_name)
%             sprintf('no trials structure found for %s', session_name)
%             continue
%         end
% 
%         load(trials_name)
        
%         selected_trials = extract_trials_by_features(trials, trials_to_analyze);
%         if isempty(selected_trials)
%             sprintf('no %s trials found for %s', trials_to_analyze, session_name)
%             continue
%         end

        lfp_fname = strcat(session_name, '_lfp.mat');
        if ~isfile(lfp_fname)
            sprintf('%s not found, skipping', lfp_fname)
            continue
        end

        lfp_data = load(lfp_fname);
        num_channels = size(lfp_data.lfp, 1);
        num_samples = size(lfp_data.lfp, 2);
        ordered_lfp = lfp_data.lfp(probe_site_mapping, :);

        Fs = lfp_data.actual_Fs;
        t = linspace(1/Fs, num_samples/Fs, num_samples);

        total_pages = ceil(num_channels / rows_per_page);
        text_string = sprintf('%s, page %d of %d', session_name, 1, total_pages);
        [h_fig, h_axes, tlayout] = LFP_layout_tiles(rows_per_page, 1, text_string);
        num_pages = 0;
        
        for i_lfp = 1 : num_channels

            plot_row = mod(i_lfp, rows_per_page);
            if plot_row == 0
                plot_row = rows_per_page;
            end

            axes(h_axes(plot_row))
            if plot_row < rows_per_page
                xticklabels([])
            end
            plot(t, ordered_lfp(i_lfp, :));

            if plot_row == rows_per_page
                % save this image; append 
                num_pages = num_pages + 1;
                if num_pages == 1
                    % save file
                else
                    % append to file
                end
                close(h_fig)
                [h_fig, h_axes, tlayout] = LFP_layout_tiles(rows_per_page, num_pages + 1, text_string);
            end

        end

    end

end

            
% 
%         for i_lfptype = 1 : length(lfp_types)
% 
%             lfp_type = lfp_types{i_lfptype};
%             if strcmpi(lfp_type, 'bipolar')
%                 lfp_fname = strcat(session_name, '_bipolar_lfp.mat');
%             else
%                 lfp_fname = strcat(session_name, '_lfp.mat');
%             end
%             lfp_fname = fullfile(cur_dir, lfp_fname);
%             if ~isfile(lfp_fname)
%                 sprintf('%s not found, skipping', lfp_fname)
%                 continue
%             end
% 
%             lfp_data = load(lfp_fname);
% 
%             if strcmpi(lfp_type, 'bipolar')
%                 ordered_lfp = lfp_data.bipolar_lfp;
%             else
%                 probe_site_mapping = probe_site_mapping_all_probes(probe_type);
%                 ordered_lfp = lfp_data.lfp(probe_site_mapping, :);
%             end
% 
%             probe_lfp_type = sprintf('%s_%s', probe_type, lfp_type);
%             num_channels = size(ordered_lfp, 1);
% 
%             for i_event = 1 : length(event_list)
%                 event_name = event_list{i_event};
%                 sprintf('working on session %s, event %s, %s', session_name, event_name, lfp_type)
%     
%                 perievent_data = extract_perievent_data(ordered_lfp, selected_trials, event_name, t_window, Fs);
%     
%                 scalo_folder = create_scalo_folder(session_name, event_name, intan_parent_directory);
%     %             scalo_folder = sprintf('%s_scalos_%s', session_name, event_name);
%     %             scalo_folder = fullfile(cur_dir, scalo_folder);
%                 if ~exist(scalo_folder, 'dir')
%                     mkdir(scalo_folder)
%                 end
%         
%                 for i_channel = 1 : num_channels
%                     [shank_num, site_num] = get_shank_and_site_num(probe_lfp_type, i_channel);
%         
%                     scalo_name = sprintf('%s_scalos_%s_%s_shank%02d_site%02d.mat',session_name, lfp_type, event_name, shank_num, site_num);
%                     scalo_name = fullfile(scalo_folder, scalo_name);
%         
%                     if exist(scalo_name, 'file')
%                         continue
%                     end
%         
%                     event_triggered_lfps = squeeze(perievent_data(:, i_channel, :));
%                     
%                     % comment back in if running on a machine without a gpu
% %                     disp('cpu')
% %                     tic
% %                     [event_related_scalos, ~, coi] = trial_scalograms(event_triggered_lfps, fb);
% %                     toc
%                     
%                     etl_g = gpuArray(event_triggered_lfps);
%                     [event_related_scalos, ~, coi] = trial_scalograms(etl_g, fb);
% 
%                     save(scalo_name, 'event_related_scalos', 'event_triggered_lfps', 'fb', 'coi', 't_window', 'i_channel');
%                     % saving i_channel is a check to make sure that shank
%                     % and site are numbered correctly later
%         
%                 end
%             end
%         end
%     end
% 
% end