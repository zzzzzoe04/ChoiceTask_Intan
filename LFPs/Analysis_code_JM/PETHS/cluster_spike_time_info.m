% read in spike_clusters
spike_clusters = readNPY('spike_clusters.npy');
% read in spike_times
spike_times = readNPY('spike_times.npy');
% concatenate spike clusters and spike times
cluster_times = [spike_clusters spike_times];

% This file is grandfathered in and is replaced by the sort_ts_to_units
%   function

% Where spike times == st and cluster numbers == clu
sClust=nan(max(spike_clusters)+1,1);
for a=1:length(sClust)
    sClust(a)=sum(spike_clusters==a-1);
end
sClust=nan(length(sClust),max(sClust));
for a=1:size(sClust,1)
    sClust(a,1:sum(spike_clusters==a-1))=spike_times(spike_clusters==a-1)';
end