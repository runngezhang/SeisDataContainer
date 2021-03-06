function setFileDirty(dirname,varargin)
    assert(ischar(dirname),'dirname must be a string')
    assert(isdir(dirname),'dirname %s is not a directory or does not exist',dirname)
    lockname = '_IOinProgress';

    narginchk(1, 2);
    if nargin > 1
        assert(ischar(varargin{1}),'file name is not a string');
        lockname = varargin{1};
    end

    lockfile = fullfile(dirname,lockname);
    assert(~SDCpckg.Reg.io.isFile(lockfile),...
        'File %s\n\tis dirty: either operation in progress or using leftovers from crashed process',dirname)
    SDCpckg.Reg.io.allocFile(lockfile,1,1);
    
end
