function [tmpdirs, toptmpdir] = makeDistDir(varargin)
%   makeDistDir creates unique temporary directories
%                 on worker processes
%
%   TMPDIRS = makeDistDir()
%       returns new directories created inside of the directory defined by
%       SDClocalTmpDir (see SeisDataContainer_init.m)
%   TMPDIRS = makeDistDir(PARENT)
%       returns new directories created inside of PARENT directory.
%
%   In either case makeDistDir returns:
%   - TMPDIRS: composite of temporary directories for workers
%
    narginchk(0, 1);
    assert(parpool_size()>0,'parallel pool has to be open');
    global SDClocalTmpDir;

    tmpdirs = Composite();

    if nargin > 0
        assert(ischar(varargin{1}),'Fatal error: argument is not a string');
        toptmpdir = varargin{1};
    else
        assert(~isempty(SDClocalTmpDir),'you first need to execute SeisDataContainer_init')
        toptmpdir = SDClocalTmpDir;
    end
    spmd
        tmpdirs = SDCpckg.Reg.io.makeDir(toptmpdir);
    end

    tmpdirs = SDCpckg.Reg.utils.Composite2Cell(tmpdirs);
end
