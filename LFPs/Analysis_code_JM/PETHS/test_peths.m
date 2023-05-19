% This code assumes spike times and behavior initiation times in ms
pre=3000; 
post=3000; 
binW=50;
pethEntries=[];
for iUnit=1:size(sClust,1) %for each neuron, could be for each channel
    nt=sClust(iUnit,:);
    unitBehavior=[];
        for bt=trial_ts %for each behavior instance
            unitBehavior=[unitBehavior, nt(nt>bt-pre & nt<bt+post)-bt];
        end
    thisH=hist(unitBehavior, -pre:binW:post)./(length(trial_ts)); %control for trial count
    pethEntries=[pethEntries; thisH*(1000/binW)]; %adjust to Hz
end
figure;
imagesc(pethEntries);colorbar;