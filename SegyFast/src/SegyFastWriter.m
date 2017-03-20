function SegyFastWriter(filename, data, textheader_ascii, varargin)
%% Write data to SEGY Rev 1 file. Headers are populated according to input.
%  
%   Use: SegyFastWriter(filename, data, textheader, varargin)
%
%   Example: SegyFastWriter(filename,data,text_ascii,'dsf',5,'dt', 8000,...
%               'ns', 1001,'SourceX',sx,'SourceY',sy,'GroupX',rx,'GroupY',ry)
%
% -----------------------------------------------------------------------------  
%   For a complete list of supported file header fields run:
%      fileheader_bytes_to_samples_fun.m
%   
%   For a complete list of supported trace header fields run:
%       traceheader_bytes_to_samples_fun.m
% 
%   Data that is input will be converted according to the chosen data sample
%   format. At this time only data formats 5 (4-byte IEEE singles) and 1 
%   (IBM 4-Byte Floats) are supported. Note that the conversion of large
%   arrays to DSF 1 is slightly expensive.
% 
%   It is strongly recommened to include atleast the sample interval (dt),
%   number of samples (ns), and the data format (dsf), as these are 
%   generally required by SEGY readers.
%
%   If the textheader is an empty vector, a blank text header will be generated
%   where the first to characters of each line display the line number.
%       Example: SegyFastWriter(filename,data,[],'dsf',5,'dt', 8000,...
%               'ns', 1001)
%
%   Limitations:
%       - Variable trace length is not supported
%       - All metadata must be signed integers, so be careful of overflow 
% -----------------------------------------------------------------------------
%   Author: 
%       Keegan Lensink
%       Seismic Laboratory for Imaging and Modeling
%       Department of Earth, Ocean, and Atmospheric Sciences
%       The University of British Columbia
%         
%   Date: March, 2017
% -----------------------------------------------------------------------------

% Sort input args
fields = reshape(varargin,2,[]);

% Get basic params
[ns ntraces] = size(data);

% Create Text Header
if isempty(textheader_ascii)
    textheader = sf_blankheader;
else
    textheader = sf_CreateSegyTextHeader(textheader_ascii);
end

% Create file Header
fileheader = sf_CreateSegyFileHeader(fields);

% Create Trace Headers
traceheader = sf_CreateSegyTraceHeader(ntraces, fields);

% Find data sample format, if un-specified default to 5
i = strfind(fields(1,:), 'dsf');
dsf_index = find(not(cellfun('isempty',i)));
if isempty(dsf_index)
    display('No Data Format Specified, defaulting to DSF 5 (4-Byte IEEE singles)')
    dsf = 5;
else
    dsf = fields{2,dsf_index};
    
    % Check for supported DSF
    if ~(dsf == 1 | dsf == 5)
        display('Data Sample Format not supported')
        return
    end

end

% Write to disk
sf_WriteSegy(filename, textheader, fileheader, traceheader, data, dsf);
    
