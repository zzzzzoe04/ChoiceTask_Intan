% script run through folders and make the monopolar and diff plots

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

intan_choicetask_parent = 'X:\Neuro-Leventhal\data\ChoiceTask';

% loop through all the processed data folders here, load the lfp file
valid_rat_folders = find_processed_folders(intan_choicetask_parent);
rats_with_intan_sessions = find_rawdata_folders(intan_choicetask_parent);
%%
% probe_type = 'NN8x8';

% Fs = 500; -- commenting out so we can just load the Fs from the
% power_lfps file.

naming_convention; % this loads the NNsite order ventral to dorsal as a variable in the workspace for labeling the plots (create this as a fxn?)
naming_convention_diffs;
sessions_to_ignore = {'R0378_20210507a'};
% lfp_fname = dir(fullfile(intan_choicetask_parent,'**','*_lfp.mat')); % This
% generates a matrix of '*_lfp.mat' filenames

for i_ratfolder = 1 : length(valid_rat_folders)
    
    session_folders = valid_rat_folders(i_ratfolder).processed_folders;
    
    for i_sessionfolder = 1 : length(session_folders)
    % extract the ratID and session name from the LFP file
        session_path = session_folders{i_sessionfolder};
        pd_processed_data = parse_processed_folder(session_path);
        ratID = pd_processed_data.ratID;
        session_name = pd_processed_data.session_name;
        
        if any(strcmp(session_name, sessions_to_ignore))
            continue
        end
        
        % make a folder for the processed data graphs (monopolar and diff
        % graphs)
        parentFolder = fullfile(intan_choicetask_parent, ...
         ratID, ...
         [ratID '-processed']);

        A=cell(1,3);
        A{1} = ['Subject: ' ratID];
        A{2} = ['Session: ' session_name];
        
        session_rawfolder = fullfile(intan_choicetask_parent, ratID, [ratID '-rawdata'], session_name);
        session_log = find_session_log(session_rawfolder);
        logData = readLogData(session_log);
        A{3} = ['Task Level: ' choiceRTdifficulty{logData.taskLevel+1}];   
        
        processed_graphFolder = [parentFolder(1:end-9) 'processed-graphs'];
        if ~exist(processed_graphFolder, 'dir')
            mkdir(processed_graphFolder);
        end    
        
        
%         if ratID == 'R0326'
%             probe_type = 'NN8x8';
%         elseif ratID == 'R0411'
%             probe_type = 'ASSY156';
%         end
%         
        
        % create filenames to hold mono- and diff-LFPs
        mono_power_plot = [session_name, '_monopolarpower.pdf'];
        mono_power_plot = fullfile(processed_graphFolder, mono_power_plot);

        diff_power_plot = [session_name, '_diffpower.pdf'];
        diff_power_plot = fullfile(processed_graphFolder, diff_power_plot);
      
%         if exist(mono_power_plot, 'file') && exist(diff_power_plot, 'file') 
%             continue
%         end
        
        % For monopolar_power plots
        power_lfps_file = dir(fullfile(session_path, '**', '*_monopolarpower.mat'));
        power_lfps_fname = fullfile(power_lfps_file.folder, power_lfps_file.name); 
        % This catches at R0378, the file with 63 channels that didn't record a power_lfps file
        power_lfps = load(power_lfps_fname);
        power_lfps = power_lfps.power_lfps;
        num_rows = size(power_lfps,1); % for now, skipping R0378_20210507a because the session only recorded 63 channels instead of 64. Need to rewrite lfp_NNsite_order and diff functions to fix this issue by determining which channel was not recorded. 
        % The actual plot section
        plot_monopolar = plot_monopolar_power_single_plot(power_lfps_fname);   % include info for making a title, etc. in the single_plot function
        sgtitle(A, 'Interpreter','none'); % 'Interpreter', 'none'  --- allows the title to have an underscore instead of a subscript
        set(gcf, 'WindowState', 'maximize'); % maximizes the window so that it exports the graphics with appropriate font size
        exportgraphics(gcf, mono_power_plot);
        close;
                    
        
        % For diff plots
        power_lfps_diff_file = dir(fullfile(session_path, '**', '*_diffpower.mat'));
        power_lfps_diff_fname = fullfile(power_lfps_diff_file.folder, power_lfps_diff_file.name); 
        % This catches at R0378, the file with 63 channels that didn't record a power_lfps file
        power_lfps_diff = load(power_lfps_diff_fname);
        f = power_lfps_diff.f;
        power_lfps_diff = power_lfps_diff.power_lfps_diff;
        num_rows_diff = size(power_lfps_diff,1);


        % The actual plot section
        plot_diff = plot_diff_power_single_plot(power_lfps_diff_fname);
        set(gcf, 'WindowState', 'maximize'); % maximizes the window so that it exports the graphics with appropriate font size
        sgtitle(A, 'Interpreter','none');
        exportgraphics(gcf, diff_power_plot);
        close;
                   
    end
 
end