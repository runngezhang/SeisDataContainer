function status = releaseIOlock(dirname,varargin)
    assert(ischar(dirname),'dirname must be a string')
    lockname = '_IOlock';

    narginchk(1, 2);
    if nargin > 1
        assert(ischar(varargin{1}),'lock name is not a string');
        lockname = varargin{1};
    end

    lockdir = fullfile(dirname,lockname);
    status = 0;
    assert(isdir(lockdir),'IO lock %s is not a directory or does not exist',lockdir)
    [status msg msgid] = rmdir(lockdir);

end
