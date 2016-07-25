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
        
        function obj = segyCon(metadata_path, type, samples_range) 
            
            switch type
               
                case 'shot'
                    header = irSDCpckg.shotHeaderFromMetadata(metadata_path);
                
                case 'stack'
                    header = irSDCpckg.stackHeaderFromMetadata(metadata_path);
                    
                otherwise
                    header = {};
            end
            dims = [size(header.scale,2) size(header.metadata,1)];
            
            obj = obj@iroCon(header, dims);
            obj.pathname = metadata_path;
            obj.type = type;
            if isempty(samples_range);
            	obj.samples_range=[];
            else
            	obj.samples_range=samples_range;
            end
            
        end
        
        function container = blocks(obj, blocks)
            

            first = 1;
            for block=blocks
                
                [segy_header, traces, trace_headers] =   ...
                   read_block(obj.header.metadata(block, :), obj.samples_range);
               
               if first
                all_traces = traces;
                all_trace_headers = trace_headers;
                first = 0;
               else
                   all_traces = [all_traces, traces];
                   all_trace_headers = [all_trace_headers; trace_headers];
               end
               
            end
            
            header = irSDCpckg.headerFromBlockRead(segy_header,...
                                                   all_trace_headers,...
                                                   obj.type);
            
            container = iriCon(header, size(all_traces));
            container.data = all_traces;
            
        end
                
        function container = headers(obj, blocks) 
         %% only for type 1 data           

            first = 1;
            for block=blocks
                
                [segy_header, trace_headers] =   ...
                   read_headers(obj.header.metadata(block, :));
               
               if first
                all_trace_headers = trace_headers;
                first = 0;
               else
                   all_trace_headers = [all_trace_headers; trace_headers];
               end
               
            end
            
            header = irSDCpckg.headerFromBlockRead(segy_header,...
                                                   all_trace_headers,...
                                                   obj.type);
            
            container = iriCon(header, size(all_trace_headers));
            container.data =[];	
        
        end %Function   
            
        function container = query(obj, volume, key, value)
            
            if key == 'block'
                
                block = value;
                [segy_header, traces, trace_headers] =   ...
                   read_block(obj.header.metadata(block, :));
                
                
                % make an in-core container
                header = irSDCpckg.headerFromBlockRead(segy_header,...
                                                       trace_headers);
                
                container = iriCon(header, size(traces));
                container.data = traces;
                
            end
        end % function
            
    end % methods
    
end
