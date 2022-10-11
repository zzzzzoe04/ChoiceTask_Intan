% script to write field potentials around each trial


% probe_mapping_fname = '/Volumes/SharedX/Neuro-Leventhal/data/ChoiceTask/Probe Histology Summary/ProbeSite_Mapping.xlsx';

intan_parent_directory = 'X:\Neuro-Leventhal\data\ChoiceTask';
rats_with_intan_sessions = find_rawdata_folders(intan_parent_directory);

num_trials_to_plot = 5;

% start with an LFP file
% get the trial structure for that session
% run this analysis

eventFieldnames = {'cueOn', 'centerIn', 'centerOut', 'tone', 'sideIn', 'sideOut', 'foodClick', 'foodRetrievel'};
    % eventlist = {'centerin','cueon','centerout', 'sidein', 'sideout',
    % 'foodretrievel'}; This is the full eventlist for a correctGo trial.
    % Choose one for generating event_triggered_lfps.
num_events = length(eventFieldnames);
t_win = [-2.5 2.5]; % need this line for the event_triggered_lfps to select the correct 
trialType = ('allGo'); % to pull out trIdx of the trials structure (just correct go trials)

% lists for ratID probe_type
NN8x8 = ["R0326", "R0327", "R0372", "R0379", "R0374", "R0378", "R0394", "R0395", "R0396", "R0412", "R0413"]; % Specify list of ratID associated with each probe_type
ASSY156 = ["R0411", "R0419"];
ASSY236 = ["R0420", "R0425", "R0427", "R0457"];

intan_ignore = {'R0326_20191107a'}; % still troubleshooting these two lines to avoid looping through irrelevant data files (e.g. files with no info.rhd file.
sessions_to_ignore = {'R0326_20191107a', 'R0427_20220920a'};

naming_convention; % for labeling graphs

% choiceTask difficulty levels
choiceRTdifficulty = cell(1, 10);
choiceRTdifficulty{1}  = 'poke any';
choiceRTdifficulty{2}  = 'very easy';
choiceRTdifficulty{3}  = 'easy';
choiceRTdifficulty{4}  = 'standard';
choiceRTdifficulty{5}  = 'advanced';
choiceRTdifficulty{6}  = 'choice VE';
choiceRTdifficulty{7}  = 'choice easy';
choiceRTdifficulty{8}  = 'choice standard';
choiceRTdifficulty{9}  = 'choice advanced';
choiceRTdifficulty{10} = 'testing';

%%
for i_rat = 1 : length(rats_with_intan_sessions)
    
    intan_folders = rats_with_intan_sessions(i_rat).intan_folders;
    
    for i_sessionfolder = 1 : length(intan_folders)
        % extract the ratID and session name from the LFP file
        session_path = intan_folders{i_sessionfolder};
        pd_processed_data = parse_processed_folder(session_path);
        ratID = pd_processed_data.ratID;
        session_name = pd_processed_data.session_name;
        
        if any(strcmp(ratID, sessions_to_ignore)) % can't quite get this to debug but seems ok (if it worked it would run through the code quicker)
            continue
        end        
        
        parentFolder = fullfile(intan_parent_directory, ...
            ratID, ...
            [ratID '-processed']);
        % Create Processed_graphFolder if it doesn't exist (the folder not
            % existing at this point in analysis would be rare but putting in
            % as a catch here)

        processed_graphFolder = [parentFolder(1:end-9) 'processed-graphs'];
            if ~exist(processed_graphFolder, 'dir')
                mkdir(processed_graphFolder);
            end 
        
        [session_folder, ~, ~] = fileparts(intan_folders{i_sessionfolder});
        session_log = find_session_log(session_folder);
        
        if isempty(session_log)
            sprintf('no log file found for %s', session_folder)
        end
        logData = readLogData(session_log); %gathing logData information
        
       
        % calculate nexData, need digital input and analog input files
        digin_fname = fullfile(intan_folders{i_sessionfolder}, 'digitalin.dat');
        analogin_fname = fullfile(intan_folders{i_sessionfolder}, 'analogin.dat');
        rhd_fname = fullfile(intan_folders{i_sessionfolder}, 'info.rhd');
        
        if ~exist(digin_fname, 'file')
            sprintf('no digital input file for %s', session_folder);
            continue
        end
        
        if ~exist(analogin_fname, 'file')
            sprintf('no analog input file for %s', session_folder);
            continue
        end
        
        if ~exist(rhd_fname, 'file')
            sprintf('no rhd info file for %s', session_folder);
            continue
        end
        
        % read in rhd info; requires 'info.rhd' file.
        rhd_info = read_Intan_RHD2000_file_DL(rhd_fname);
        
        % read digital input file
        dig_data = readIntanDigitalFile(digin_fname);
        if ~isfield(rhd_info, 'board_adc_channels')
            sprintf('board_adc_channels field not found in rhd_info for %s', session_folder)
            continue
        end
        
        analog_data = readIntanAnalogFile(analogin_fname, rhd_info.board_adc_channels);
        nexData = intan2nex(dig_data, analog_data, rhd_info);
        
        try
            sprintf('attempting to create trials structure for %s', session_folder)
            trials = createTrialsStruct_simpleChoice_Intan( logData, nexData );
        catch
            sprintf('could not generate trials structure for %s', session_folder)
            continue
        end
        
        % extract Trial Type (e.g. correctGo)
        % Set trialType at beginning of file
        [ trialEventParams ] = getTrialEventParams(trialType); % Need to verify this section. Working Here
        trIdx = extractTrials(trials, trialEventParams);
        
        
        %Getting the LFP-fname
        rd_metadata = parse_rawdata_folder(intan_folders{i_sessionfolder});
        pd_folder = create_processed_data_folder(rd_metadata, intan_parent_directory);
        
        lfp_fname = fullfile(pd_folder, create_lfp_fname(rd_metadata));
        lfp_data = load(lfp_fname); % Load in the LFP data for rearranging LFP data (ordering it by probe_type)
        Fs = lfp_data.actual_Fs; % need the Fs loaded in for gathering event_triggered_lfps in the next 'for' loop
               

        if contains(ratID, NN8x8) % if the ratID is in the list, it'll assign it the correct probe_type for ordering the LFP data correctly
            probe_type = 'NN8x8'; 
        elseif contains(ratID, ASSY156)
            probe_type = 'ASSY156';
        elseif contains(ratID, ASSY236)
            probe_type = 'ASSY236';
        end
        
        % Order the lfps here        
        [ordered_lfp, intan_site_order, site_order] = lfp_by_probe_site_ALL(lfp_data, probe_type); 
                % Orders the lfps by probe site mapping (double check the single file to remove catches for loading in single data)
        
        % Generate event triggered LFPs
        for i_event = 1 : num_events
                    % write code here to get event_triggered_lfps_ordered
                    % for each separate event
                    
                    event_triggered_lfps = extract_event_related_LFPs(ordered_lfp, trials(trIdx), eventFieldnames{i_event}, 'fs', Fs, 'twin', t_win); % made this using ordered_lfp data
                                      
                    % at this point, event_triggered_lfps_ordered is an m x n x p array where
                    % m is the number of events (i.e., all the cueon OR nosein OR other...
                    % events) in a single session; n is the number of channels in that session
                    % (generally 64), and p is the number of time samples extracted around each
                    % event (i.e., p = 2001 if we extract +/- 2 seconds around each event).

                    % above here, the lfp file, trial structure never change
                    
                    trial_ts = extract_trial_ts(trials(trIdx), eventFieldnames{i_event}); % This is actually pulled in from the extract_event_related_LFPs script so do we need it here? 
        
%                     pts_per_event = size(event_triggered_lfps,3); % I think these lines need to go into the for loop for whenever a set of data is loaded into the workspace.
%                     num_channels = size(event_triggered_lfps,2);
                     num_trials = size(event_triggered_lfps, 1);
                    
                    % select trials for plotting at random
                    trial_idx_to_plot = randperm(num_trials, num_trials_to_plot);
                    for i_trial = 1:num_trials_to_plot
                        trial_idx = trial_idx_to_plot(i_trial);
                        % get rid of trial number as part of file name
                        fname_to_save = char(strcat(session_name(1:end-13), eventFieldnames{i_event}, '_', trialType, '_', 'channel_lfps', '.pdf')); % add in ''_', sprintf('trial%u.pdf', trial_idx)' should you want to save files individually
                        full_name = fullfile(pd_folder, fname_to_save);
                        
%                         if exist(full_name,'file')
%                             continue;
%                         end
                        
                            channel_lfps = squeeze(event_triggered_lfps(trial_idx,:, :)); 
                            % trials, create a 64channel graph for each trial?
                        
                            % Plot the data
                            figure;
                            num_rows = size(event_triggered_lfps,2);
                            LFPs_per_shank = num_rows/ 8;   % will be 8 for 64 channels, 7 for 56 channels (diff)
                                    A=cell(1,4);
                            
                            
                            for i_row = 1 : num_rows

                                y_lim = [-1500, 1500];
                                plot_col = ceil(i_row / LFPs_per_shank);
                                plot_row = i_row - LFPs_per_shank * (plot_col-1);
                                plot_num = (plot_row-1) * 8 + plot_col;

                                subplot(LFPs_per_shank,8,plot_num);
                                plot_channel_lfps = plot(channel_lfps(i_row, :)); % change to log10 -- plot(f, 10*log10(power_lfps(:,1)))
                                set(gca, 'ylim',y_lim);
                                grid on

                                if contains(ratID, NN8x8) % if the ratID is in the list, it'll assign it the correct probe_type for ordering the LFP data correctly
                                    caption = sprintf('NN8x8 #%d', NNsite_order(i_row));
                                elseif contains(ratID, ASSY156)
                                    caption = sprintf('ASSY156 #%d', ASSY156_order(i_row));
                                elseif contains(ratID, ASSY236)
                                    caption = sprintf('ASSY236 #%d', ASSY236_order(i_row));
                                end 
                                title(caption, 'FontSize', 8);

                                if plot_row < LFPs_per_shank
                                    set(gca,'xticklabels',[])
                                end

                                if plot_col > 1
                                    set(gca,'yticklabels',[])
                                end
        
                            end
                        set(gcf, 'WindowState', 'maximize'); % maximizes the window so that it exports the graphics with appropriate font size
                        
                         A{1} = ['Subject: ' ratID];
                         A{2} = ['Session: ' session_name(1:end-14)];
                         A{3} = ['Task Level: ' choiceRTdifficulty{logData.taskLevel+1}];
                         A{4} = ['Trial Number: ' num2str(trial_idx)];
                         A{5} = ['EventFieldname and Trial Type: ' eventFieldnames{i_event} '_' trialType];
                        
                        sgtitle(A, 'Interpreter','none');
                        
                        if i_trial == 1
                            exportgraphics(gcf, full_name);
                        else
                            exportgraphics(gcf, full_name, 'append', true);   %ADD APPEND FLAG HERE
                        end
                        % close;
                       
                    end
        
        end
                      
   end
    
end