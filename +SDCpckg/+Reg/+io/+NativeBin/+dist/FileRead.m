function [x header] = FileRead(dirname,varargin)
%FILEREAD Reads serial data from binary file
%
%   [X, HEADER] = FILEREAD(DIRNAME,X_PRECISION) reads
%   the serial real array X from file DIRNAME/FILENAME.
%
%   DIRNAME     - A string specifying the directory name
%
%   Addtional parameter:
%   X_PRECISION - An optional string specifying the precision of one unit of data,
%                 defaults to 'double' (8 bits)
%                 Supported precisions: 'double', 'single'
%
narginchk(1, 2);
assert(parpool_size()>0,'parallel pool must be open')
assert(ischar(dirname), 'directory name must be a string')
assert(isdir(dirname),'Fatal error: directory %s does not exist',dirname);

% Setup variables
x_precision = 'double';

% Preprocess input arguments
if nargin>1
    assert(ischar(varargin{1}),'Fatal error: precision is not a string?');
    x_precision = varargin{1};
end;

% Read header
header = SDCpckg.Reg.io.NativeBin.serial.HeaderRead(dirname);

% Read file
if header.distributedIO
    csize = SDCpckg.Reg.utils.Cell2Composite(header.distribution.size);
    cdirnames = SDCpckg.Reg.utils.Cell2Composite(header.directories);
    spmd
        x=SDCpckg.Reg.io.NativeBin.dist.DataRead(1,cdirnames,'real',...
            header.size,csize,[],header.distribution.dim,header.distribution.partition,...
            header.precision,x_precision);
        if header.complex
            dummy=SDCpckg.Reg.io.NativeBin.dist.DataRead(1,cdirnames,'imag',...
                header.size,csize,[],header.distribution.dim,header.distribution.partition,...
                header.precision,x_precision);
            x=complex(x,dummy);
        end
    end
else
    header = SDCpckg.Reg.addDistHeaderStruct(header,...
        header.dims,SDCpckg.Reg.utils.defaultDistribution(header.size(end)));
    cindx_rng = SDCpckg.Reg.utils.Cell2Composite(header.distribution.indx_rng);
    spmd
        x=SDCpckg.Reg.io.NativeBin.dist.DataRead(0,dirname,'real',...
            header.size,[],cindx_rng,header.distribution.dim,header.distribution.partition,...
            header.precision,x_precision);
        if header.complex
            dummy=SDCpckg.Reg.io.NativeBin.dist.DataRead(0,dirname,'imag',...
                header.size,[],cindx_rng,header.distribution.dim,header.distribution.partition,...
                header.precision,x_precision);
            x=complex(x,dummy);
        end
    end
end
 
end
