function DataWrite(dirname,filename,x,file_precision)
%DATAWRITE Writes serial data to binary file
%
%   DataWrite(DIRNAME,DATA,FILE_PRECISION) writes
%   the real serial array X into file DIRNAME/FILENAME.
%
%   DIRNAME        - A string specifying the directory name
%   FILENAME       - A string specifying the file name
%   DATA           - Non-distributed real data
%   FILE_PRECISION - A string specifying the precision of one unit of
%                       data,
%               Supported precisions: 'double', 'single'
%
%   Warning: The specified file must exist.

error(nargchk(4, 4, nargin, 'struct'));
assert(ischar(dirname), 'directory name must be a string')
assert(ischar(filename), 'file name must be a string')
assert(isreal(x), 'data must be real')
assert(~isdistributed(x), 'data must not be distributed')
assert(ischar(file_precision), 'file_precision name must be a string')

%Imports
import slim.javaseis.utils.*;

% Preprocess input arguments
filename=fullfile(dirname,filename);

% Check File
assert(exist(filename,'file')==2,'Fatal error: file %s does not exist',...
    filename);

% swap file_precision
x = SDCpckg.utils.switchPrecisionIP(x,file_precision);

%Creation of the seisio object enabling to write into the JavaSeis file
seisio=slim.javaseis.utils.SeisioSDC(dirname);
seisio.open('rw');

%Properties of interest
props=seisio.getFileProperties({char(SeisioSDC.DATA_DIMENSIONS),'complex'});

%Data number of dimensions
dims=length(size(x));

%Writing of the data in the Trace file
if props.get('complex')==1 %Complex case
    x=single(x);
    seisio.writeMatlabMultiArray(permute(x,dims:-1:1));
else %Real case
    x=single(x);
    seisio.writeMatlabMultiArray(permute(x,dims:-1:1));
end
seisio.close;
end