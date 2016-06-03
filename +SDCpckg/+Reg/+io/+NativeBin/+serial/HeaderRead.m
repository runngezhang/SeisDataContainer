function header = HeaderRead(dirname)
%HEADERREAD Reads header from specified directory
%
%   HeaderRead(DIRNAME) reads the serial header
%   from file DIRNAME/FILENAME.
%
%   DIRNAME - A string specifying the directory name
%
narginchk(1, 1);
assert(ischar(dirname), 'directory name must be a string')
assert(isdir(dirname),'Fatal error: directory %s does not exist',dirname);

% Read header
header = load(fullfile(dirname,'header.mat'));
 
end
