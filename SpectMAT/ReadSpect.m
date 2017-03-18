function [file_header, headers, data] = ReadSpect(filename);
%% Reads a .spect file and returns data and metadata
% 
% Use: [fileheader, headers, data] = ReadSpect(filename);

% Open the file for reading
fid = fopen(filename,'r');

% Read the file header
file_header = fread(fid,[4,1],'double');

% Pull out metadata that will be used to read
ns = file_header(3);
ntraces = file_header(4);

% Now read all of the headers, real, and imag data 
all = fread(fid, [4+2*ns,ntraces],'double');

% Split of headers, and clear;
headers = all(1:4,:);
%all(1:4,:) = [];

% Reconstruct the complex data
data = complex(all(5:ns+4,:), all(ns+5:end,:));

fclose(fid);
