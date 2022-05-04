% check data to verify accuracy of diff calculations
check_original_lfp = lfp(50, 1:1000) - lfp(55, 1:1000); % checking the diff between site 1 and site 8 in the original lfp file
check_lfp_NNsite_diff = lfp_NNsite(1, 1:1000) - lfp_NNsite(2, 1:1000);
check_lfp_NNsite_diff_reported_values = lfp_NNsite_diff(1, 1:1000);