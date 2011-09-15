function y = real(a)
    if(~isa(a,'oCon'))
        error('both parameters should be data containers')
    end
    
    global SDCbufferSize;
    % Set byte size
    bytesize  = DataContainer.utils.getByteSize(a.header.precision);
    
    y = oMatCon.zeros(a.dimensions);
    header = a.header;
    header.size = [1 prod(a.header.size)];
    DataContainer.io.memmap.serial.HeaderWrite(y.dirname,header);    
    
    % Set the sizes
    dims      = [1 prod(a.dimensions)];
    reminder  = prod(a.dimensions);
    maxbuffer = SDCbufferSize/bytesize;    
    rstart = 1;
    
    while (reminder > 0)
        buffer = min(reminder,maxbuffer);
        rend = rstart + buffer - 1;
        r1 = DataContainer.io.memmap.serial.DataReadLeftChunk...
            (a.dirname,'real',dims,[rstart rend],[],a.header.precision,a.header.precision);
        if a.header.complex
        dummy = DataContainer.io.memmap.serial.DataReadLeftChunk...
            (a.dirname,'imag',dims,[rstart rend],[],a.header.precision,a.header.precision);
            r1 = complex(r1,dummy);
        end        
        DataContainer.io.memmap.serial.FileWriteLeftChunk...
            (y.dirname,real(r1),[rstart rend],[]);
        reminder = reminder - buffer;
        rstart   = rend + 1;
    end
    DataContainer.io.memmap.serial.HeaderWrite(y.dirname,a.header);
end
