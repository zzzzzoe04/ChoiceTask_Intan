% script to calculate scalograms for all of Jen's rats; store in files in
% the processed data folders

parent_directory = 'Z:\data\ChoiceTask\';

[rat_nums, ratIDs, ratIDs_goodhisto] = get_rat_list();

num_rats = length(ratIDs);

for i_rat = 1 : num_rats
    ratID = ratIDs{i_rat};
    rat_folder = fullfile(parent_directory, ratID);

    if ~isfolder(rat_folder)
        continue;
    end

    processed_folder = find_data_folder(ratID, 'processed', parent_directory);

    session_dirs = dir(fullfile(processed_folder, strcat(ratID, '*')));

    num_sessions = length(session_dirs);

    % WORKING HERE-NOW LOOP THROUGH, ORGANIZE DATA, CALCULATE SCALOGRAMS

end