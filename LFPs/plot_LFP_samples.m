function plot_LFP_samples(LFP_file, probe_anatomy_info)

if ~exists(LFP_file, 'file')
    error([LFP_file ' not found'])
    return
end

load(LFP_file)