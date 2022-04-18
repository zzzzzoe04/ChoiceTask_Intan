function find_rawdata_folders(intan_choicetask_parent)

potential_rat_folders = dir(intan_choicetask_parent);

num_valid_rat_folders = 0;
for i_folder = 1 : length(potential_rat_folders)
    
    full_path = fullfile(intan_choicetask_parent, potential_rat_folders(i_folder).name);
    if ~isdir(full_path)
        continue
    end
    % look for folders of format RXXXX
    if isvalidratfolder(potential_rat_folders(i_folder).name)
        num_valid_rat_folders = num_valid_rat_folders + 1;
        rat_folders{num_valid_rat_folders} = full_path;
    end
        
end

% now look for valid session folders within each rat folder
for i_folder = 1 : num_valid_rat_folders
    
    [root_path, cur_ratID, ext] = fileparts(rat_folders{i_folder});
    
    cur_rawdata_folder = fullfile(rat_folders{i_folder}, strcat(cur_ratID, '-rawdata'));
    
    if ~isdir(cur_rawdata_folder)
        continue
    end
    
    session_folders = dir(cur_rawdata_folder);
    
end

end