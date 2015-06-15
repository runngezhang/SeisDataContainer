function test_serial()
if isempty(whos('global','SDCglobalTmpDir'))
    SeisDataContainer_init();
end
disp('Start');
tic;
I=13; J=11; K=9;
imat=rand(I,J,K);
%for i=1:I
%   for j=1:J
%       for k=1:K
%           imat(i,j,k)=i*10+j*100+k*1000;
%       end
%   end
%end
whos imat
%disp(norm(imat(:)))

disp('*****');
disp('SDCpckg.Reg.io.NativeBin.serial.File* single complex');
td=ConDir();
orig=complex(imat,1);
hdr=SDCpckg.Reg.basicHeaderStructFromX(orig);
hdr.precision='single';
SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),orig,hdr);
new=SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td),'single');
assert(isequal(single(orig),new))
dir(td)

disp('*****');
disp('SDCpckg.Reg.io.NativeBin.serial.File* double complex');
td=ConDir();
orig=complex(imat,1);
SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),orig,SDCpckg.Reg.basicHeaderStructFromX(orig));
new=SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td),'double');
assert(isequal(orig,new))
dir(td)

disp('*****');
disp('SDCpckg.Reg.io.NativeBin.serial.File* single real');
td=ConDir();
SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat,'single');
new=SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td),'single');
assert(isequal(single(imat),new))
dir(td)

disp('*****');
disp('SDCpckg.Reg.io.NativeBin.serial.File* double real');
td=ConDir();
SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat);
new=SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td),'double');
assert(isequal(imat,new))
dir(td)

disp('*****');
disp('SDCpckg.Reg.io.NativeBin.serial.File*LeftSlice last none');
td=ConDir();
SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat);
slice=SDCpckg.Reg.io.NativeBin.serial.FileReadLeftSlice(path(td),[]);
assert(isequal(imat,slice))
nmat = imat+1;
td=ConDir();
SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftSlice(path(td),nmat,[]);
smat = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td));
assert(isequal(smat,nmat))
dir(td)

disp('*****');
disp('SDCpckg.Reg.io.NativeBin.serial.File*LeftSlice last one');
td=ConDir();
SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat);
for k=1:K
    slice=SDCpckg.Reg.io.NativeBin.serial.FileReadLeftSlice(path(td),[k]);
    orig=imat(:,:,k);
    assert(isequal(orig,slice))
end
nmat = imat+1;
td=ConDir();
SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
for k=1:K
    SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftSlice(path(td),nmat(:,:,k),[k]);
end
smat = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td));
assert(isequal(smat,nmat))
dir(td)

disp('*****');
disp('SDCpckg.Reg.io.NativeBin.serial.File*LeftSlice last two');
td=ConDir();
SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat);
for k=1:K
    for j=1:J
    slice=SDCpckg.Reg.io.NativeBin.serial.FileReadLeftSlice(path(td),[j,k]);
    orig=imat(:,j,k);
    assert(isequal(orig,slice))
    end
end
nmat = imat+1;
td=ConDir();
SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
for k=1:K
    for j=1:J
    SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftSlice(path(td),nmat(:,j,k),[j,k]);
    end
end
smat = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td));
assert(isequal(smat,nmat))
dir(td)

disp('*****');
disp('SDCpckg.Reg.io.NativeBin.serial.File*LeftChunk last none');
td=ConDir();
SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat);
for k=1:K-2
    slice=SDCpckg.Reg.io.NativeBin.serial.FileReadLeftChunk(path(td),[k k+2],[]);
    orig=imat(:,:,k:k+2);
    assert(isequal(orig,slice))
end
nmat = imat+1;
td=ConDir();
SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,:,1:2),[1 2],[]);
SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,:,3:K),[3 K],[]);
smat = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td));
assert(isequal(smat,nmat))
dir(td)

disp('*****');
disp('SDCpckg.Reg.io.NativeBin.serial.File*LeftChunk last one');
td=ConDir();
SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat);
for k=1:K
    for j=1:J-2
        slice=SDCpckg.Reg.io.NativeBin.serial.FileReadLeftChunk(path(td),[j j+2],[k]);
        orig=imat(:,j:j+2,k);
        assert(isequal(orig,slice))
    end
end
nmat = imat+1;
td=ConDir();
SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
for k=1:K
    SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,1:2,k),[1 2],[k]);
    SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,3:J,k),[3 J],[k]);
end
smat = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td));
assert(isequal(smat,nmat))
dir(td)

disp('*****');
disp('SDCpckg.Reg.io.NativeBin.serial.FileCopyLeftChunk*File single real');
tb=ConDir();
ts=ConDir();
cs=randi([1 J],1);
ce=randi([cs J],1);
si=randi([1 K],1);
large=single(imat);
small=large(:,cs:ce,si);
hdrb=SDCpckg.Reg.basicHeaderStructFromX(large);
SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(tb),large,hdrb);
hdrs=SDCpckg.Reg.basicHeaderStructFromX(small);
SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(ts),hdrs);
SDCpckg.Reg.io.NativeBin.serial.FileCopyLeftChunkToFile(path(tb),path(ts),[cs ce],[si]);
SDCpckg.Reg.io.NativeBin.serial.FileCopyLeftChunkFromFile(path(ts),path(tb),[cs ce],[si]);
new=SDCpckg.Reg.io.NativeBin.serial.FileRead(path(tb));
assert(isequal(large,new))
dir(tb)
dir(ts)

disp('*****');
disp('SDCpckg.Reg.io.NativeBin.serial.FileCopyLeftChunk*File single complex');
tb=ConDir();
ts=ConDir();
cs=randi([1 J],1);
ce=randi([cs J],1);
si=randi([1 K],1);
large=single(complex(imat,1));
small=large(:,cs:ce,si);
hdrb=SDCpckg.Reg.basicHeaderStructFromX(large);
SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(tb),large,hdrb);
hdrs=SDCpckg.Reg.basicHeaderStructFromX(small);
SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(ts),hdrs);
SDCpckg.Reg.io.NativeBin.serial.FileCopyLeftChunkToFile(path(tb),path(ts),[cs ce],[si]);
SDCpckg.Reg.io.NativeBin.serial.FileCopyLeftChunkFromFile(path(ts),path(tb),[cs ce],[si]);
new=SDCpckg.Reg.io.NativeBin.serial.FileRead(path(tb));
assert(isequal(large,new))
dir(tb)
dir(ts)


disp('*****');
disp('SDCpckg.Reg.io.NativeBin.serial.FileCopyLeftChunk*File double real');
tb=ConDir();
ts=ConDir();
cs=randi([1 J],1);
ce=randi([cs J],1);
si=randi([1 K],1);
large=imat;
small=large(:,cs:ce,si);
hdrb=SDCpckg.Reg.basicHeaderStructFromX(large);
SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(tb),large,hdrb);
hdrs=SDCpckg.Reg.basicHeaderStructFromX(small);
SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(ts),hdrs);
SDCpckg.Reg.io.NativeBin.serial.FileCopyLeftChunkToFile(path(tb),path(ts),[cs ce],[si]);
SDCpckg.Reg.io.NativeBin.serial.FileCopyLeftChunkFromFile(path(ts),path(tb),[cs ce],[si]);
new=SDCpckg.Reg.io.NativeBin.serial.FileRead(path(tb));
assert(isequal(large,new))
dir(tb)
dir(ts)


disp('*****');
disp('SDCpckg.Reg.io.NativeBin.serial.FileCopyLeftChunk*File double complex');
tb=ConDir();
ts=ConDir();
cs=randi([1 J],1);
ce=randi([cs J],1);
si=randi([1 K],1);
large=complex(imat,1);
small=large(:,cs:ce,si);
hdrb=SDCpckg.Reg.basicHeaderStructFromX(large);
SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(tb),large,hdrb);
hdrs=SDCpckg.Reg.basicHeaderStructFromX(small);
SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(ts),hdrs);
SDCpckg.Reg.io.NativeBin.serial.FileCopyLeftChunkToFile(path(tb),path(ts),[cs ce],[si]);
SDCpckg.Reg.io.NativeBin.serial.FileCopyLeftChunkFromFile(path(ts),path(tb),[cs ce],[si]);
new=SDCpckg.Reg.io.NativeBin.serial.FileRead(path(tb));
assert(isequal(large,new))
dir(tb)
dir(ts)

disp('Done');
disp(toc);
end
