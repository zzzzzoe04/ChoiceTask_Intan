%Rearrange peri-event m x n x 2 matrix to into an array
[m n o] = size(trialRanges);
trialRanges_to_cell = squeeze(mat2cell(trialRanges,m,n,ones(1,o)));
trialRanges_1 = trialRanges_to_cell(1);
trialRanges_2 = trialRanges_to_cell(2);
trialRanges_1 = trialRanges_1{1,1};
trialRanges_2 = trialRanges_2{1,1};
trialRanges_final = cat(1, trialRanges_1, trialRanges_2);
trialRanges_final([1,3,2,4],:);
trialRanges_final = trialRanges_final([1,3,2,4],:);
trialRanges_final_frequency = trialRanges_final * 20000 % the sampling frequency is 20kHz, change the time (in seconds) to Hz)
