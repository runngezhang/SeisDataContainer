function test_suite = test_JS_10_serial
initTestSuite;
end

function test_serial_file_single_real
%%
    SeisDataContainer_init ;
    path = 'newtest' ;
    x    = [13,11,19] ;
    imat = rand(x);
    td   = ConDir();
    % hdr  = SDCpckg.Reg.basicHeaderStruct(x,'single',0);
    hdr=SDCpckg.Reg.basicHeaderStruct(x,'single',0,'varName',...
    'velocity','varUnits','m/s','origin',[0 0 0],'delta',[1 1 1],'unit',...
    {'m','m','m'},'label',{'x','y','z'})

  %   SDCpckg.Reg.io.JavaSeis.serial.FileAlloc(path,hdr) ;
   
    % FileAlloc
    SDCpckg.Reg.io.setFileDirty('newtest')
    SDCpckg.Reg.io.JavaSeis.serial.HeaderWrite(path,hdr) ;
    SDCpckg.Reg.io.setFileClean('newtest')
  
    SDCpckg.Reg.io.JavaSeis.serial.FileWrite(path,imat,'single');
    new  = SDCpckg.Reg.io.JavaSeis.serial.FileRead(path,'single');
    
    class(single(imat))
    class(single(new))
    
    assert(isequal(single(imat),new))
end

function test_serial_file_LeftSlice_lastNone_single_real
%%
    SeisDataContainer_init ;
    path = 'newtest' ;
    x    = [13,11,19] ;
    imat  = rand(x)
    td    = ConDir();
%    hdr  = SDCpckg.Reg.basicHeaderStruct(x,'single',0);
    hdr=SDCpckg.Reg.basicHeaderStruct(x,'single',0,'varName',...
    'velocity','varUnits','m/s','origin',[0 0 0],'delta',[1 1 1],'unit',...
    {'m','m','m'},'label',{'x','y','z'})

    hdr.precision='single';
    
    % FileAlloc
    SDCpckg.Reg.io.setFileDirty('newtest')
    SDCpckg.Reg.io.JavaSeis.serial.HeaderWrite(path,hdr) ;
    SDCpckg.Reg.io.setFileClean('newtest')
    
    SDCpckg.Reg.io.JavaSeis.serial.FileWrite(path,imat,hdr);
    slice = SDCpckg.Reg.io.JavaSeis.serial.FileReadLeftSlice(path,[])
    assert(isequal(single(imat(:,:,end)),slice))
    nmat  = imat+1;
    SeisDataContainer_init ;
    td    = ConDir();
    hdr2  = SDCpckg.Reg.basicHeaderStruct(x,'single',0);
    hdr2.precision='single';
    SDCpckg.Reg.io.JavaSeis.serial.FileAlloc(path,hdr2);
    SDCpckg.Reg.io.JavaSeis.serial.FileWriteLeftSlice(path,nmat,[]);
    smat  = SDCpckg.Reg.io.JavaSeis.serial.FileRead(path,'single');
    assert(isequal(smat,single(nmat)))
   
end

function test_serial_file_LeftSlice_lastOne_single_real
%%
    SeisDataContainer_init ;
    path = 'newtest' ;
    x    = [13,11,19] ;
    imat  = rand(x) ;
    K     = 19 ;
    td    = ConDir() ;
%    hdr  = SDCpckg.Reg.basicHeaderStruct(x,'single',0);

     hdr=SDCpckg.Reg.basicHeaderStruct(x,'single',0,'varName',...
    'velocity','varUnits','m/s','origin',[0 0 0],'delta',[1 1 1],'unit',...
    {'m','m','m'},'label',{'x','y','z'})

    hdr.precision='single';
    
    % FileAlloc
    SDCpckg.Reg.io.setFileDirty('newtest')
    SDCpckg.Reg.io.JavaSeis.serial.HeaderWrite(path,hdr) ;
    SDCpckg.Reg.io.setFileClean('newtest')
    
    SDCpckg.Reg.io.JavaSeis.serial.FileWrite(path,imat,hdr);
    for k = 1:K
        mytest = k
        slice = SDCpckg.Reg.io.JavaSeis.serial.FileReadLeftSlice(path,[k 1])
        orig  = imat(:,:,k)
        assert(isequal(single(orig),slice))
    end
    nmat  = imat+1
    
    SeisDataContainer_init ;
    td    = ConDir();
    hdr2  = SDCpckg.Reg.basicHeaderStruct(x,'single',0);
    hdr2.precision='single';
    SDCpckg.Reg.io.JavaSeis.serial.FileAlloc(path,hdr2) ;
    for k = 1:K
        mytest2 =k
        SDCpckg.Reg.io.JavaSeis.serial.FileWriteLeftSlice(path,nmat(:,:,k),[k 1]);
    end
    smat  = SDCpckg.Reg.io.JavaSeis.serial.FileRead(path,'single')
    single(nmat)
    assert(isequal(smat,single(nmat)))
end

function test_serial_file_LeftChunk_lastOne_single_real
%%
    global globalTable
    
    SeisDataContainer_init ;
    path = 'newtest' ;
    x    = [13,11,9] ;
 
    globalTable = zeros(x);
    imat  = rand(x) ;
    
    J=11;
    K=9;
  
    td    = ConDir() ;
   % hdr  = SDCpckg.Reg.basicHeaderStruct(x,'single',0);
   
     hdr=SDCpckg.Reg.basicHeaderStruct(x,'single',0,'varName',...
    'velocity','varUnits','m/s','origin',[0 0 0],'delta',[1 1 1],'unit',...
    {'m','m','m'},'label',{'x','y','z'})
   
    hdr.precision='single';
    
    % FileAlloc
    SDCpckg.Reg.io.setFileDirty('newtest')
    SDCpckg.Reg.io.JavaSeis.serial.HeaderWrite(path,hdr) ;
    SDCpckg.Reg.io.setFileClean('newtest')
    
    SDCpckg.Reg.io.JavaSeis.serial.FileWrite(path,imat,hdr);
    
    for k = 1:K
        for j = 1:J-2
            slice = SDCpckg.Reg.io.JavaSeis.serial.FileReadLeftChunk(path,[j j+2],[k 1]);
            orig  = imat(:,j:j+2,k);
            assert(isequal(single(orig),slice)) 
        end
    end
    
    J=11;
    K=9;
    
    SeisDataContainer_init ;
  
    nmat  = imat+1
    td    = ConDir();
    hdr  = SDCpckg.Reg.basicHeaderStruct(x,'single',0);
    hdr.precision='single';
    SDCpckg.Reg.io.JavaSeis.serial.FileAlloc(path,hdr) ;
 
    for k = 1:K
        SDCpckg.Reg.io.JavaSeis.serial.FileWriteLeftChunk(path,nmat(:,1:2,k),[1 2],[k 1]) 
        SDCpckg.Reg.io.JavaSeis.serial.FileWriteLeftChunk(path,nmat(:,3:J,k),[3 J],[k 1]) 
    end
    smat  = SDCpckg.Reg.io.JavaSeis.serial.FileRead(path,'single')
    single(nmat)
    assert(isequal(smat,single(nmat))) 
end

function test_serial_file_LeftChunk_lastNone_single_real
%%
   
    global globalTable

    SeisDataContainer_init ;
    path = 'newtest' ;
    x    = [13,11,9] ;
  
    globalTable = zeros(x);
    imat  = rand(x) ;
  
    K     = 9 ;
   
    td   = ConDir() ;
   % hdr  = SDCpckg.Reg.basicHeaderStruct(x,'single',0);
   
     hdr=SDCpckg.Reg.basicHeaderStruct(x,'single',0,'varName',...
    'velocity','varUnits','m/s','origin',[0 0 0],'delta',[1 1 1],'unit',...
    {'m','m','m'},'label',{'x','y','z'})
   
    hdr.precision='single';
    
    % FileAlloc
    SDCpckg.Reg.io.setFileDirty('newtest')
    SDCpckg.Reg.io.JavaSeis.serial.HeaderWrite(path,hdr) ;
    SDCpckg.Reg.io.setFileClean('newtest')
    
    SDCpckg.Reg.io.JavaSeis.serial.FileWrite(path,imat,hdr);
    mytest = 1
    for k = 1:K-2
        
        slice = SDCpckg.Reg.io.JavaSeis.serial.FileReadLeftChunk(path,[k k+2],[])
        orig  = imat(:,:,k:k+2)
        assert(isequal(single(orig),slice))
        
    end

    SeisDataContainer_init ;
    nmat = imat+1;
    td   = ConDir();
    hdr2  = SDCpckg.Reg.basicHeaderStruct(x,'single',0);
    hdr2.precision='single';
    mytest = 2
     single(nmat)
    SDCpckg.Reg.io.JavaSeis.serial.FileAlloc(path,hdr2) ;
    SDCpckg.Reg.io.JavaSeis.serial.FileWriteLeftChunk(path,nmat(:,:,1:2),[1 2],[])
    SDCpckg.Reg.io.JavaSeis.serial.FileWriteLeftChunk(path,nmat(:,:,3:K),[3 K],[])
    smat = SDCpckg.Reg.io.JavaSeis.serial.FileRead(path,'single')
    single(nmat)
    assert(isequal(smat,single(nmat)))
end


function test_serial_file_LeftChunk_lastOne_single_real
%%
   
    SeisDataContainer_init ;
    path = 'newtest' ;
    x    = [13,11,9] ;
    imat  = rand(x) ;
    J             = 11;
    K             = 9;
    td    = ConDir() ;
 %   hdr  = SDCpckg.Reg.basicHeaderStruct(x,'single',0);
 
    hdr=SDCpckg.Reg.basicHeaderStruct(x,'single',0,'varName',...
    'velocity','varUnits','m/s','origin',[0 0 0],'delta',[1 1 1],'unit',...
    {'m','m','m'},'label',{'x','y','z'})
 
    hdr.precision='single';
    
    % FileAlloc
    SDCpckg.Reg.io.setFileDirty('newtest')
    SDCpckg.Reg.io.JavaSeis.serial.HeaderWrite(path,hdr) ;
    SDCpckg.Reg.io.setFileClean('newtest')
    
    SDCpckg.Reg.io.JavaSeis.serial.FileWrite(path,imat,hdr);
    
    for k = 1:K
        for j = 1:J-2
            slice = SDCpckg.Reg.io.JavaSeis.serial.FileReadLeftChunk(path,[j j+2],[k 1]);
            orig  = imat(:,j:j+2,k);
            assert(isequal(single(orig),slice)) ;
        end
    end
    
    
end

function test_serial_file_Norm_double_real
%%
    SeisDataContainer_init ;
    path = 'newtest' ;
    SDCpckg.Reg.io.isFileClean(path);
    SeisDataContainer_init ;
    x    = [14,12,5] ;
    imat  = rand(x) ;
    imat = double(imat) ;
    td    = ConDir() ;
   % hdr  = SDCpckg.Reg.basicHeaderStruct(x,'double',0);
   
     hdr=SDCpckg.Reg.basicHeaderStruct(x,'single',0,'varName',...
    'velocity','varUnits','m/s','origin',[0 0 0],'delta',[1 1 1],'unit',...
    {'m','m','m'},'label',{'x','y','z'})
   
    hdr.precision='double';
    
    % FileAlloc
    SDCpckg.Reg.io.setFileDirty('newtest')
    SDCpckg.Reg.io.JavaSeis.serial.HeaderWrite(path,hdr) ;
    SDCpckg.Reg.io.setFileClean('newtest')
    
    SDCpckg.Reg.io.JavaSeis.serial.FileWrite(path,imat,hdr);
    n      = SDCpckg.Reg.io.JavaSeis.serial.FileNorm(path,0,'double') 
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),0) 
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.JavaSeis.serial.FileNorm(path,1,'double')
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),1)
    assertElementsAlmostEqual(x,n)
    n     = SDCpckg.Reg.io.JavaSeis.serial.FileNorm(path,2,'double')
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),2)
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.JavaSeis.serial.FileNorm(path,inf,'double')
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),inf)
    assertElementsAlmostEqual(x,n)
    n    = SDCpckg.Reg.io.JavaSeis.serial.FileNorm(path,-inf,'double')
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),-inf)
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.JavaSeis.serial.FileNorm(path,'fro','double')
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),'fro')
    assertElementsAlmostEqual(x,n)
end

function test_serial_file_Norm_single_real
%%
    SeisDataContainer_init ;
    path = 'newtest' ;
    SDCpckg.Reg.io.isFileClean(path);
    SeisDataContainer_init ;
    x    = [14,12,5] ;
    imat  = rand(x) ;
    td    = ConDir() ;
 %   hdr  = SDCpckg.Reg.basicHeaderStruct(x,'single',0);
 
   hdr=SDCpckg.Reg.basicHeaderStruct(x,'single',0,'varName',...
    'velocity','varUnits','m/s','origin',[0 0 0],'delta',[1 1 1],'unit',...
    {'m','m','m'},'label',{'x','y','z'})
 
    hdr.precision='single';
   
    % FileAlloc
    SDCpckg.Reg.io.setFileDirty('newtest')
    SDCpckg.Reg.io.JavaSeis.serial.HeaderWrite(path,hdr) ;
    SDCpckg.Reg.io.setFileClean('newtest')
    
    SDCpckg.Reg.io.JavaSeis.serial.FileWrite(path,imat,hdr);
    n      = SDCpckg.Reg.io.JavaSeis.serial.FileNorm(path,0,'single') 
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),0) 
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.JavaSeis.serial.FileNorm(path,1,'single')
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),1)
    assertElementsAlmostEqual(x,n)
    
    n     = SDCpckg.Reg.io.JavaSeis.serial.FileNorm(path,2,'single')
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),2)
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.JavaSeis.serial.FileNorm(path,inf,'single')
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),inf)
    assertElementsAlmostEqual(x,n)
    n    = SDCpckg.Reg.io.JavaSeis.serial.FileNorm(path,-inf,'single')
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),-inf)
    assertElementsAlmostEqual(x,n)
    n      = SDCpckg.Reg.io.JavaSeis.serial.FileNorm(path,'fro','single')
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),'fro')
    assertElementsAlmostEqual(x,n)
end

function test_serial_file_NormTest2_double_real
%%
    SeisDataContainer_init ;
    path = 'newtest' ;
    SDCpckg.Reg.io.isFileClean(path);
    SeisDataContainer_init ;
    x    = [14,12,5] ;
    imat  = rand(x) ;
    td    = ConDir() ;
  %  hdr  = SDCpckg.Reg.basicHeaderStruct(x,'double',0);
  
    hdr=SDCpckg.Reg.basicHeaderStruct(x,'single',0,'varName',...
    'velocity','varUnits','m/s','origin',[0 0 0],'delta',[1 1 1],'unit',...
    {'m','m','m'},'label',{'x','y','z'})
  
    hdr.precision='double';
    
    % FileAlloc
    SDCpckg.Reg.io.setFileDirty('newtest')
    SDCpckg.Reg.io.JavaSeis.serial.HeaderWrite(path,hdr) ;
    SDCpckg.Reg.io.setFileClean('newtest')
    
    SDCpckg.Reg.io.JavaSeis.serial.FileWrite(path,imat,hdr);
    K=5;
    J=12;
    [n,m,o] = SDCpckg.Reg.io.JavaSeis.obselete.FileNorm_test2(path,K,J,0) 
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),0) 
    assertElementsAlmostEqual(x,m)
    assertElementsAlmostEqual(x,o)
    
    [n,m,o]      = SDCpckg.Reg.io.JavaSeis.obselete.FileNorm_test2(path,K,J,1)
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),1)
    assertElementsAlmostEqual(x,m)
    assertElementsAlmostEqual(x,o)
    [n,m,o]     = SDCpckg.Reg.io.JavaSeis.obselete.FileNorm_test2(path,K,J,2)
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),2)
    assertElementsAlmostEqual(x,m)
    assertElementsAlmostEqual(x,o)
    [n,m,o]     = SDCpckg.Reg.io.JavaSeis.obselete.FileNorm_test2(path,K,J,inf)
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),inf)
    assertElementsAlmostEqual(x,m)
    assertElementsAlmostEqual(x,o)
    [n,m,o]    = SDCpckg.Reg.io.JavaSeis.obselete.FileNorm_test2(path,K,J,-inf)
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),-inf)
    assertElementsAlmostEqual(x,m)
    assertElementsAlmostEqual(x,o)
    [n,m,o]      = SDCpckg.Reg.io.JavaSeis.obselete.FileNorm_test2(path,K,J,'fro')
    x      = norm(SDCpckg.Reg.utils.vecNativeSerial(imat),'fro')
    assertElementsAlmostEqual(x,m)
    assertElementsAlmostEqual(x,o)
end

function test_serial_NormBis
%%
    %  tests.IO_JavaSeis_tests.TestNorm_bis.m

end

