function [file_header, headers, data] = ReadSpectTraces(filename,tracerange)
%% Reads a .spect file and returns the indexed traces and metadata 
% 
% Use: [fileheader, headers, data] = ReadSpectTraces(filename,tracerange);

% Open the file for reading
fid = fopen(filename,'r');

% Read the file header
file_header = fread(fid,[4,1],'double');

% Pull out metadata that will be used to read
ns = file_header(3);
ntraces = file_header(4);

% Get traces to read
starttrace = tracerange(1);
endtrace = tracerange(2);
ntraces = endtrace - starttrace + 1;

% Skip to the start of the first indexed trace
bytespersample = 8;
toskip =32+(4+2*ns)*(starttrace-1)*bytespersample;
fseek(fid, toskip, 'bof');

% Read traces and headers until endtrace

% Read out all the real entries at this index
all  = fread(fid,[4+2*ns, ntraces],'1*double=>double');

% Pull out headers
headers = all(1:4,:);

% Reconstruct the complex data
data = complex(all(5:ns+4,:), all(ns+5:end,:));

fclose(fid);
