function y = load(dirname)
%ICON.LOAD Loads the file as an iCon

y        = SDCpckg.Reg.io.NativeBin.serial.FileRead(dirname);
y        = iCon(y);
header   = SDCpckg.Reg.io.NativeBin.serial.HeaderRead(dirname);
y.header = header;