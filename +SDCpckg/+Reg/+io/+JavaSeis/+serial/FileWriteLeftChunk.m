function FileWriteLeftChunk(dirname,X,range,slice)
%FILEWRITELEFTCHUNK Writes serial left chunk data to binary file
%
% Edited for JavaSeis by Trisha, Barbara
%
%   FileWriteLeftChunk(DIRNAME,DATA,RANGE,SLICE) writes
%   the real serial left chunk into DIRNAME/FILENAME.
%
%   DIRNAME - A string specifying the directory name
%   DATA    - Non-distributed float data
%   RANGE   - A vector with two elements representing the range of
%             data that we want to write            
%   SLICE   - A vector specifying the slice
%
%   Warning: If the specified dirname exists, it will be removed.
narginchk(4, 4);
assert(ischar(dirname), 'directory name must be a string')
%assert(~isdistributed(x), 'data must not be distributed')
% No distribution yet. This function is not defined.
assert(isvector(range)&length(range)==2, 'range index must be a vector with 2 elements')
assert(isvector(slice)|isequal(slice,[]), 'slice index must be a vector')

% Global variable
global globalTable

%assert(~isempty(globalTable),'you first need to initialize the variable somewhere (e.g. SeisDataContainer_init)')

countPosition = range(1)-1

% Set up the Seisio object
import beta.javaseis.io.Seisio.*;    
seisio = beta.javaseis.io.Seisio( dirname );
seisio.open('rw');

% Read header
%header = SDCpckg.Reg.io.JavaSeis.serial.HeaderRead(dirname);

% Get number of dimensions and set position accordingly
header.dims = seisio.getGridDefinition.getNumDimensions() ;

% Define number of Hypercubes, Volumes, Frames & Traces
header.size = seisio.getGridDefinition.getAxisLengths() ;

% Get number of dimensions and set position accordingly
dimensions = header.dims ;
position = zeros(dimensions,1);

% Get Shape
shape = header.size ;

testx = X ;

size_X = size(testx) ;

testzeros = zeros(size(X)) ;

% RangeCount
rangeCount=range(2)-range(1)+1;

if isequal(slice,[]) == 0 
    
   sizeslice = size(slice) ;
 
   if(length(sizeslice) == 2)
    
   jstart = slice(2) ;
   jend = jstart ;
   istart = slice(1) ;
   iend = istart ;
   
   else
      
   jstart = 1 ;
   jend = jstart ;
   istart = slice(1);
   iend = istart ;
       
   end

else 
     
   jstart = 1 ;
   jend = 1 ;
   istart = 1 ;
   iend = size_X(3) ;
   
end


% Loop implementation
% Loop over 1 hypercube
for hyp=1:1
 
 %loop over volumes 
 for vol=jstart:jend  
     position(4) = vol-1 ;
     %myvol = vol ;
     %loop over frames
      for frm=istart:iend 
          position(3) = frm-1 ;
            
             % if frame exist 
             if seisio.frameExists(position)
             
                if isequal(slice,[]) == 0
                  a = testx(:,:,1,1) 
                else
                  a = testx(:,:,frm,vol) 
                end
           
             else
       
                a = testx(:,:,frm,vol) ;
       
             end
             
          
             if isequal(slice,[]) == 0
           
                globalTable(vol,frm,range(1):range(2),:) = a' ;
                size_Glob = size(globalTable) ;
                shape_init = shape';

                if (size_Glob(3) == shape_init(2))
                 
                    globalFrame = globalTable(vol,frm,:,:) ;
                    size_Fram = size(globalFrame) 
               
                    seisio.setTraceDataArray(globalFrame); 
                    seisio.setPosition(position);
                    seisio.writeFrame(size(globalFrame,3));
                   
                end

             else 
                 
                globalTable(vol,countPosition+1,:,:) = a' ;
                size_Glob = size(globalTable) ;
                shape_init = shape';


                if (size_Glob(3) == shape_init(2))
                
                    globalFrame = globalTable(vol,countPosition+1,:,:) ;
                  
                    seisio.setTraceDataArray(globalFrame); 
                    position(3) = countPosition ;
                
                    countPosition = countPosition +1 ;
                   
                    seisio.setPosition(position);
                    seisio.writeFrame(size(globalFrame,3));
                   
                end
          
             end
          
     end
     
      
 end
 

end


seisio.close() ;




end
