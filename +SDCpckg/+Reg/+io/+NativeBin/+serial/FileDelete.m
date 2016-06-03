function FileDelete(dirname)
%FILEDELETE Deletes file from specified directory
%
%   FileDelete(DIRNAME) removes the specified directory
%
%   DIRNAME - A string specifying the directory name
%
%   Warning: The specified directory must exist.

SDCpckg.Reg.io.isFileClean(dirname);
narginchk(1, 1);
assert(ischar(dirname), 'directory name must be a string')

% Read header
header = SDCpckg.Reg.io.NativeBin.serial.HeaderRead(dirname);
assert(~isfield(header,'directories'),'distributed files must be removed with *.dist.FileDelete')
% Delete Directory
if isdir(dirname)
    rmdir(dirname,'s')
else
    warning('SeisDataContainer:NativeBin:serial:FileDelete','directory %s does not exist',dirname);
end
end
