function FileWrite(dirname,x,varargin)
%FILEWRITE Writes serial data to binary file
%
%   FileWrite(DIRNAME,DATA,FILE_PRECISION|HEADER_STRUCT) writes
%   the real serial array X into DIRNAME/FILENAME.
%
%   DIRNAME - A string specifying the directory name
%   DATA    - Non-distributed float data
%
%   Optional argument is either of:
%   FILE_PRECISION - An optional string specifying the precision of one unit of data,
%                    defaults to type of x
%                    Supported precisions: 'double', 'single'
%   HEADER_STRUCT  - An optional header struct as created
%                    by SDCpckg.Reg.basicHeaderStructFromX
%                    or SDCpckg.Reg.basicHeaderStruct
%
%   Warning: If the specified dirname exists, it will be removed.

SDCpckg.Reg.io.isFileClean(dirname);
error(nargchk(2, 3, nargin, 'struct'));
assert(ischar(dirname), 'directory name must be a string')
assert(isfloat(x), 'data must be float')
assert(~isdistributed(x), 'data must not be distributed')

% Setup variables
header = SDCpckg.Reg.basicHeaderStructFromX(x);
f_precision = header.precision;

% Preprocess input arguments
if nargin>2
    assert(ischar(varargin{1})|isstruct(varargin{1}),...
        'argument mast be either file_precision string or header struct')
    if ischar(varargin{1})
        f_precision = varargin{1};
        header.precision = f_precision;
    elseif isstruct(varargin{1})
        header = varargin{1};
        f_precision = header.precision;
    end
end;
SDCpckg.Reg.verifyHeaderStructWithX(header,x);

% Check Directory
assert(isdir(dirname),'Fatal error: directory %s does not exist',dirname);

% Write file
SDCpckg.Reg.io.NativeBin.serial.FileAlloc(dirname,header);
SDCpckg.Reg.io.setFileDirty(dirname);
SDCpckg.Reg.io.NativeBin.serial.DataWrite(dirname,'real',real(x),f_precision);
if ~isreal(x)
    SDCpckg.Reg.io.NativeBin.serial.DataWrite(dirname,'imag',imag(x),f_precision);
end
% Write header
SDCpckg.Reg.io.setFileClean(dirname);
end
