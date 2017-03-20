classdef segyCon < iroCon
    %
    %   Seismic data container for handling large out of core SEGY
    %   files. Current implementation only reads data and does not
    %   overwrite the underlying SEG-Y data.
    %
    %	Use: 
    %   	container = segyCon(metadata_path, type) 
    %
    %	Which returns a segy seismic data container that accesses the data referenced 
    %   by a given metadata file.
    %--------------------------------------------------------------------------------------
    %	Inputs: 
    %
    %           *MANDATORY* Metadata_path:  A string path to the metadata file. 
    %			         Ex: 'BPshotsMeta.mat'
    %		
    %		*MANDATORY* Type: Type of ensemble. Changes what kind of labels
    %                             are used for the volume. The two presets 'shot' and 
    %				  'stack' create labels and units appropriate for those
    %                             respective gathers. 
    %                             Using type = 'custom' will label columns based on the 
    % 			          HeaderBytes chosen when scanning the files if the user is
    %                             viewing block headers, or the HeaderBytes chosen when 
    %                             calling segyCon if the user is loading information incore.
    %				  
    %	
    %		SampleRange: Optional range of samples you want to be read from each trace.
    %			       
    %		   Ex: Con=segyCon('meta','shot','SampleRange',[50 500])
    %
    %		HeaderBytes: An optional vector containing the starting byte of 
    %			      trace attributes in the STHs that will store as metadata.
    %			      If no header bytes are inputted by the user, the header bytes 
    %			      chosen when scanning the file will be used.
    %
    %		   Ex: Con=segyCon('meta,'shot','HeaderBytes',[1 81 85]; 
    %			     This will store the Trace Number, Group X and Group Y
    %			     positions.
    %
    %	Output: 
    %	   Container: A seismic data container that will access data/header values
    %                 corresponding to the given metadata file.
    %-------------------------------------------------------------------------------------
    %	Container Methods
    %		
    %		Con.blocks(blocks)
    %			Will load the header values chosen when creating
    %	                the container, as well as the data, for every trace in the blocks
    %		        called.
    %
    %		Con.headers(blocks)
    %			Will load only the header values chosen when creating
    %	                the container for every trace in the blocks called. A good way to
    % 			make acquisition masks for large data sets. 
    %
    %-------------------------------------------------------------------------------------



    
    
    methods
        
        function obj = segyCon(metadata_path, type, varargin) 
            
         %% Parse inputs for validity
            
            %Set min/max inputes
            narginchk(2,6)
            
            %Parse and set requirements
            p = inputParser;
            p.FunctionName='segyCon';
            
            addRequired(p,'metadata_path',@ischar)
            parse(p,metadata_path)
            
            %valfcn=@(x) ischar(x) && 
           % addRequired(p,'type',)
           % parse(p,type)
            
            switch type
               
                case 'shot'
                    header = irSDCpckg.shotHeaderFromMetadata(metadata_path);
                
                case 'stack'
                    header = irSDCpckg.stackHeaderFromMetadata(metadata_path);
                    
                case 'custom'
                    header = irSDCpckg.customHeaderFromMetadata(metadata_path);
            end
            
            dims = [size(header.scale,2) size(header.metadata,1)];
            
            obj = obj@iroCon(header, dims);
            obj.pathname = metadata_path;
            obj.type = type;

		% Check and account for optional input arguments
		sr_written=0; hb_written=0;
		
		if isempty(varargin)
			obj.samples_range = [];
			obj.header_bytes = [];
		elseif mod(length(varargin),2) == 1
			error(['Odd number of optional input parameters. Make'...
			     ' sure to use keywords'])
		else
			for i = 1:2:length(varargin)
				if ischar(varargin{i});
					if strcmpi(varargin{i},'SampleRange');
						obj.samples_range = varargin{i+1};
						sr_written=1;
					elseif strcmpi(varargin{i},'HeaderBytes');
						obj.header_bytes = varargin{i+1};
						hb_written=1;
					end
				else 
					error(['Invalid input format. Use Keywords'...
					      'followed by their values'])
				end

	
				if sr_written == 0;
					obj.samples_range = [];
				elseif hb_written == 0;
					obj.header_bytes = [];
				end		
			end
		end
		
		% Convert Header_Bytes keywords to byte numbers
		if iscellstr(obj.header_bytes);
			%Load lookup
			load('bytes_to_samples.mat');
			Header_Byte_Locations=zeros(1,length(obj.header_bytes));
			
			for i=1:length(obj.header_bytes)
				keyword=obj.header_bytes{i};
				ii=strmatch(keyword,...
				            char(bytes_to_samples_cell(:,2)),'exact');
				            
				Header_Byte_Locations(i)=cell2mat(...
				                         bytes_to_samples_cell(ii,1));	
			end
			
			obj.header_bytes=Header_Byte_Locations;
			
		end
	
          
        end
        
        function container = blocks(obj, blocks)
            

            first = 1;
            for block=blocks
                
                [segy_header, traces, trace_headers] =   ...
                   read_block(obj.header.metadata(block, :), obj.samples_range, obj.header_bytes);
               
               if first
               
               % Allocate memory for all trace headers and traces
               [trace_current n_bytes] = size(trace_headers);
               nsamples = size(traces,1);
               
               all_trace_headers = zeros(...
               			length(blocks)*trace_current,5); %headers
               			
               all_traces = zeros(nsamples, length(blocks)*trace_current);%traces
               
               
               %Store first block's trace headers
               all_trace_headers(1:trace_current,1:n_bytes)=trace_headers;	
               all_traces(:,1:trace_current) = traces;
               
               %Keep this index
               trace_last = trace_current;				 		            	
               first = 0;
               
%                all_traces = traces;
%                all_trace_headers = trace_headers;
%               first = 0;
               else
               
               
               % Number of traces in this block
               [trace_current n_bytes] = size(trace_headers);
               
               % Store current traces
               all_trace_headers((trace_last+1):(trace_last+trace_current),1:n_bytes) = trace_headers;
               
               all_traces(:,(trace_last+1):(trace_last+trace_current)) = traces;
               
               % Update index in header array
               trace_last = trace_last + trace_current;
               
               
%                   all_traces = [all_traces, traces];
%                   all_trace_headers = [all_trace_headers; trace_headers];
               end
               
            end
            
            header = irSDCpckg.headerFromBlockRead(segy_header,...
                                                   all_trace_headers,...
                                                   obj.type,...
                                                   obj.header_bytes);
            
            container = iriCon(header, size(all_traces));
            container.data = all_traces;
            
        end
                
        function container = headers(obj, blocks) 
         %% only for type 1 data           

            first = 1;
            for block=blocks
                
                [segy_header, trace_headers] =   ...
                   read_headers(obj.header.metadata(block, :), obj.header_bytes);
               
               
               if first
               
               % Allocate memory for all trace headers
               [trace_current n_bytes] = size(trace_headers);
               all_trace_headers = zeros(...
               			length(blocks)*trace_current,5); 
               
               %Store first block's trace headers
               all_trace_headers(1:trace_current,1:n_bytes)=trace_headers;	
               
               %Keep this index
               trace_last = trace_current;				 		            	
               first = 0;
               else
               
               
               % Number of traces in this block
               [trace_current n_bytes] = size(trace_headers);
               
               % Store current traces
               all_trace_headers((trace_last+1):(trace_last+trace_current),1:n_bytes) = trace_headers;
               
               % Update index in header array
               trace_last = trace_last + trace_current;    
               end
               
            end	
            
            header = irSDCpckg.headerFromBlockRead(segy_header,...
                                                   all_trace_headers,...
                                                   obj.type,...
                                                   obj.header_bytes);
            
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
                                                       trace_headers,...
                                                       obj.type,...
                                                       obj.header_bytes);
                
                container = iriCon(header, size(traces));
                container.data = traces;
                
            end
        end % function
            
    end % methods
    
end
