% This script initializes a segy data container from a shot record
% segy volume.

metafile = 'shot_meta.mat' % metadata summary file (see scan SegyShots)
 
% out of core data container
container = segyCon(metafile, 'shot');

% Print out the metadata headers
segyHead = container.header

% read in the 10th block of data into an in-core data container
d = container.blocks(10);

% print out the data header
header = d.header

% Do something with the data container
%F = opDFT(size(d,1));
%f = F*d;




