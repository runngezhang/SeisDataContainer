function FileGather(dirin,dirout)
% FILEGATHER copies distributed file into serial
%
%   FileGather(DIRIN,DIROUT)
%   Converts distributed file to serial file
%
%   DIRIN   - A string specifying the input file directory
%   DIROUT  - A string specifying the output file directory
%
narginchk(2, 2);
assert(ischar(dirin), 'input directory name must be a string')
assert(ischar(dirout), 'output directory name must be a string')
assert(isdir(dirin),'Fatal error: input directory %s does not exist',dirin);
assert(parpool_size()>0,'parallel pool must be open')

% Read header
hdrin = SDCpckg.Reg.io.NativeBin.serial.HeaderRead(dirin);
assert(hdrin.distributedIO==1,'input file must be distributed')

% update headers
hdrout = hdrin;
hdrout = SDCpckg.Reg.deleteDistHeaderStruct(hdrout);
sldims = hdrin.size(hdrin.distribution.dim+1:end);

% Allocate file
SDCpckg.Reg.io.NativeBin.serial.FileAlloc(dirout,hdrout);

% Copy file
dirnames = SDCpckg.Reg.utils.Cell2Composite(hdrin.directories);
csize_in = SDCpckg.Reg.utils.Cell2Composite(hdrin.distribution.size);
cindx_rng_in = SDCpckg.Reg.utils.Cell2Composite(hdrin.distribution.indx_rng);
spmd
for s=1:prod(sldims)
    slice = SDCpckg.Reg.utils.getSliceIndexS2V(sldims,s);
    x=SDCpckg.Reg.io.NativeBin.dist.DataReadLeftSlice(1,dirnames,'real',...
        hdrin.size,csize_in,[],hdrin.distribution.dim,hdrin.distribution.partition,...
        slice,hdrin.precision,hdrin.precision);
    SDCpckg.Reg.io.NativeBin.dist.DataWriteLeftSlice(0,dirout,'real',x,...
        hdrin.size,csize_in,cindx_rng_in,hdrin.distribution.dim,...
        slice,hdrin.precision);
    if hdrin.complex
        x=SDCpckg.Reg.io.NativeBin.dist.DataReadLeftSlice(1,dirnames,'imag',...
            hdrin.size,csize_in,[],hdrin.distribution.dim,hdrin.distribution.partition,...
            slice,hdrin.precision,hdrin.precision);
        SDCpckg.Reg.io.NativeBin.dist.DataWriteLeftSlice(0,dirout,'imag',x,...
            hdrin.size,csize_in,cindx_rng_in,hdrin.distribution.dim,...
            slice,hdrin.precision);
    end
end
end

end
