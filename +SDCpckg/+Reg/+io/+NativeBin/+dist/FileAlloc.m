function FileAlloc(dirname,header)
%FILEALLOC Allocates binary file in the specified directory
%
%   FILEALLOC(DIRNAME,HEADER) allocates binary files for distributed writing.
%   The file sizes are specified in the header.
%
%   DIRNAME - A string specifying the directory name
%   HEADER  - A header struct specifying the file properties
%

narginchk(2, 2);
%assert(parpool_size()>0,'parallel pool must be open')
assert(ischar(dirname), 'directory name must be a string')
assert(isstruct(header), 'header must be a header struct')
assert(header.distributedIO==1,'header is missing file distribution')
SDCpckg.Reg.io.isFileClean(dirname);
SDCpckg.Reg.io.setFileDirty(dirname);

% Check Directory
assert(isdir(dirname),'Fatal error: directory %s does not exist',dirname);

% convert to composite
cdirnames = SDCpckg.Reg.utils.Cell2Composite(header.directories);
cdimensions = SDCpckg.Reg.utils.Cell2Composite(header.distribution.size);
hprecision = header.precision;
hcomplex = header.complex;

% Write header
SDCpckg.Reg.io.NativeBin.serial.HeaderWrite(dirname,header);

% Write file
spmd
    SDCpckg.Reg.io.NativeBin.serial.DataAlloc(cdirnames,'real',cdimensions,hprecision);
    if hcomplex
        SDCpckg.Reg.io.NativeBin.serial.DataAlloc(cdirnames,'imag',cdimensions,hprecision);
    end
end

SDCpckg.Reg.io.setFileClean(dirname);
end
