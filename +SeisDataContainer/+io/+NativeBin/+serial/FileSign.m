function FileSign(dirnameIn,dirnameOut)
%FILESIGN Allocates file space finds the sign of the input file
%
%   FileSign(DIRNAMEIN,DIRNAMEOUT)
%
%   DIRNAMEIN  - A string specifying the input directory name
%   DIRNAMEOUT - A string specifying the output directory name
% 
if(~isdir(dirnameIn))
    error('Error: Directory does not exist')
end

global SDCbufferSize;
headerIn     = SeisDataContainer.io.NativeBin.serial.HeaderRead(dirnameIn);

% Set byte size
bytesize     = SeisDataContainer.utils.getByteSize(headerIn.precision);

SeisDataContainer.io.NativeBin.serial.FileAlloc(dirnameOut,headerIn);
header       = headerIn;
header.size  = [1 prod(headerIn.size)];
SeisDataContainer.io.NativeBin.serial.HeaderWrite(dirnameOut,header);

% Set the sizes
dims         = [1 prod(headerIn.size)];
reminder     = prod(headerIn.size);
maxbuffer    = SDCbufferSize/bytesize;
rstart       = 1;

while (reminder > 0)
    buffer   = min(reminder,maxbuffer);
    rend     = rstart + buffer - 1;
    r1       = SeisDataContainer.io.NativeBin.serial.DataReadLeftChunk...
        (dirnameIn,'real',dims,[rstart rend],[],headerIn.precision,...
        headerIn.precision);
    if headerIn.complex
    dummy    = SeisDataContainer.io.NativeBin.serial.DataReadLeftChunk...
        (dirnameIn,'imag',dims,[rstart rend],[],headerIn.precision,...
        headerIn.precision);
        r1   = complex(r1,dummy);
    end
    SeisDataContainer.io.NativeBin.serial.FileWriteLeftChunk...
        (dirnameOut,sign(r1),[rstart rend],[]);
    reminder = reminder - buffer;
    rstart   = rend + 1;
end
SeisDataContainer.io.NativeBin.serial.HeaderWrite(dirnameOut,headerIn);
end