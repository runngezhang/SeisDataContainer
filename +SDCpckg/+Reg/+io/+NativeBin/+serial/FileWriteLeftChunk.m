function FileWriteLeftChunk(dirname,x,range,slice)
%FILEWRITELEFTCHUNK Writes serial left chunk data to binary file
%
%   FileWriteLeftChunk(DIRNAME,DATA,RANGE,SLICE) writes
%   the real serial left chunk into DIRNAME/FILENAME.
%
%   DIRNAME - A string specifying the directory name
%   DATA    - Non-distributed float data
%   RANGE   - A vector with two elements representing the range of
%             data that we want to write            
%   SLICE   - A vector specifying the slice
%
%   Warning: If the specified dirname exists, it will be removed.

SDCpckg.Reg.io.isFileClean(dirname);
SDCpckg.Reg.io.setFileDirty(dirname);
narginchk(4, 4);
assert(ischar(dirname), 'directory name must be a string')
assert(isfloat(x), 'data must be float')
assert(~isdistributed(x), 'data must not be distributed')
assert(isvector(range)&length(range)==2, 'range index must be a vector with 2 elements')
assert(isvector(slice)|isequal(slice,[]), 'slice index must be a vector')

% Read header
header = SDCpckg.Reg.io.NativeBin.serial.HeaderRead(dirname);

% Write file
SDCpckg.Reg.io.NativeBin.serial.DataWriteLeftChunk(dirname,'real',real(x),...
    header.size,range,slice,header.precision);
if ~isreal(x)
    SDCpckg.Reg.io.NativeBin.serial.DataWriteLeftChunk(dirname,'imag',imag(x),...
        header.size,range,slice,header.precision);
end
SDCpckg.Reg.io.setFileClean(dirname);
end
