function SegyFastWriter(filename, data, textheader_ascii, varargin)
%% Write data to SEGY Rev 1 file. Headers are populated according to input.
%  
%   Use: sf_writer(filename, data, textheader, varargin)
%
%   

% Sort input args
fields = reshape(varargin,2,[]);

% Get basic params
[ns ntraces] = size(data);

% Create Text Header
textheader = sf_CreateSegyTextHeader(ascii);

% Create file Header
fileheader = sf_CreateSegyFileHeader(fields);

% Create Trace Headers
traceheader = sf_CreateSegyTraceHeader(ntraces, fields);

% Write to disk
sf_WriteSegy(filename, textheader, fileheader, traceheader, data);
    
