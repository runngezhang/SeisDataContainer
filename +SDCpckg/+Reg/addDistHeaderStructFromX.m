function header = addDistHeaderStructFromX(headerin,x)
    assert(isstruct(headerin),'headerin has to be a header struct');
    assert(isdistributed(x),'x has to be distributed');
    assert(parpool_size()>0,'parallel pool has to open');

    header = headerin;
    dims = length(size(x));
    poolsize = parpool_size();
    cdim = Composite();
    csize = Composite();
    cpart = Composite();
    cindecies = Composite();
    header.distribution = struct();

    spmd
        codist = getCodistributor(x);
        cdim = codist.Dimension;
        cpart = codist.Partition;
        csize = header.size;
        csize(cdim) = cpart(labindex);
        cindecies = codist.globalIndices(cdim);
        if isempty(cindecies)
            cindecies = [0 0];
        else
            cindecies = [cindecies(1) cindecies(end)];
        end
    end

    ddim = cdim{1};
    header.distribution.dim = ddim;

    for l=1:poolsize
        dummy = csize{l};
        while length(dummy) < dims
            dummy(end+1) = 1;
        end
        xsize{l} = dummy;
    end
    header.distribution.size = xsize;

    dpart = cpart{1};
    header.distribution.partition = dpart;
    header.distribution.indx_rng = SDCpckg.Reg.utils.Composite2Cell(cindecies);
end
