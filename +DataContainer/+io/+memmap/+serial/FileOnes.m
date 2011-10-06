function FileOnes(dirname,header)
%FILEONES Allocates file space containing ones
%   FileOnes( DIRNAME,HEADER ) allocates file for serial header writing.
%
%   DIRNAME - A string specifying the directory name
%   HEADER  - A header struct specifying the distribution
%  
    global SDCbufferSize;
    DataContainer.io.memmap.serial.FileAlloc(dirname,header);
    
    % Set byte size
    bytesize  = DataContainer.utils.getByteSize(header.precision);
    
    xsize       = header.size;
    header.size = [1 prod(xsize)];
    DataContainer.io.memmap.serial.HeaderWrite(dirname,header);
    
    % Set the sizes
    reminder  = prod(xsize);
    maxbuffer = SDCbufferSize/bytesize;
    rstart = 1;
    
    while (reminder > 0)
        buffer = min(reminder,maxbuffer);
        rend = rstart + buffer - 1;
        r1 = ones(1,buffer);
        DataContainer.io.memmap.serial.FileWriteLeftChunk...
            (dirname,r1,[rstart rend],[]);
        reminder = reminder - buffer;
        rstart   = rend + 1;
    end
    header.size = xsize;
    DataContainer.io.memmap.serial.HeaderWrite(dirname,header);
end