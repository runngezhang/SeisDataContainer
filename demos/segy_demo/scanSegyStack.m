% This script scans a directory of segy files and creates trace
% summaries and lookup table for handling subsets of large data
% volumes. Traces are partitioned into defined block sizes which
% can be handled independently. Assumes stacked data organization of
% the segy files.

% This script only needs to be run once on a Segy Volume


filepath = {'../data/'}; % Path to the segy files
filename_string = '00_05';  % Filter segy files based on this
                            % filter string

block_size = 10000; % Number of traces in each block
header_bytes = [189,193]; % Byte location for the metadata
                          % [il, xl]

metafile = 'stack_meta.mat';  % metadata summary file

% Scan the segyfile
segy_scan(filepath, filename_string, header_bytes, block_size, ...
          metafile)





