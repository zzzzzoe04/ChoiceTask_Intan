% script run through folders and make the monopolar and diff plots

intan_choicetask_parent = 'X:\Neuro-Leventhal\data\ChoiceTask';

% loop through all the processed data folders here, load the lfp file
valid_rat_folders = find_processed_folders(intan_choicetask_parent);

probe_type = 'NN8x8';
% Fs = 500; -- commenting out so we can just load the Fs from the
% power_lfps file.

naming_convention; % this loads the NNsite order ventral to dorsal as a variable in the workspace for labeling the plots (create this as a fxn?)

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
        
        % make a folder for the processed data graphs (monopolar and diff
        % graphs)
        parentFolder = fullfile(intan_choicetask_parent, ...
         ratID, ...
         [ratID '-processed']);

        processed_graphFolder = [parentFolder(1:end-9) 'processed-graphs'];
        if ~exist(processed_graphFolder, 'dir')
            mkdir(processed_graphFolder);
        end  
        
        % create filenames to hold mono- and diff-LFPs
        mono_power_plot = [session_name, '_monopolarpower.pdf'];
        mono_power_plot = fullfile(processed_graphFolder, mono_power_plot);

        diff_power_plot = [session_name, '_diffpower.pdf'];
        diff_power_plot = fullfile(processed_graphFolder, diff_power_plot);
 

%         lfp_file = dir(fullfile(session_path, '**', '*_lfp.mat'));
%         cd(session_path);
%         % lfp = load(lfp_fname.name); % I think the lfp needs to be loaded
%         % in the lfp_NNsite_order script in the next line of this fxn.
%        
%         % LFP file needs to be loaded before the [power_lfps,f] function
%         lfp_fname = fullfile(lfp_file.folder, lfp_file.name);
        
        if exist(mono_power_plot, 'file') && exist(diff_power_plot, 'file') 
            continue
        end
        
        power_lfps_file = dir(fullfile(session_path, '**', '*_monopolarpower.mat'));
        power_lfps_fname = fullfile(power_lfps_file.folder, power_lfps_file.name);
        power_lfps = load(power_lfps_fname);
        Fs = power_lfps.Fs;
        f = power_lfps.f;
        power_lfps = power_lfps.power_lfps;
        
        num_rows = size(power_lfps,1); % for now, skipping R0378_20210507a because the session only recorded 63 channels instead of 64. Need to rewrite lfp_NNsite_order and diff functions to fix this issue by determining which channel was not recorded. 
                           
        % Plot the Data
        if ~exist(mono_power_plot, 'file')
            plot_monopolar_power;
            save(mono_power_plot); % saves the plot in -processed-graphs
        end
        
        %write a code for plotting diff plots then rewrite this section to
        %make the graphs.
%         if ~exist(diff_power_fn, 'file')
%             % Reorganize by NNsite and calculate the diffs
%             lfp_NNsite_diff = diff_probe_site_mapping(lfp_data, probe_type); % calculates diffs
%             [power_lfps_diff, f] = extract_power(lfp_NNsite_diff,Fs);
%             save(diff_power_fn, 'power_lfps_diff', 'f', 'Fs');
%         end
            
    end
    
end