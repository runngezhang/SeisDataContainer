% This script initializes a segy data container from a stack
% segy volume.

metafile = 'stack_meta.mat' % metadata summary file (see scanSegyStack)
 
% Initialize the data container
container = segyCon(metafile, 'stack');

% Check the block headers
header = container.headers

% Read the data into an in-core data container
incore = container.blocks(10:13);

% Get the data as a regularily spaced matrix
data = incore.regularize();





