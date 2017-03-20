function [headers] = ReadSpectTraceHeader(filename);
%% Reads a .spect file and returns just the metadata
% 
% Use: [headers] = ReadSpectTraceHeader(filename);

% Open the file for reading
fid = fopen(filename,'r');

% Read the file header
file_header = fread(fid,[4,1],'double');

% Pull out metadata that will be used to read
ns = file_header(3);
ntraces = file_header(4);

% Calc byte to skip
bytespersample = 8;
toskip = ns*2*bytespersample;

% Now read all of the headers, real, and imag data 
headers = fread(fid, [4,ntraces],'4*double=>double',toskip);

fclose(fid);
