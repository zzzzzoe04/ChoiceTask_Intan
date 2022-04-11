function nexData = box2nex_useHeader(varargin)
%
% usage: nexData = box2nex_useHeader(varargin)
%
% function to take a .box file (which may or may not have a header) and
% convert timestamps to a .nex file.
%
% varargins:
%   'filenames' - list of .box files to convert
%   'writefile' - whether or not to write the nex formatted data to a new
%       file; default filename is the original filename with .nex appended
%       - that is, should be "XXXX.box.nex" where XXXX is the original base
%       filename
%
% OUTPUTS:
%   nexData - nex data structure
%   nexData.version - file version
%   nexData.comment - file comment
%   nexData.tbeg - beginning of recording session (in seconds)
%   nexData.tend - end of resording session (in seconds)
%
%   nexData.neurons - array of neuron structures
%           neurons.name - name of a neuron variable
%           neurons.timestamps - array of neuron timestamps (in seconds)
%               to access timestamps for neuron 2 use {n} notation:
%               nexData.neurons{2}.timestamps
%
%   nexData.events - array of event structures
%           event.name - name of neuron variable
%           event.timestamps - array of event timestamps (in seconds)
%               to access timestamps for event 3 use {n} notation:
%               nexData.events{3}.timestamps
%
%   nexData.intervals - array of interval structures
%           interval.name - name of neuron variable
%           interval.intStarts - array of interval starts (in seconds)
%           interval.intEnds - array of interval ends (in seconds)
%
%   nexData.waves - array of wave structures
%           wave.name - name of neuron variable
%           wave.NPointsWave - number of data points in each wave
%           wave.WFrequency - A/D frequency for wave data points
%           wave.timestamps - array of wave timestamps (in seconds)
%           wave.waveforms - matrix of waveforms (in milliVolts), each
%                             waveform is a vector 
%
%   nexData.contvars - array of contvar structures
%           contvar.name - name of neuron variable
%           contvar.ADFrequency - A/D frequency for data points
%
%           continuous (a/d) data come in fragments. Each fragment has a timestamp
%           and an index of the a/d data points in data array. The timestamp corresponds to
%           the time of recording of the first a/d value in this fragment.
%
%           contvar.timestamps - array of timestamps (fragments start times in seconds)
%           contvar.fragmentStarts - array of start indexes for fragments in contvar.data array
%           contvar.data - array of data points (in milliVolts)
%
%   nexData.markers - array of marker structures
%           marker.name - name of marker variable
%           marker.timestamps - array of marker timestamps (in seconds)
%           marker.values - array of marker value structures
%           	marker.value.name - name of marker value 
%           	marker.value.strings - array of marker value strings
%
%
% make it optional to supply a file or list of files; if none supplied,
% then use uigetfile
%
% change log:
%   8/1/12: found that sometimes you get "pops" from high to low to high,
%       but can also get them low to high to low. Added code to take
%       account of this possibility.

filenames = {};
writeFile = true;

for iarg = 1 : 2 : nargin
    switch lower(varargin{iarg})
        case {'filename','filenames'},
            filenames = varargin{iarg + 1};
        case 'writefile',
            writeFile = varargin{iarg + 1};
    end
end
	
    if ~iscell(filenames)
        filenames = cellstr(filenames);
    end
    
	numLines = 32;
	numBytesPerSample = numLines/8;
	
	nSampleRate = 31250;
	nSamplesToRead = 15625;
	maxNumEvents = 20000; % will choke if there are more than this many events on a line

% 	assert( length(linenames) == numLines, sprintf('box files hold exactly
% 	%d lines (version May 25, 2010)', numLines) )	
	

	% Grab the .box file
    if isempty(filenames)
    	[filenames, pathname] = uigetfile('*.box', 'Pick a rat box data file', 'MultiSelect', 'on');
        if iscell(filenames)
           for i = 1 : length(filenames)
               temp{i} = pathname;
           end
           pathname = temp;
        end
    else
        for iFile = 1 : length(filenames)
            [pathname{iFile}, filenames{iFile}, ext] = fileparts(filenames{iFile});
            filenames{iFile} = [filenames{iFile} ext];
        end
    end

	% If the user didn't select any file, quit RIGHT NOW
	if isequal(filenames,0) || isequal(pathname,0)
		disp('No BOX file selected. Goodbye!');
		return 
	end
	
	% If the user selects only one file, we need to change the "filenames"
	% variable from a string to
	% a cell array with one entry. If more than one file is selected, then we have a cell array anyway.
	if ~iscell(filenames)
		filenames = { filenames };
    end
    if ~iscell(pathname)
        pathname = { pathname };
    end
    
	for i=1:length(filenames) % Add the full directory path to each filename
		filenames{i} = fullfile(pathname{i}, filenames{i});
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
	
		% Open up the .box file, and start reading!
		fid=fopen(filename, 'rb');
		disp(['Reading dio from [' filename '] at [' num2str( nSamplesToRead ) '] samples per block']);
        
        % check to see if there's a header
        testString = fscanf(fid, '%c', 3);
        if strcmpi(testString, 'BOX')
            % this file has a header; read in the bit identifiers from the
            % header
            box_header = getBOXHeader(filename);
            dataOffset = box_header.dataOffset;
            linenames = {};
            bits = box_header.bit;
            for iBit = 1 : length(bits)
                linenames{bits(iBit).original_number} = bits(iBit).name;
            end
        else
            % this file doesn't have a header; assign bit identifiers as
            % "Line01" to "Line32"
            
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
            dataOffset = 0;
        end
        
		usedLines = [];
		numUsedLines = 0;
		for i=1:numLines
			if strcmp(linenames{i}, ''); continue; end
			numUsedLines = numUsedLines + 1;
			usedLines(end+1) = i;
            
            % this chunk of code will name the events differently for laser
            % and shutter lines. 'On' events are generally going from high
            % to low (ie, nose-pokes, lighting cue lights, etc) because the
            % relays to the MedAssociates boxes are inverted. Laser "on"
            % events, however, are indicated by low to high transitions.
            % The laser shutter opens on a high value and closes on a low
            % value. -DL 02/03/2012
            if ~isempty(strfind(lower(linenames{i}), 'laser'))
                % this is a laser line
                nexData.events{end+1}.name = [linenames{i} 'Off'];
                nexData.events{end}.timestamps = {};

                nexData.events{end+1}.name = [linenames{i} 'On'];
                nexData.events{end}.timestamps = {};
            
            elseif ~isempty(strfind(lower(linenames{i}), 'video'))
                % this is a video trigger line
                nexData.events{end+1}.name = [linenames{i} 'Off'];
                nexData.events{end}.timestamps = {};

                nexData.events{end+1}.name = [linenames{i} 'On'];
                nexData.events{end}.timestamps = {};
                
            elseif ~isempty(strfind(lower(linenames{i}), 'shutter'))
                % this is a shutter line
                nexData.events{end+1}.name = [linenames{i} 'Closed'];
                nexData.events{end}.timestamps = {};

                nexData.events{end+1}.name = [linenames{i} 'Open'];
                nexData.events{end}.timestamps = {};
                
            elseif ~isempty(strfind(lower(linenames{i}), 'nose'))
                % this is a nose in/out line
                nexData.events{end + 1}.name = [linenames{i} 'In'];
                nexData.events{end}.timestamps = {};
                
                nexData.events{end + 1}.name = [linenames{i} 'Out'];
                nexData.events{end}.timestamps = {};
                
            else
                % all other channels            
                nexData.events{end+1}.name = [linenames{i} 'On'];
                nexData.events{end}.timestamps = {};

                nexData.events{end+1}.name = [linenames{i} 'Off'];
                nexData.events{end}.timestamps = {};
            end
            
		end

        fseek(fid, dataOffset, 'bof');
        
		allLines = zeros(numUsedLines, nSamplesToRead);
		allOnEvents = zeros(numUsedLines, maxNumEvents); % maximum 20000 events or so
		allOffEvents = zeros(numUsedLines, maxNumEvents);
		onEventIdx = ones(numUsedLines,1);
		offEventIdx = ones(numUsedLines,1);
        
        iReadLoop = 0;
		while feof(fid) == 0
		
            iReadLoop = iReadLoop + 1;
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
            
            if iReadLoop == 1   % first read iteration
                % assume the second digital read is the baseline for each
                % line. That is, if the first bit read is a "0", but the
                % second is a "1", I would assume that the line is default
                % "high". This is because the m-series cards try to set
                % lines low at the start of each read, but aren't always
                % successful. This is really fucked up and annoying. -DL
                % 20110626
                
                lastSamp = allLines(:, 2);
            end
                    
            
			% Sometimes all the lines are low at the same time
			% This is incorrect, and we're going to fix it right here
			% in software.
			% NOTE: this doesn't explicitly detect "pops", where 
			% the lines go low then high again, but instead
			% just detects whether all lines are low. Should be fine, I _think_...
            % above is from AW.
            
            % this needs to be changed because it's not always true that
            % ALL lines "pop" simultaneously. Rewrite the algorithm to
            % detect transitions to "low" and then immediately back to
            % "high". This happens one SOME but not all lines every time a
            % digital port read is initiated in LV. Fucking annoying. There
            % may be a way to fix this with a clever combination of
            % resistors, but I think this software work-around will be OK.
            
            for iLine = 1 : numLines
    			highIdx = find([lastSamp(iLine), allLines(iLine,:)] == 1);
                % compute spacing between high values along each line
                if isempty(highIdx); continue; end;
                
                highDiff = diff(highIdx);
                popIdx = (highDiff == 2);   % find indices of events where line went from high to low to high in 3 samples
                
                % 8/1/12 DL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                lowIdx  = find([lastSamp(iLine), allLines(iLine,:)] == 0);
                lowDiff = diff(lowIdx);    
                inversePopIdx = (lowDiff == 2);    % find indices of events where line went from low to high to low in 3 samples
                % 8/1/12 DL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                allLines(iLine, highIdx(popIdx)) = 1;
                allLines(iLine, lowIdx(inversePopIdx)) = 0;  % 8/1/12 DL
            end

            % below is left-over from when a line pop was considered when
            % ALL lines go low simultaneously
% 			for i=1:length(idx)
%                 
% 				allLines(:,idx(i)) = allLines(:,idx(i)-1);
% 			end
		
			% Now we'll extract on and off times
			for i=1:numUsedLines
				% A channel is considered to have flipped "on" when it goes from 1 to 0
				% A channel is considered to have flipped "off" when it goes from 0 to 1
                
                % added lastSamp into the calculation below to account for
                % the possibility that a transition takes place exactly
                % where a new block of values is loaded. -DL 20110627
				onTimes  = currentTime + find( diff([lastSamp(i), allLines(i,:)]) == -1 )/nSampleRate;
				offTimes = currentTime + find( diff([lastSamp(i), allLines(i,:)]) ==  1 )/nSampleRate;
				numOn = length(onTimes);
				numOff = length(offTimes);
				allOnEvents(i,onEventIdx(i):onEventIdx(i)+numOn-1) = onTimes;
				allOffEvents(i,offEventIdx(i):offEventIdx(i)+numOff-1) = offTimes;
				onEventIdx(i) = onEventIdx(i) + numOn;
				offEventIdx(i) = offEventIdx(i) + numOff;
            end
		
            lastSamp = allLines(:, end);
            
        end    % while feof(fid) == 0
	
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
            
            if isempty(intEnds); continue; end
			intStarts = intStarts( intStarts < intEnds(end) );
		
			nexData.intervals{end+1}.name = linenames{usedLines(i)};
			nexData.intervals{end}.intStarts = intStarts; % notice we used end+1 above. that created the entry, and now we can just refer to it as "end"
			nexData.intervals{end}.intEnds = intEnds;
		end
		nexData.intervals = nexData.intervals'; % stupid, STUPID requirement for writeNexFile...
	
        if writeFile
    		writeNexFile(nexData, [filename '.nex']);
        end
		
	end % End loop over all selected .box files
	
end