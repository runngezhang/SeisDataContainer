function FileImag(dirnameIn,dirnameOut)
%FILEIMAG Complex imaginary part.
%   FileImag(DIRNAMEIN,DIRNAMEOUT)
%
%   DIRNAMEIN  - A string specifying the input directory
%   DIRNAMEOUT - A string specifying the output directory name

SDCpckg.Reg.io.isFileClean(dirnameOut);
SDCpckg.Reg.io.isFileClean(dirnameIn);
headerOut = SDCpckg.Reg.io.NativeBin.serial.HeaderRead(dirnameIn);
if(~headerOut.complex)
    error('Epic fail: The dataContainer is not complex')
end
headerOut.complex = 0;
SDCpckg.Reg.io.NativeBin.serial.HeaderWrite(dirnameOut,headerOut);
copyfile(fullfile(dirnameIn,'imag'),fullfile(dirnameOut,'real'));
end
