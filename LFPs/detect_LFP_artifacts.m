function [outputArg1,outputArg2] = detect_LFP_artifacts(LFP,inputArg2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
max_amp = 2000;

for iarg = 1 : 2 : nargin - 1
    switch lower(varargin{iarg})

    end
end


outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function detect_by_amplitude(LFP, max_amp)

    LFP_abs = abs(LFP);

end