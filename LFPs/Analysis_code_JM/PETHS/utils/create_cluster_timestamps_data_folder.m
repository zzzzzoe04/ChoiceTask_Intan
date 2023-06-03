function session_cluster_timestamps = create_cluster_timestamps_data_folder(rd_metadata, parent_directory)

session_clust_timestamps_folder= strcat(rd_metadata.ratID, '-cluster-timestamps'); % cluster_timestamps_data_folder
session_cluster_timestamps = fullfile(parent_directory, rd_metadata.ratID, session_clust_timestamps_folder, rd_metadata.session_name);

if ~isfolder(session_cluster_timestamps)
    
    mkdir(session_cluster_timestamps)
    
end