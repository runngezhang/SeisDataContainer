function [file_header, headers, data] = ReadSpectSample(filename,index)
%% Reads a .spect file and returns the indexed sample
% from each trace and metadata 
% 
% Use: [fileheader, headers, data] = ReadSpectSample(filename,index);

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

% Return to index's first real sample
bytespersample = 8;
toskip = 2*ns*bytespersample+32-8;
fseek(fid, 32+32+(index-1)*bytespersample, 'bof');

% Read out all the real entries at this index
realpart = fread(fid,[1,ntraces],'1*double=>double',toskip);

% Return to first index's first imag sample
fseek(fid, 32+32+(ns+index-1)*bytespersample, 'bof');

% Read all the imag parts 
imagpart = fread(fid,[1,ntraces],'1*double=>double',toskip);

% Reconstruct complex data
data = complex(realpart, imagpart);

fclose(fid);
