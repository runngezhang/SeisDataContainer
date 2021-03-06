function FileWriteLeftSlice(dirname,x,slice)
%FILEWRITELEFTSLICE Writes serial left slice data to binary file
%
%   FileWriteLeftSlice(DIRNAME,DATA,SLICE) writes
%   the real serial array X into file DIRNAME/FILENAME.
%
%   DIRNAME - A string specifying the directory name
%   DATA    - Distributed data
%   SLICE   - A vector specifying the slice index
%
%   Warning: If the specified dirname exists, it will be removed
narginchk(3, 3);
assert(parpool_size()>0,'parallel pool must be open')
assert(ischar(dirname), 'directory name must be a string')
assert(isdistributed(x), 'data must be distributed')
assert(isvector(slice)|isequal(slice,[]), 'slice index must be a vector')

% Read header
header = SDCpckg.Reg.io.NativeBin.serial.HeaderRead(dirname);
distdim = header.dims - length(slice);
assert(distdim>0,'invalid distributed diemnsion; too many indecies in the slice?')
partition = SDCpckg.Reg.utils.defaultDistribution(header.size(distdim));
if ~header.distributedIO
    header = SDCpckg.Reg.addDistHeaderStruct(header,distdim,partition);
else
    assert(distdim==header.distribution.dim,...
        'distributed dimension of reading request (%d) does not match (%d) in stored file',distdim,header.distribution.dim)
    assert(isequal(partition,header.distribution.partition),'partitioning of reading request does not match stored file')
end

% Write file
csize = SDCpckg.Reg.utils.Cell2Composite(header.distribution.size);
if header.distributedIO
    dirnames = SDCpckg.Reg.utils.Cell2Composite(header.directories);
    spmd
        SDCpckg.Reg.io.NativeBin.dist.DataWriteLeftSlice(1,dirnames,'real',real(x),...
            header.size,csize,[],header.distribution.dim,...
            slice,header.precision);
        if header.complex
            SDCpckg.Reg.io.NativeBin.dist.DataWriteLeftSlice(1,dirnames,'imag',imag(x),...
                header.size,csize,[],header.distribution.dim,...
                slice,header.precision);
        end
    end
else
    cindx_rng = SDCpckg.Reg.utils.Cell2Composite(header.distribution.indx_rng);
    spmd
        SDCpckg.Reg.io.NativeBin.dist.DataWriteLeftSlice(0,dirname,'real',real(x),...
            header.size,csize,cindx_rng,header.distribution.dim,...
            slice,header.precision);
        if header.complex
            SDCpckg.Reg.io.NativeBin.dist.DataWriteLeftSlice(0,dirname,'imag',imag(x),...
                header.size,csize,cindx_rng,header.distribution.dim,...
                slice,header.precision);
        end
    end
end

end
