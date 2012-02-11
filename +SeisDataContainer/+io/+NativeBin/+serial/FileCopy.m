function FileCopy (dirnameIn,dirnameOut)
%FILECOPY Copies the entire content of the input directory to the output
%directory
%
%   FileCopy(DIRNAMEIN,DIRNAMEOUT)
%
%   DIRNAMEIN  - A string specifying the input directory
%   DIRNAMEOUT - A string specifying the output directory

SeisDataContainer.io.isFileClean(dirnameIn);
SeisDataContainer.io.isFileClean(dirnameOut);
assert(SeisDataContainer.io.isFileClean(dirnameIn));
SeisDataContainer.io.setFileDirty(dirnameOut);
assert(ischar(dirnameIn), 'directory name must be a string')
assert(ischar(dirnameOut), 'directory name must be a string')
assert(isdir(dirnameIn),'Fatal error: input directory %s does not exist'...
    ,dirnameIn)
assert(isdir(dirnameOut),'Fatal error: output directory %s does not exist'...
    ,dirnameOut)
copyfile([dirnameIn filesep '*'],dirnameOut);
SeisDataContainer.io.setFileClean(dirnameOut);
end