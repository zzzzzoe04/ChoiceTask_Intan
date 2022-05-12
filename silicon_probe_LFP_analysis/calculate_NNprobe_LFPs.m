function calculate_NNprobe_LFPs(intan_folder)

cd(intan_folder);

rhd_file = dir('*.rhd');
if length(rhd_file) > 1
    error('more than one rhd file in ' + intan_folder);
    return
elseif isempty(rhd_file)
    error('no rhd files found in ' + intan_folder);
    return
end

rhd_info = read_Intan_RHD2000_file_DL(rhd_file.name);

end