
% C = reshape(event_triggered_lfps_ordered,[],size(event_triggered_lfps_ordered,3),1);
% 
% szA = size(event_triggered_lfps_ordered, 1);
% szB = size(event_triggered_lfps_ordered, 2);
% szC = size(event_triggered_lfps_ordered, 3);
% D = szA * szB; % using this value to reshape the data into a vector array instead of a 3D Matrix
% result_test = reshape(event_triggered_lfps_ordered,D,[]); % lines 4 through 9 are doing what line 2 is doing.

% checking the order of how this reshapes the data. I think it is reshaping
% as all the points for Ch 1 then moving to channel 2 etc. 
% Test_values = event_triggered_lfps_ordered(1,:,:); Test_values_squeeze = squeeze(Test_values);
num_channels = size(event_triggered_lfps_ordered, 2);
currentCWT = zeros();

num_events = size(event_triggered_lfps_ordered,3);
num_channels = size(event_triggered_lfps_ordered,2);
num_trials = size(event_triggered_lfps_ordered, 1);

fb = cwtfilterbank;
fb = cwtfilterbank('Wavelet', 'amor','SignalLength', 2001,'SamplingFrequency', 500 );

for i = 1:num_trials
    for j = 1:num_channels
        for k = 1:num_events
            [cfs_mean,f] = cwt(event_triggered_lfps_ordered(i,j,k),fb);
        end
    end
end


% for i_row = 1 : num_rows
%    [cfs_mean,f] = cwt(event_triggered_lfps(i_row, :, :), 'amor', Fs);
% end

% [cfs_mean,f] = cwt(myData2(1,:),'amor',500);