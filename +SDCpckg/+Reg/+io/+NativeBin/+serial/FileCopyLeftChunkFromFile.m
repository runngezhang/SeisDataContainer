function FileCopyLeftChunkFromFile(dirin,dirout,range,slice)
%FileCopyLeftChunkToFile Inserts serial left chunck data
%                        from file to prealocated larger file
%
%   FileCopyLeftChunkToFile(DIRIN,DIROUT,RANGE,SLICE) copies
%   full serial file from DIRIN as serial left chunk into DIROUT
%
%   DIRIN  - A string specifying the input directory name
%   DIROUT - A string specifying the output directory name
%   RANGE  - A vector with two elements representing the range of
%            data that we want to write            
%   SLICE  - A vector specifying the slice index
%

narginchk(4, 4);
assert(ischar(dirin), 'input directory name must be a string')
assert(ischar(dirout), 'ouput directory name must be a string')
assert(isdir(dirin),'Fatal error: input directory %s does not exist',dirin);
assert(isdir(dirout),'Fatal error: ouput directory %s does not exist',dirout);
assert(isvector(range)&length(range)==2, 'range index must be a vector with 2 elements')
assert(isvector(slice)|isequal(slice,[]), 'slice index must be a vector')
SDCpckg.Reg.io.isFileClean(dirin);
SDCpckg.Reg.io.isFileClean(dirout);
SDCpckg.Reg.io.setFileDirty(dirout);

% Read header
header = SDCpckg.Reg.io.NativeBin.serial.HeaderRead(dirin);
HEADER = SDCpckg.Reg.io.NativeBin.serial.HeaderRead(dirout);
assert(strcmp(header.precision,HEADER.precision),...
      'source and destination precision do not match')
assert(header.complex==HEADER.complex,...
      'source and destination complex flags do not match')

[cdims, corg] = SDCpckg.Reg.utils.getLeftChunkInfo(HEADER.size,range,slice);
clen = prod(cdims);
assert(prod(header.size)==clen,'chunk size does not match output file')

% Copy data
SDCpckg.Reg.io.NativeBin.serial.DataBufferedCopy(dirin,dirout,'real',...
    0,corg,clen,header.precision);
if header.complex
    SDCpckg.Reg.io.NativeBin.serial.DataBufferedCopy(dirin,dirout,'imag',...
        0,corg,clen,header.precision);
end
SDCpckg.Reg.io.setFileClean(dirout);
end
