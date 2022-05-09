%%
data_parent_directory = 'X:\Neuro-Leventhal\data\ChoiceTask';
cd(data_parent_directory)
rat_directories = dir(data_parent_directory);

num_directories = length(rat_directories);

for i_dir = 1 : length(rat_directories)
    if rat_directories(i_dir).name(1) ~= 'R'
        % make sure name starts with 'R'
        disp(rat_directories(i_dir).name)
        continue;
    end
    
    if ~isfolder(rat_directories(i_dir).name)
        % make sure it's a directory
        disp(rat_directories(i_dir).name)
        continue;
    end
    % assume any directory that starts with 'R' is a rat directory
    
    cd(rat_directories(i_dir).name);
    
    % check that there is a processed data folder
    ratID = rat_directories(i_dir).name;
    if ~isfolder([ratID, '-processed'])
        % there is no processed data folder in this rat directory
        continue;
    end
    
    session_folders = dir(pwd);
    for i_session = 1 : length(session_folders)
       % insert code to loop through session folders here 
        
    numMats = length(session_folders);
    switch numMats
        case 0         % skip if no .log files present
            cd(parentFolder);
            continue;
        case 1
            validMatIdx = 1;
        case 2
            for iLog = 1 : length(dirs)
                if isempty(strfind(dirs(iMat).name))
                    validMatIdx = iMat;
                    break;
                end
            end
        otherwise      % skip if more than one .log files present
            cd(data_parent_directory);
            continue;
        end
    end
    
    cd(data_parent_directory);
    
end   % end of loop through rat folders