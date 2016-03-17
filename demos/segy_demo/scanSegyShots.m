% This script scans a directory of segy files and creates trace
% summaries and lookup table for handling subsets of large data
% volumes. Traces are partitioned into defined block sizes which
% can be handled independently. Assumes shot record organization of
% the segy files.

% This script only needs to be run once on a Segy Volume

filepath = {'data/'}; % Path tothe segy files
filename_string = 'SOURCE'; % Filter segy files based on this
                            % filter string

output_dir = '../data/'; % Directory to output trace summary files

block_size = 100000; % Number of traces in each block

header_bytes = [73,77,81,85]; % Byte location for the metadata
                              % [src_x, src_y, rec_x, rec_y]

metafile = 'shot_meta.mat' % metadata summary file
 

% Scan the segyfile
segy_scan(filepath,filename_string, header_bytes, ...
          block_size, metafile);





