%%Organize lfp mat file by shank

lfp_shank1 = lfp(49:56,:);
lfp_shank2 = lfp(57:64,:);
lfp_shank3 = lfp([33:35, 37:39, 41:42],:);
lfp_shank4 = lfp([35,40,43:48],:);
lfp_shank5 = lfp([17:22,26,30],:);
lfp_shank6 = lfp([23:25, 27:29, 31:32],:);
lfp_shank7 = lfp(1:8,:);
lfp_shank8 = lfp(9:16,:);
lfp_all = cat(1,lfp_shank1, lfp_shank2, lfp_shank3, lfp_shank4, lfp_shank5, lfp_shank6, lfp_shank7, lfp_shank8);

%% Verify data is correctly ordered and rearranged

%Shank1
verify_lfp_shank1 = lfp_shank1(:,1:1000);
verify_lfp_original = lfp(49:56, 1:1000); 
verify_lfp_lfpAll = lfp_all(1:8, 1:1000);
%Shank2
verify_lfp_shank2 = lfp_shank2(:,1:1000);
verify_lfp_original2 = lfp(57:64,1:1000);
verify_lfp_lfpAll2 = lfp_all(9:16, 1:1000);

%Code above can be edited to verify for other shanks; did the two above for
%proof of principle and they seem accurate JM 2022/04/29
%% Use diff function to write a for loop for comparing neighboring sites

