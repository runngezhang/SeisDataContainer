classdef segyCon < iroCon
    %
    %   Seismic data container for handling large out of core SEGY
    %   files. Current implementation only reads data and does not
    %   overwrite the underlying SEG-Y data.
    %
    %   x = segyCon(metadata_path) returns a segy seismic data
    %   container that accesses the data referenced by a given metadata
    %   file.
    %
    
    
    
    methods
        
        function obj = segyCon(metadata_path)
            
            header = irSDCpckg.stackheaderFromMetadata(metadata_path);
            dims = [size(header.scale,2) size(header.metadata,2)];
            
            obj = obj@iroCon(header, dims);
            obj.pathname = metadata_path;
            
        end
        
        function container = query(obj, volume, key, value)
            
            if key == 'block'
                
                block = value;
                [trace_headers, data, ilxl, offset_read] =   ...
                   node_segy_read(obj.pathname, ...
                    num2str(volume),num2str(block));
                
                
                % make an in-core container
                header = irSDCpckg.headerFromBlockRead(trace_headers, ilxl);
                
                container = iriCon(header, size(data));
                container.data = data;
                
            end
        end % function
    end % methods
    
end
