% mybox2mat

% TODO:
% Set first bits to 1
% Clean out samples where all lines go high
function box2nex(varargin)
% make it optional to supply a file or list of files; if none supplied,
% then use uigetfile
filenames = '';

for iarg = 1 : 2 : nargin
    switch lower(varargin{iarg})
        case 'filenames',
            filenames = varargin{iarg + 1};
    end
end
	
	numLines = 32;
	numBytesPerSample = numLines/8;
	
	nSampleRate = 31250;
	nSamplesToRead = 15625;
	maxNumEvents = 20000; % will choke if there are more than this many events on a line
	
	% For your specialized task,
	% replace these with your line names, 
	% and save a new box2nex.m file, and call it something specific, e.g.
	% box2nex_foodwatertask.m
    linenames = {'Line01', 'Line02', 'Line03', 'Line04', 'Line05', 'Line06', ...
    			 'Line07', 'Line08', 'Line09', 'Line10', 'Line11', 'Line12', ...
    			 'Line13', 'Line14', 'Line15', 'Line16', 'Line17', 'Line18', ...
    			 'Line19', 'Line20', 'Line21', 'Line22', 'Line23', 'Line24', ...
    			 'Line25', 'Line26', 'Line27', 'Line28', 'Line29', 'Line30', ...
    			 'Line31', 'Line32'};

	% e.g. For Alaina's task:
	% linenames = {'Cue1', 'Cue2', 'Cue3', 'Cue4', 'Cue5', 'Houselight', ...
	% 			 'FoodHopper', 'Tone1', 'Tone2', 'WrongStart', 'ToneTrigger', 'Water', ...
	% 			 '', '', '', '', ... % these lines are currently unused
	% 			 'NosePoke1', 'NosePoke2', 'NosePoke3', 'NosePoke4', ...
	% 			 'NosePoke5', 'FoodDetect', 'WaterDetect', ...
	% 			 '', '', '', '', '', '', '', '', ''};


	assert( length(linenames) == numLines, sprintf('box files hold exactly %d lines (version May 25, 2010)', numLines) )	
	

	% Grab the .box file
    if ~isempty(filenames)
        [filenames, pathname] = uigetfile('*.box', 'Pick a rat box data file', 'MultiSelect', 'on');
    end

	% If the user didn't select any file, quit RIGHT NOW
	if isequal(filenames,0) || isequal(pathname,0)
		disp('No BOX file selected. Goodbye!');
		return 
	end
	
	% If the user selects only one file, we need to change the "filenames" variable from a string to
	% a cell array with one entry. If more than one file is selected, then we have a cell array anyway.
	if ~iscell(filenames)
		filenames = { filenames };
	end
	
	for i=1:length(filenames) % Add the full directory path to each filename
		filenames{i} = fullfile(pathname, filenames{i});
	end


	for iFile = 1:length(filenames)
		iFile
		currentSample = 0;
		currentTime = 0;
		
		filename = filenames{iFile};
		
		% Figure out how long the box file is (in bytes)
		dirInfo = dir(filename);
		totalBytes = dirInfo.bytes;	
	
		% Set up the NEX file data structure
		nexData.version = 100;
		nexData.comment = 'Converted by box2nex.m. Alex Wiltschko, 2010';
		nexData.freq = nSampleRate;
		nexData.tbeg = 0;
		nexData.tend = totalBytes/(numBytesPerSample*nSampleRate);
		nexData.events = {};
		on.events = {};
		off.events = {};
	
		usedLines = [];
		numUsedLines = 0;
		for i=1:numLines
			if strcmp(linenames{i}, ''); continue; end
			numUsedLines = numUsedLines + 1;
			usedLines(end+1) = i;
			nexData.events{end+1}.name = [linenames{i} 'On'];
			nexData.events{end}.timestamps = {};

			nexData.events{end+1}.name = [linenames{i} 'Off'];
			nexData.events{end}.timestamps = {};
		
		end
	
		% Open up the .box file, and start reading!
		fid=fopen(filename, 'rb');
		disp(['Reading dio from [' filename '] at [' num2str( nSamplesToRead ) '] samples per block']);

		allLines = zeros(numUsedLines, nSamplesToRead);
		allOnEvents = zeros(numUsedLines, maxNumEvents); % maximum 20000 events or so
		allOffEvents = zeros(numUsedLines, maxNumEvents);
		onEventIdx = ones(numUsedLines,1);
		offEventIdx = ones(numUsedLines,1);
	
		while feof(fid) == 0
		
			% Figure out the time (in seconds) for where we are in the file
			currentTime = currentSample/nSampleRate;
			if mod(currentTime, 300) == 0
				disp(sprintf('Working on minute %d', currentTime/60));
			end		
		
			% Read in some new data
			[bytes, numSamplesRead] = fread(fid, [1 nSamplesToRead], 'uint32', 0, 'b');
			if feof(fid); break; end
		
			% Update our idea of where we are in the file (in bytes)
			currentSample = currentSample + numSamplesRead;
		
			% Collect line values from every line we care about
			for i=1:numUsedLines
				allLines(i,:) = bitget(bytes, usedLines(i));
			end
		
			% Sometimes all the lines are low at the same time
			% This is incorrect, and we're going to fix it right here
			% in software.
			% NOTE: this doesn't explicitly detect "pops", where 
			% the lines go low then high again, but instead
			% just detects whether all lines are low. Should be fine, I _think_...
			checkForLinePop = sum(allLines,1);
			idx = find(checkForLinePop == 0);
			for i=1:length(idx)
                
				allLines(:,idx(i)) = allLines(:,idx(i)-1);
			end
		
			% Now we'll extract on and off times
			for i=1:numUsedLines
				% A channel is considered to have flipped "on" when it goes from 1 to 0
				% A channel is considered to have flipped "off" when it goes from 0 to 1
				onTimes  = currentTime + find( diff(allLines(i,:)) == -1 )/nSampleRate;
				offTimes = currentTime + find( diff(allLines(i,:)) ==  1 )/nSampleRate;
				numOn = length(onTimes);
				numOff = length(offTimes);
				allOnEvents(i,onEventIdx(i):onEventIdx(i)+numOn-1) = onTimes;
				allOffEvents(i,offEventIdx(i):offEventIdx(i)+numOff-1) = offTimes;
				onEventIdx(i) = onEventIdx(i) + numOn;
				offEventIdx(i) = offEventIdx(i) + numOff;
			end
		
		end
	
		% Stick in the events
		for i=1:numUsedLines
			nexData.events{i*2-1}.timestamps  = unique(allOnEvents(i,1:onEventIdx(i)-1)');
			nexData.events{i*2}.timestamps	  = unique(allOffEvents(i,1:offEventIdx(i)-1)');
		end
		nexData.events = nexData.events';
	
		% Make intervals
		nexData.intervals = {};
		for i=1:numUsedLines		
		
			intStarts = nexData.events{i*2-1}.timestamps;
			intEnds   = nexData.events{i*2}.timestamps;
		
			if isempty(intEnds) || isempty(intStarts); continue; end
		
			intEnds = intEnds( intEnds > intStarts(1) );
			intStarts = intStarts( intStarts < intEnds(end) );
		
			nexData.intervals{end+1}.name = linenames{usedLines(i)};
			nexData.intervals{end}.intStarts = intStarts; % notice we used end+1 above. that created the entry, and now we can just refer to it at "end"
			nexData.intervals{end}.intEnds = intEnds;
		end
		nexData.intervals = nexData.intervals'; % stupid, STUPID requirement for writeNexFile...
	
	
		writeNexFile(nexData, [filename '.nex']);
		
	end % End loop over all selected .box files
	
end