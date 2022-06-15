function A = get_choiceTask_level_information(~,fname)
%
%
% INPUTS:
%   ratID - string containing the rat ID (e.g., 'R0001'). Should have 5
%       characters
%   
%
% CHOICE RT DIFFICULTY LEVELS:
%   0 - Poke Any: rat pokes any port, as soon as it pokes a pellet is
%       delivered
%   1 - Very Easy: single port is lit, pellet delivered as soon as the port
%       is poked
%   2 - Easy: 
%   3 - Standard:  
%   4 - Advanced: 
%   5 - Choice VE: 
%   6 - Choice Easy: 
%   7 - Choice Standard: 
%   8 - Choice Advanced: 
%   9 - Testing: 
%
% UPDATE LOG:
% 08/27/2014 - don't have to navigate to the parent folder first, requires
%   user to specify the rat ID as an input argument

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
% loop through all the rawdata data folders here, (load the log file?)
valid_rat_folders = find_rawdata_folders(intan_choicetask_parent); % find folders that contain raw_data_folders AND have intan data?

% loop through all the processed data folders here, load the lfp file
valid_rat_folders = find_processed_folders(intan_choicetask_parent);

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
         [ratID '-rawdata']);

        logData = readLogData(fname);

        
        A=cell(1,3);

        A{1} = ['Subject: ' logData.subject];
        A{2} = ['Date: ' logData.date];
        A{3} = ['Task Level: ' choiceRTdifficulty{logData.taskLevel+1}];
        textString{1} = [direct(ii).name '_LogAnalysis'];
        
    end
 
end