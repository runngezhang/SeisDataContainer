function FileDelete(dirname)
%FILEDELETE Deletes file from specified directory
%
%   FileDelete(DIRNAME) removes the specified directory
%
%   DIRNAME - A string specifying the directory name
%
%   Warning: The specified directory must exist.
narginchk(1, 1);
assert(ischar(dirname), 'directory name must be a string')

% Make Directory
if isdir(dirname)
    rmdir(dirname,'s')
else
    warning('SeisDataContainer:memmap:serial:FileDelete','directory %s does not exist',dirname);
end

end
