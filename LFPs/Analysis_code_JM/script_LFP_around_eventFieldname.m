% script to write field potentials around each trial


% probe_mapping_fname = '/Volumes/SharedX/Neuro-Leventhal/data/ChoiceTask/Probe Histology Summary/ProbeSite_Mapping.xlsx';

intan_parent_directory = 'X:\Neuro-Leventhal\data\ChoiceTask';
rats_with_intan_sessions = find_rawdata_folders(intan_parent_directory);

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

intan_ignore = {'R0326_20191107a'}; % still troubleshooting these two lines to avoid looping through irrelevant data files (e.g. files with no info.rhd file.
sessions_to_ignore = {'R0326_20191107a', 'R0427_20220920a'};

%%
for i_rat = 1 : length(rats_with_intan_sessions)
    
    intan_folders = rats_with_intan_sessions(i_rat).intan_folders;
    
    for i_sessionfolder = 1 : length(intan_folders)
        
        [session_folder, ~, ~] = fileparts(intan_folders{i_sessionfolder});
        session_log = find_session_log(session_folder);
        
        if isempty(session_log)
            sprintf('no log file found for %s', session_folder)
        end
        logData = readLogData(session_log);
        
        % calculate nexData, need digital input and analog input files
        digin_fname = fullfile(intan_folders{i_sessionfolder}, 'digitalin.dat');
        analogin_fname = fullfile(intan_folders{i_sessionfolder}, 'analogin.dat');
        rhd_fname = fullfile(intan_folders{i_sessionfolder}, 'info.rhd');
        
        if ~exist(digin_fname, 'file')
            sprintf('no digital input file for %s', session_folder)
            continue
        end
        
        if ~exist(analogin_fname, 'file')
            sprintf('no analog input file for %s', session_folder)
            continue
                end
        
        if ~exist(rhd_fname, 'file')
            sprintf('no rhd info file for %s', session_folder)
            continue
        end
        
        % read in rhd info
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
        
        
        
        
    end
    
end