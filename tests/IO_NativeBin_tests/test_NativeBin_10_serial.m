function test_suite = test_NativeBin_10_serial
initTestSuite;
end

function test_serial_file_single_complex
%%
    imat          = rand(13,11,9);
    td            = ConDir();
    orig          = complex(imat,1);
    hdr           = SDCpckg.Reg.basicHeaderStructFromX(orig);
    hdr.precision = 'single';
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),orig,hdr);
    new=SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td),'single');
    assert(isequal(single(orig),new))
end

function test_serial_file_double_complex
%%
    imat          = rand(13,11,9);
    td            = ConDir();
    orig          = complex(imat,1);
    hdr           = SDCpckg.Reg.basicHeaderStructFromX(orig);
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),orig,hdr);
    new=SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td),'double');
    assert(isequal(orig,new))
end

function test_serial_file_single_real
%%
    imat = rand(13,11,9);
    td   = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat,'single');
    new  = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td),'single');
    assert(isequal(single(imat),new))
end

function test_serial_file_double_real
%%
    imat = rand(13,11,9);
    td   = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat);
    new  = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td),'double');
    assert(isequal(imat,new))
end

function test_serial_file_LeftSlice_lastNone_single_complex
%%
    imat  = rand(13,11,9);
    td    = ConDir();
    orig=complex(imat,1);
    hdr   = SDCpckg.Reg.basicHeaderStructFromX(orig);
    hdr.precision='single';
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),orig,hdr);
    slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftSlice(path(td),[]);
    assert(isequal(single(orig),slice))
    nmat  = imat+1;
    td=ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftSlice(path(td),nmat,[]);
    smat  = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td),'single');
    assert(isequal(smat,single(nmat)))
end

function test_serial_file_LeftSlice_lastNone_double_complex
%%
    imat  = rand(13,11,9);
    td    = ConDir();
    orig  = complex(imat,1);
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),orig,SDCpckg.Reg.basicHeaderStructFromX(orig));
    slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftSlice(path(td),[]);
    assert(isequal(orig,slice))
    nmat  = imat+1;
    td    = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftSlice(path(td),nmat,[]);
    smat  = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td));
    assert(isequal(smat,nmat))
end

function test_serial_file_LeftSlice_lastNone_single_real
%%
    imat  = rand(13,11,9);
    td    = ConDir();
    hdr   = SDCpckg.Reg.basicHeaderStructFromX(imat);
    hdr.precision='single';
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat,hdr);
    slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftSlice(path(td),[]);
    assert(isequal(single(imat),slice))
    nmat  = imat+1;
    td    = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftSlice(path(td),nmat,[]);
    smat  = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td),'single');
    assert(isequal(smat,single(nmat)))
end

function test_serial_file_LeftSlice_lastNone_double_real
%%
    imat  = rand(13,11,9);
    td    = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat);
    slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftSlice(path(td),[]);
    assert(isequal(imat,slice))
    nmat  = imat+1;
    td    = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftSlice(path(td),nmat,[]);
    smat  = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td));
    assert(isequal(smat,nmat))
end

function test_serial_file_LeftSlice_lastOne_single_complex
%%
    imat  = rand(13,11,9);
    K     = 9;
    td    = ConDir();
    origc = complex(imat,1);
    hdr=SDCpckg.Reg.basicHeaderStructFromX(origc);
    hdr.precision='single';
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),origc,hdr);
    for k = 1:K
        slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftSlice(path(td),[k]);
        orig  = complex(imat(:,:,k),1);
        assert(isequal(single(orig),slice))
    end
    nmat  = imat+1;
    td=ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    for k = 1:K
        SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftSlice(path(td),nmat(:,:,k),[k]);
    end
    smat  = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td),'single');
    assert(isequal(smat,single(nmat)))
end


function test_serial_file_LeftSlice_lastOne_double_complex
%%
    imat  = rand(13,11,9);
    K     = 9;
    td    = ConDir();
    origc = complex(imat,1);
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),origc,SDCpckg.Reg.basicHeaderStructFromX(origc));
    for k = 1:K
        slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftSlice(path(td),[k]);
        orig  = complex(imat(:,:,k),1);
        assert(isequal(orig,slice))
    end
    nmat  = imat+1;
    td    = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    for k = 1:K
        SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftSlice(path(td),nmat(:,:,k),[k]);
    end
    smat  = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td));
    assert(isequal(smat,nmat))
end

function test_serial_file_LeftSlice_lastOne_single_real
%%
    imat  = rand(13,11,9);
    K     = 9;
    td    = ConDir();
    hdr   = SDCpckg.Reg.basicHeaderStructFromX(imat);
    hdr.precision='single';
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat,hdr);
    for k = 1:K
        slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftSlice(path(td),[k]);
        orig  = imat(:,:,k);
        assert(isequal(single(orig),slice))
    end
    nmat  = imat+1;
    td    = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    for k = 1:K
        SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftSlice(path(td),nmat(:,:,k),[k]);
    end
    smat  = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td),'single');
    assert(isequal(smat,single(nmat)))
end

function test_serial_file_LeftSlice_lastOne_double_real
%%
    imat  = rand(13,11,9);
    K     = 9;
    td    = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat);
    for k = 1:K
        slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftSlice(path(td),[k]);
        orig  = imat(:,:,k);
        assert(isequal(orig,slice))
    end
    nmat  = imat+1;
    td    = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    for k = 1:K
        SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftSlice(path(td),nmat(:,:,k),[k]);
    end
    smat  = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td));
    assert(isequal(smat,nmat))
end

function test_serial_file_LeftSlice_lastTwo_single_complex
%%
    imat          = rand(13,11,9);
    J             = 11;
    K             = 9;
    td            = ConDir();
    origc         = complex(imat,1);
    hdr           = SDCpckg.Reg.basicHeaderStructFromX(origc);
    hdr.precision = 'single';
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),origc,hdr);
    for k = 1:K
        for j = 1:J
        slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftSlice(path(td),[j,k]);
        orig  = complex(imat(:,j,k),1);
        assert(isequal(single(orig),slice))
        end
    end
    nmat  = imat+1;
    td=ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    for k = 1:K
        for j=1:J
        SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftSlice(path(td),nmat(:,j,k),[j,k]);
        end
    end
    smat  = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td),'single');
    assert(isequal(smat,single(nmat)))
end

function test_serial_file_LeftSlice_lastTwo_double_complex
%%
    imat  = rand(13,11,9);
    J     = 11;
    K     = 9;
    td    = ConDir();
    origc = complex(imat,1);
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),origc,SDCpckg.Reg.basicHeaderStructFromX(origc));
    for k = 1:K
        for j = 1:J
        slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftSlice(path(td),[j,k]);
        orig  = complex(imat(:,j,k),1);
        assert(isequal(orig,slice))
        end
    end
    nmat  = imat+1;
    td    = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    for k = 1:K
        for j=1:J
        SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftSlice(path(td),nmat(:,j,k),[j,k]);
        end
    end
    smat  = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td));
    assert(isequal(smat,nmat))
end

function test_serial_file_LeftSlice_lastTwo_single_real
%%
    imat          = rand(13,11,9);
    J             = 11;
    K             = 9;
    td            = ConDir();
    hdr           = SDCpckg.Reg.basicHeaderStructFromX(imat);
    hdr.precision = 'single';
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat,hdr);
    for k = 1:K
        for j = 1:J
        slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftSlice(path(td),[j,k]);
        orig  = imat(:,j,k);
        assert(isequal(single(orig),slice))
        end
    end
    nmat  = imat+1;
    td=ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    for k = 1:K
        for j = 1:J
        SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftSlice(path(td),nmat(:,j,k),[j,k]);
        end
    end
    smat  = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td),'single');
    assert(isequal(smat,single(nmat)))
end

function test_serial_file_LeftSlice_lastTwo_double_real
%%
    imat  = rand(13,11,9);
    J     = 11;
    K     = 9;
    td    = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat);
    for k = 1:K
        for j = 1:J
        slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftSlice(path(td),[j,k]);
        orig  = imat(:,j,k);
        assert(isequal(orig,slice))
        end
    end
    nmat = imat+1;
    td   = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    for k = 1:K
        for j = 1:J
        SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftSlice(path(td),nmat(:,j,k),[j,k]);
        end
    end
    smat  = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td));
    assert(isequal(smat,nmat))
end

function test_serial_file_LeftChunk_lastNone_single_complex
%%
    imat          = rand(13,11,9);
    K             = 9;
    td            = ConDir();
    origc         = complex(imat,1);
    hdr           = SDCpckg.Reg.basicHeaderStructFromX(origc);
    hdr.precision = 'single';
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),origc,hdr);
    for k = 1:K-2
        slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftChunk(path(td),[k k+2],[]);
        orig  = complex(imat(:,:,k:k+2),1);
        assert(isequal(single(orig),slice))
    end
    td   = ConDir();
    nmat = imat+1;
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,:,1:2),[1 2],[]);
    SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,:,3:K),[3 K],[]);
    smat = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td),'single');
    assert(isequal(smat,single(nmat)))
end

function test_serial_file_LeftChunk_lastNone_double_complex
%%
    imat  = rand(13,11,9);
    K     = 9;
    td    = ConDir();
    origc = complex(imat,1);
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),origc,SDCpckg.Reg.basicHeaderStructFromX(origc));
    for k = 1:K-2
        slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftChunk(path(td),[k k+2],[]);
        orig  = complex(imat(:,:,k:k+2),1);
        assert(isequal(orig,slice))
    end
    nmat = imat+1;
    td   = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,:,1:2),[1 2],[]);
    SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,:,3:K),[3 K],[]);
    smat = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td));
    assert(isequal(smat,nmat))
end

function test_serial_file_LeftChunk_lastNone_single_real
%%
    imat          = rand(13,11,9);
    K             = 9;
    td            = ConDir();
    hdr           = SDCpckg.Reg.basicHeaderStructFromX(imat);
    hdr.precision = 'single';
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat,hdr);
    for k = 1:K-2
        slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftChunk(path(td),[k k+2],[]);
        orig  = imat(:,:,k:k+2);
        assert(isequal(single(orig),slice))
    end
    nmat = imat+1;
    td   = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,:,1:2),[1 2],[]);
    SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,:,3:K),[3 K],[]);
    smat = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td),'single');
    assert(isequal(smat,single(nmat)))
end

function test_serial_file_LeftChunk_lastNone_double_real
%%
    imat  = rand(13,11,9);
    K     = 9;
    td    = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat);
    for k = 1:K-2
        slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftChunk(path(td),[k k+2],[]);
        orig  = imat(:,:,k:k+2);
        assert(isequal(orig,slice))
    end
    nmat = imat+1;
    td   = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,:,1:2),[1 2],[]);
    SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,:,3:K),[3 K],[]);
    smat = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td));
    assert(isequal(smat,nmat))
end

function test_serial_file_LeftChunk_lastOne_single_complex
%%
    imat          = rand(13,11,9);
    J             = 11;
    K             = 9;
    td            = ConDir();
    origc         = complex(imat,1);
    hdr           = SDCpckg.Reg.basicHeaderStructFromX(origc);
    hdr.precision = 'single';
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),origc,hdr);
    for k = 1:K
        for j = 1:J-2
            slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftChunk(path(td),[j j+2],[k]);
            orig  = complex(imat(:,j:j+2,k),1);
            assert(isequal(single(orig),slice))
        end
    end
    nmat = imat+1;
    td   = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    for k=1:K
        SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,1:2,k),[1 2],[k]);
        SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,3:J,k),[3 J],[k]);
    end
    smat = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td),'single');
    assert(isequal(smat,single(nmat)))
end

function test_serial_file_LeftChunk_lastOne_double_complex
%%
    imat  = rand(13,11,9);
    J     = 11;
    K     = 9;
    td    = ConDir();
    origc = complex(imat,1);
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),origc,SDCpckg.Reg.basicHeaderStructFromX(origc));
    for k = 1:K
        for j = 1:J-2
            slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftChunk(path(td),[j j+2],[k]);
            orig  = complex(imat(:,j:j+2,k),1);
            assert(isequal(orig,slice))
        end
    end
    nmat  = imat+1;
    td    = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    for k = 1:K
        SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,1:2,k),[1 2],[k]);
        SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,3:J,k),[3 J],[k]);
    end
    smat  = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td));
    assert(isequal(smat,nmat))
end

function test_serial_file_LeftChunk_lastOne_single_real
%%
    imat          = rand(13,11,9);
    J             = 11;
    K             = 9;
    td            = ConDir();
    hdr           = SDCpckg.Reg.basicHeaderStructFromX(imat);
    hdr.precision = 'single';
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat,hdr);
    for k = 1:K
        for j = 1:J-2
            slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftChunk(path(td),[j j+2],[k]);
            orig  = imat(:,j:j+2,k);
            assert(isequal(single(orig),slice))
        end
    end
    nmat  = imat+1;
    td    = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    for k = 1:K
        SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,1:2,k),[1 2],[k]);
        SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,3:J,k),[3 J],[k]);
    end
    smat  = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td),'single');
    assert(isequal(smat,single(nmat)))
end

function test_serial_file_LeftChunk_lastOne_double_real
%%
    imat  = rand(13,11,9);
    J     = 11;
    K     = 9;
    td    = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(td),imat);
    for k = 1:K
        for j = 1:J-2
            slice = SDCpckg.Reg.io.NativeBin.serial.FileReadLeftChunk(path(td),[j j+2],[k]);
            orig  = imat(:,j:j+2,k);
            assert(isequal(orig,slice))
        end
    end
    nmat  = imat+1;
    td    = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileAlloc(path(td),SDCpckg.Reg.basicHeaderStructFromX(nmat));
    for k = 1:K
        SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,1:2,k),[1 2],[k]);
        SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk(path(td),nmat(:,3:J,k),[3 J],[k]);
    end
    smat  = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(td));
    assert(isequal(smat,nmat))
end

function test_serial_file_Transpose_double_real
%%
    imat             = rand(13,11);
    header           = SDCpckg.Reg.basicHeaderStructFromX(imat);
    in               = ConDir();
    out              = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(in),imat,header);
    SDCpckg.Reg.io.NativeBin.serial.FileTranspose(path(in),path(out),1);
    x                = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(out));
    assert(isequal(transpose(imat),x))
end

function test_serial_file_Transpose_double_complex
%%
    imat             = rand(13,11);
    imat             = complex(imat,1);
    header           = SDCpckg.Reg.basicHeaderStructFromX(imat);
    in               = ConDir();
    out              = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(in),imat,header);
    SDCpckg.Reg.io.NativeBin.serial.FileTranspose(path(in),path(out),1);
    x                = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(out));
    assert(isequal(transpose(imat),x))
end

function test_serial_file_Transpose_single_real
%%
    imat             = rand(13,11);
    header           = SDCpckg.Reg.basicHeaderStructFromX(imat);
    header.precision = 'single';
    in               = ConDir();
    out              = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(in),imat,header);
    SDCpckg.Reg.io.NativeBin.serial.FileTranspose(path(in),path(out),1);
    x                = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(out),'single');
    assert(isequal(single(transpose(imat)),x))
end

function test_serial_file_Transpose_single_complex
%%
    imat             = rand(13,11);
    imat             = complex(imat,1);
    header           = SDCpckg.Reg.basicHeaderStructFromX(imat);
    header.precision = 'single';
    in               = ConDir();
    out              = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(in),imat,header);
    SDCpckg.Reg.io.NativeBin.serial.FileTranspose(path(in),path(out),1);
    x                = SDCpckg.Reg.io.NativeBin.serial.FileRead(path(out),'single');
    assert(isequal(single(transpose(imat)),x))
end

function test_serial_file_Norm_double_real
%%
    imat   = rand(14,12,5);
    in     = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(in),imat);
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),0);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),0);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),1);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),1);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),2);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),2);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),inf);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),inf);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),-inf);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),-inf);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),'fro');
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),'fro');
    assertElementsAlmostEqual(x,n)
end

function test_serial_file_Norm_double_complex
%%
    imat   = rand(14,12,5);
    imat   = complex(imat,imat);
    in     = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(in),imat);
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),0);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),0);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),1);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),1);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),2);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),2);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),inf);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),inf);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),-inf);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),-inf);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),'fro');
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),'fro');
    assertElementsAlmostEqual(x,n)
end

function test_serial_file_Norm_single_real
%%
    imat   = single(rand(14,12,5));
    in     = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(in),imat);
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),0);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),0);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),1);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),1);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),2);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),2);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),inf);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),inf);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),-inf);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),-inf);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),'fro');
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),'fro');
    assertElementsAlmostEqual(x,n)
end

function test_serial_file_Norm_single_complex
%%
    imat   = single(rand(14,12,5));
    imat   = complex(imat,imat);
    in     = ConDir();
    SDCpckg.Reg.io.NativeBin.serial.FileWrite(path(in),imat);
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),0);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),0);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),1);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),1);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),2);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),2);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),inf);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),inf);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),-inf);
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),-inf);
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.NativeBin.serial.FileNorm(path(in),'fro');
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),'fro');
    assertElementsAlmostEqual(x,n)
end

function test_serial_file_copy_left_chunk_single_real
%%
    I=randi([5 15],1); J=randi([5 15],1); K=randi([5 15],1);
    imat=rand(I,J,K);
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
end

function test_serial_file_copy_left_chunk_single_complex
%%
    I=randi([5 15],1); J=randi([5 15],1); K=randi([5 15],1);
    imat=rand(I,J,K);
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
end

function test_serial_file_copy_left_chunk_double_real
%%
    I=randi([5 15],1); J=randi([5 15],1); K=randi([5 15],1);
    imat=rand(I,J,K);
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
end

function test_serial_file_copy_left_chunk_double_complex
%%
    I=randi([5 15],1); J=randi([5 15],1); K=randi([5 15],1);
    imat=rand(I,J,K);
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
end
