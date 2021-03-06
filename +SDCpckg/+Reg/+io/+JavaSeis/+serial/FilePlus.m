function FilePlus(A,B,dirnameOut)
%FILEPLUS Allocates file space and adds up the two input files
%   FilePlus(A,B,DIRNAMEOUT)
%
%   A,B        - Either string specifying the directory name of the input
%                files or a scalar
%   DIRNAMEOUT - A string specifying the output directory name
%    

SDCpckg.Reg.io.isFileClean(dirnameOut);
global SDCbufferSize;
    
if(isnumeric(B))
    temp = B;
    B    = A;
    A    = temp;
end
    
if isscalar(A)
    A = A*ones(size(B));
end
    
if(isnumeric(A))
    if(~isdir(B))
        error('Fail: Wrong input type')
    end
    SDCpckg.Reg.io.isFileClean(B);
    % Reading input headers
    headerB   = SDCpckg.Reg.io.JavaSeis.serial.HeaderRead(B);
    headerOut = headerB;

    % Set byte size
    % Matlab Header Struct must contain the precision attribute
    %  bytesize = SDCpckg.Reg.utils.getByteSize(headerOut.precision);
    % If Matlab Header Struct does not contain the Matlab attribute
     file_precision = 'double';
     bytesize  = SDCpckg.Reg.utils.getByteSize(file_precision);

    SDCpckg.Reg.io.JavaSeis.serial.FileAlloc(dirnameOut,headerOut);
    xsize       = headerOut.size;
    headerOut.size = [1 prod(xsize)];
    SDCpckg.Reg.io.JavaSeis.serial.HeaderWrite(dirnameOut,headerOut);

    % Set the sizes
    dims      = [1 prod(xsize)];
    reminder  = prod(xsize);
    maxbuffer = SDCbufferSize/bytesize;
    rstart = 1;

    while (reminder > 0)
        buffer = min(reminder,maxbuffer);
        rend = rstart + buffer - 1;            
        %r2 = SDCpckg.Reg.io.NativeBin.serial.DataReadLeftChunk...
        %    (B,'real',dims,[rstart rend],[],headerB.precision,...
        %    headerB.precision);
        
        % This call works for test case x = [14,12,5] ;
        r2 = SDCpckg.Reg.io.JavaSeis.serial.DataReadLeftChunk(dirname,[1 5],[],[rstart rend],file_precision) ;
        
        % DataReadLeftChunk for the complex part has to be developed
        %if headerB.complex
        %dummy = SDCpckg.Reg.io.NativeBin.serial.DataReadLeftChunk...
        %    (B,'imag',dims,[rstart rend],[],headerB.precision,...
        %    headerB.precision);
        %    r2 = complex(r2,dummy);
        %end
        
        %SDCpckg.Reg.io.NativeBin.serial.FileWriteLeftChunk...
        %    (dirnameOut,plus(A(rstart:rend),r2),[rstart rend],[]);
        
        SDCpckg.Reg.io.JavaSeis.serial.FileWriteLeftChunk(dirnameOut,plus(A(rstart:rend),r2),[rstart rend],[]);
        
        reminder = reminder - buffer;
        rstart   = rend + 1;
    end
    headerOut.size = xsize
    SDCpckg.Reg.io.JavaSeis.serial.HeaderWrite(dirnameOut,headerOut);
    
elseif(isdir(A))
    if(~isdir(B))
        error('Fail: Wrong input type')
    end
    SDCpckg.Reg.io.isFileClean(A);
    SDCpckg.Reg.io.isFileClean(B);
    % Reading input headers
    headerA   = SDCpckg.Reg.io.JavaSeis.serial.HeaderRead(A);
    headerB   = SDCpckg.Reg.io.JavaSeis.serial.HeaderRead(B);
    if(headerA.size ~= headerB.size)
            error('Epic fail: The inputs does not have the same size')
    end
    headerOut = headerA;

    % Set byte size
    % Matlab Header Struct must contain the precision attribute
    %  bytesize = SDCpckg.Reg.utils.getByteSize(headerOut.precision);
    % If Matlab Header Struct does not contain the Matlab attribute
    file_precision = 'double'
    bytesize  = SDCpckg.Reg.utils.getByteSize(file_precision)

    x = [14,12,5]
    headerOut = SDCpckg.Reg.io.JavaSeis.serial.HeaderWrite(x,'double',0)
    SDCpckg.Reg.io.JavaSeis.serial.FileAlloc(dirnameOut,headerOut);
    xsize       = headerOut.size;
    headerOut.size = [1 prod(xsize)];
    %SDCpckg.Reg.io.JavaSeis.serial.HeaderWrite(dirnameOut,headerOut);

    % Set the sizes
    dims      = [1 prod(xsize)];
    reminder  = prod(xsize);
    SDCbufferSize = 840 ;
    maxbuffer = SDCbufferSize/bytesize;
    rstart = 1;

    while (reminder > 0)
        buffer = min(reminder,maxbuffer);
        rend = rstart + buffer - 1;
      
        % r1 = SDCpckg.Reg.io.NativeBin.serial.DataReadLeftChunk...
        %   (A,'real',dims,[rstart rend],[],headerA.precision,...
        %  headerA.precision);
        
        % This call works for test case x = [14,12,5] ;
        % dims = [1 5]
        r1 = SDCpckg.Reg.io.JavaSeis.serial.DataReadLeftChunk(A,[1 5],[],[rstart rend],file_precision) ;
        
        % DataReadLeftChunk for the complex part has to be developed 
        % if headerA.complex
        % dummy = SDCpckg.Reg.io.NativeBin.serial.DataReadLeftChunk...
        %    (A,'imag',dims,[rstart rend],[],headerA.precision,...
        %    headerA.precision);
        %    r1 = complex(r1,dummy);
        % end
        
        % 
        % r2 = SDCpckg.Reg.io.NativeBin.serial.DataReadLeftChunk...
        %    (B,'real',dims,[rstart rend],[],headerB.precision,...
        %    headerB.precision);
        
        % This call works for test case x = [14,12,5] ;
        % dims = [1 5]
        r2 = SDCpckg.Reg.io.JavaSeis.serial.DataReadLeftChunk(B,[1 5],[],[rstart rend],file_precision) ;
        
        % DataReadLeftChunk for the complex part has to be developed 
        %if headerB.complex
        %dummy = SDCpckg.Reg.io.NativeBin.serial.DataReadLeftChunk...
        %    (B,'imag',dims,[rstart rend],[],headerB.precision,...
        %    headerB.precision);
        %    r2 = complex(r2,dummy);
        %end
        
        SDCpckg.Reg.io.JavaSeis.serial.FileWriteLeftChunk...
            (dirnameOut,plus(r1,r2),[rstart rend],[]);
        reminder = reminder - buffer;
        rstart   = rend + 1;
    end
    headerOut.size = xsize;
    x = [14,12,5]
    headerOut = SDCpckg.Reg.io.JavaSeis.serial.HeaderWrite(x,'double',0)
    %SDCpckg.Reg.io.JavaSeis.serial.HeaderWrite(dirnameOut,headerOut);
else
    error('Fail: Wrong input type')
end
end


