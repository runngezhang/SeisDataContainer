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
   
       
       function container = data(obj, volume, block)
           
            d = obj;    
           if block < obj.header.n_blocks
         [trace_headers, data, ilxl, offset_read] =   ...   
               node_segy_read(obj.metafile, num2str(volume),num2str(block));
         
         dims = size(data);
              
         % make an in-core container
         header = SDCpckg.basicHeaderStruct([size(data,1), size(data,2)],...
             'double', 0);
         
         
         
         container = iCon(header);
         container.data = data;
           end
       end % function
   end % methods
   
end    
