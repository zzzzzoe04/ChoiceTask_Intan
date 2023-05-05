AllTrials = vertcat(trials.correct);
tone = vertcat(trials.tone);
C = [AllTrials tone];
indices = find(C(:,1)==0);
C(indices,:) = [];
tone2 = sum( C(:,2)==2 );
tone1 = sum( C(:,2)==1 );