classdef segyCon < handle
%
%   Seismic data container for handling large out of core SEGY
%   files. Current implementation only reads data and does not
%   overwrite the underlying SEG-Y data. 
%
%   x = segyCon(metadata_path) returns a segy seismic data
%   container that accesses the data referenced by a given metadata
%   file.
%

    
   properties(SetAccess=private)
       
       % Header for the underlying SEGY files
       header = {};

       % job metafile
       metafile = '';
   end
   
   methods
       
       function obj = segyCon(metadata_path)
           
           obj.header = load(metadata_path);
           obj.metafile = metadata_path;
           
       end
   
       
       function container = data(obj, vol, block)
           
            d = obj;    
           if vol < obj.header.nvols & block < obj.header.n_blocks
         [trace_headers, data, ilxl, offset_read] =   ...   
               node_segy_read(obj.metafile, num2str(vol),num2str(block));
           
    
         
         % Total hack to reform data, need to actually look at indices
         dims = max(ilxl) - min(ilxl) +1;
         
              
         % make an in-core container
         header = SDCpckg.basicHeaderStruct([trace_headers.n_samples, ...
                             dims[1], dims[2]], 'double', 0);
         
         
         
         container = iCon(header);
         container.data = reshape(data,trace_headers.n_samples, ...
                             dims[1], dims[2]) ;
         
       end % function
   end % methods
   
end    
