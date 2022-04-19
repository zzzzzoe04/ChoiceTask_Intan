function lfp_fname = create_lfp_fname(rd_metadata)

lfp_fname = strcat(rd_metadata.ratID, '_', rd_metadata.session_name(7:end), '_lfp.mat');