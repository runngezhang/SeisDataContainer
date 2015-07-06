function FileDelete(dirname)
%FILEDELETE removes the specified directory
%
%   FILEDELETE(DIRNAME)
%
%   DIRNAME - A string specifying the directory name
%
error(nargchk(1, 1, nargin, 'struct'));
assert(parpool_size()>0,'parallel pool must be open')
assert(ischar(dirname), 'directory name must be a string')

% Read header
header = SDCpckg.Reg.io.NativeBin.serial.HeaderRead(dirname);
assert(isfield(header,'directories'),'serial files must be removed with *.serial.FileDelete')
tmpdirs = SDCpckg.Reg.utils.Cell2Composite(header.directories);
% Delete Directory
spmd
    if isdir(tmpdirs)
        rmdir(tmpdirs,'s');
    else
        warning('SeisDataContainer:NativeBin:serial:FileDelete','directory %s does not exist',tmpdirs);
    end
end
if isdir(dirname)
    rmdir(dirname,'s');
else
    warning('SeisDataContainer:NativeBin:serial:FileDelete','directory %s does not exist',dirname);
end

end
