%Heatmap
figure;imagesc(zscore(pethEntries')');colorbar;
%individual unit peths
figure;
for iUnit=1:size(pethEntries,1)
    subplot(5,8,iUnit),plot(pethEntries(iUnit,:));ylabel('Fr (Hz)');xlabel('Time (bins)');title(['Unit ',char(string(iUnit))]);
end
%rasters
figure;
for iUnit=1:length(byUnit_Spikes4raster)
    subplot(5,8,iUnit),imagesc(abs(1-byUnit_Spikes4raster(iUnit).spike_times));colormap('bone');
    ylabel('trial');xlabel('Time (3001=event)');title(['Unit ',char(string(iUnit))]);
end