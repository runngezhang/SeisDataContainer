function deleteDistDir(tmpdirs)
%   deleteDistDir deletes temporary directories
%                on master and worker processes
%
%   deleteDistDir(tmpdirs) takes the following:
%   - TMPDIRS: cell of temporary directories on workers
%
%   Note: deleteDistDir will not clean TMPDIRS if called after
%         closing parallel pool
%
    assert(iscell(tmpdirs),'tmpdir is not a string');
    assert(parpool_size()>0,'parallel pool has to open');
    assert(length(tmpdirs)==parpool_size(),...
    'Fatal error: parallel pool size does not match tmpdirs length');
    tmpdir = SDCpckg.Reg.utils.Cell2Composite(tmpdirs);

    spmd
        if isdir(tmpdir); status = rmdir(tmpdir,'s'); end
        if ~status; warning('Warning: error while removing directory %s on lab %d',tmpdir,labindex); end
    end
end
