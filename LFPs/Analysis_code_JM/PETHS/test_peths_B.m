eventFieldnames = {'centerIn'};
pethHalfWidth = 10; %seconds
binSize = 50;
totalUnits = 1;
% unitCount = length(cell2mat(regexp(names,'(T\d+)_(W\d+[abcdefg]$)'))); % names = spike_clusters? maybe do clusternumbers = unique(spike_clusters) + 1 for unitCount
clusternumbers = unique(spike_clusters) + 1;
unitCount = length(clusternumbers);
for iUnit=1:unitCount
        pethEntries = [];
        unitName = clusternumbers(iUnit); % names = spike_clusters
        % [n, ts] = nex_ts(fullfile(pathname,filenames{iFiles}),spike_clusters{iUnit}); % Edit this line for sure, don't need nex_ts but actually extract_trial_ts probably
        trial_ts = extract_trial_ts(trials(trIdx), eventFieldnames);
        for iEvent=trial_ts % probably use centerIn
            % find timestamps centered about eventFieldnames
            tsFitCriteria = find(sClust > trial_ts(iEvent) - pethHalfWidth & sClust < trial_ts(iEvent) + pethHalfWidth);
            % subtract starting value to center ts entries
            if ~isempty(tsFitCriteria)
                pethEntries = [pethEntries sClust(tsFitCriteria) - trial_ts(iEvent)];
            end
        end
        allTs{totalUnits} = {sClust,unitName};
        totalUnits = totalUnits + 1;
        
        figure;
        histogram(tsFitCriteria,binSize);
        xlabel('time (s)');
        ylabel('spikes');
        title([strrep(clusternumbers(iUnit),'_','-')]);
        disp(length(pethEntries))
end