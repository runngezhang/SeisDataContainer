function FileAlloc(dirname,header)
%FILEALLOC  Allocate file space for header
%
%   FileAlloc(DIRNAME,HEADER) allocates file for serial header writing.
%

error(nargchk(2, 2, nargin, 'struct'));
assert(ischar(dirname), 'directory name must be a string')
assert(isstruct(header), 'header must be a header struct')

% Make Directory
if isdir(dirname); rmdir(dirname,'s'); end;
status = mkdir(dirname);
assert(status,'Fatal error while creating directory %s',dirname);

% Write file
DataContainer.io.memmap.serial.DataAlloc(dirname,'real',header.size,header.precision);
if header.complex
    DataContainer.io.memmap.serial.DataAlloc(dirname,'imag',header.size,header.precision);
end
% Write header
DataContainer.io.memmap.serial.HeaderWrite(dirname,header);

end