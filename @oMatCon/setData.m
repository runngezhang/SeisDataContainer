function setData(obj,x,data)
%SETDATA is called whenever we assign data to an oMatCon
%
%   setData(OBJ,X,DATA)
%
%   OBJ  - An oMatCon object
%   X    - Subreferences cell
%   DATA - The data we want to assign
%
    i=1;
    while(cell2mat(x(i)) == ':')
        i = i+1;
    end
    chunk = cell2mat(x(i));
    slice = cell2mat(x(i+1:end));
    DataContainer.io.memmap.serial.FileWriteLeftChunk...
        (obj.dirnameIn,data,[chunk(1) chunk(end)],slice);
end
