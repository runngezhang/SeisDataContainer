function [file_header] = ReadSpectHeader(filename);
%% Reads a .spect file and returns just the file header
% 
% Use: [fileheader] = ReadSpectHeader(filename);

% Open the file for reading
fid = fopen(filename,'r');

% Read the file header
file_header = fread(fid,[4,1],'double');

fclose(fid);
