

szA = size(event_triggered_lfps_ordered, 1);
szB = size(event_triggered_lfps_ordered, 2);
szC = size(event_triggered_lfps_ordered, 3);
D = szA * szB;

result_test = reshape(event_triggered_lfps_ordered,D,[]);

for i_row = 1 : num_rows
   [cfs_mean,f] = cwt(event_triggered_lfps(i_row, :, :), 'amor', Fs);
end

% [cfs_mean,f] = cwt(myData2(1,:),'amor',500);