% This code assumes spike times and behavior initiation times in ms
pre=3000; post=35000; binW=50;
thisBresponse=[];
for n1=1:size(nn,1) %for each neuron, could be for each channel
nt=nn(n1,:);
thisN=[];
for bt=st%for each behavior instance
thisN=[thisN, nt(nt>bt-pre & nt<bt+post)-bt]; %as of now, I don’t care about trialwise effects, so just putting them all togther
end
thisH=hist(thisN,-pre:binW:post)./(length(st)); %control for trial count
thisBresponse=[thisBresponse; thisH*(1000/binW)]; %adjust to Hz
end
figure;
imagesc(zscore(thisBresponse')');colorbar;

