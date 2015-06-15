function y = load(dirname)
%PICON.LOAD Loads the file as an piCon

y        = SDCpckg.Reg.io.NativeBin.serial.FileRead(dirname);
y        = distributed(y);
y        = piCon(y);
header   = SDCpckg.Reg.io.NativeBin.serial.HeaderRead(dirname);
y.header = header;  