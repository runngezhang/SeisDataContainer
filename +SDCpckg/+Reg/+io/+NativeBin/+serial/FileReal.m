function FileReal(dirnameIn,dirnameOut)
%FILEREAL Real part.
%   FileReal(DIRNAMEIN,DIRNAMEOUT)
%
%   DIRNAMEIN  - A string specifying the input directory
%   DIRNAMEOUT - A string specifying the output directory name

SDCpckg.Reg.io.isFileClean(dirnameIn);
SDCpckg.Reg.io.isFileClean(dirnameOut);
headerOut = SDCpckg.Reg.io.NativeBin.serial.HeaderRead(dirnameIn);
if(headerOut.complex)
    headerOut.complex = 0;
end
SDCpckg.Reg.io.NativeBin.serial.HeaderWrite(dirnameOut,headerOut);
copyfile(fullfile(dirnameIn,'real'),dirnameOut);
end
