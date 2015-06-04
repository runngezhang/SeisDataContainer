classdef segyStackCon < iCon
%
%   Seismic data container for handling large out of core SEGY
%   files. Current implementation only reads data and does not
%   overwrite the underlying SEG-Y data. 
%
%   x = segyStackCon(metadata_path) returns a segy seismic data
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
       
       function obj = segyStackCon(data, dt, il, xl)
           
           
       end
   
       
       function container = data(obj, volume, block)
           
            d = obj;    
           if block < obj.header.n_blocks
         [trace_headers, data, ilxl, offset_read] =   ...   
               node_segy_read(obj.metafile, num2str(volume),num2str(block));
         
         dims = size(data);
              
         % make an in-core container
         header = SDCpckg.basicHeaderStruct([size(data,1), size(data,2)],...
             'double', 0, 'coords', ilxl);
         
         
         
         
         container = iCon(header);
         container.data = data;
           end
       end % function
   end % methods
   
end    
