function [seismic_header, trace_headers] = read_headers(block_header, header_bytes)
    %% ------------------ FUNCTION DEFINITION ---------------------------------
    % Function to read trace headers from a specific block with a
    % scanned segy volume. A modified version of read_block
    %   Arguments:
    %   block_header: [mat_lite_file, header_byte_locs..., start_byte, n_traces]
    %
    %   Outputs:
    %       seismic_header = structure containing seismic header information
    %       
    %       trace_headers = compressed metadata information for each trace
    %
    %   Writes to Disk:
    %       nothing

    %%
    
    
    seismic_header = read_header_file(block_header{1});
    start_byte = block_header{end-1};
    n_traces = block_header{end};
    [trace_headers] = read_trace_headers(seismic_header, start_byte, ...
                                          n_traces, header_bytes);
    
    
    
end

function [trace_headers] = read_trace_headers(seismic, start_byte,...
                                              n_traces_to_read, header_bytes)
    %% Reads a block of traces 
    
    % Check to see if header bytes chosen
    if isempty(header_bytes);
    	header_bytes=seismic.byte_locations;
    else
    end
    
    % Maps byte locations to samples
    byte_type = [ ...
        2*ones(7,1); ones(4,1);
        2*ones(8,1); ones(2,1);
        2*ones(4,1); ones(46,1);
        2*ones(5,1); ones(2,1);
        2*ones(1,1); ones(5,1);
        2*ones(1,1); ones(1,1);
        2*ones(1,1); ones(2,1);
        2*ones(1,1); 2*ones(1,1)];
        
    count =1;
    for ii = 1:91
        bytes_to_samples(ii,1) = 2*count-1;
        if byte_type(ii) == 1
            count = count+1;
        elseif byte_type(ii) == 2
            count = count+2;
        end
    end
    
    % Scroll back to the header
    start_byte = start_byte - 240;
    
    fid = fopen(char(seismic.filepath),'r','b');
    fseek(fid,start_byte,'bof');

    if seismic.file_type == 1
        % Convert traces from IBM32FP read as UINT32 into IEEE64FP
        % (doubles) - need to make it singles

	%Set up empty arrays
	trace_headers = zeros(n_traces_to_read, length(header_bytes),'int32');
	trchead_tmp=zeros(91,1);
	
	for trace = 1:n_traces_to_read;
        
        		
        		% Set up/clear a temp vector and read the first 4 bytes of ... 
        		% the header (Trace Number in File)

        		%Read 7 @ 4 bytes
        		trchead_tmp(1:7) = fread(fid, 7,'*int32');

        		%Read 4 @ 2 bytes
        		trchead_tmp(8:11) = fread(fid, 4,'int16=>int32');
        		
        		%Read 8 @ 4 bytes
        		trchead_tmp(12:19) = fread(fid, 8,'int32');
        		
        		%Read 2 @ 2 bytes
        		trchead_tmp(20:21) = fread(fid, 2,'int16=>int32');
        		
        		%Read 4 @ 4 bytes
        		trchead_tmp(22:25) = fread(fid, 4,'int32');
        		
        		%Read 13 @ 2 bytes
        		trchead_tmp(26:38) = fread(fid, 13,'int16=>int32');
        		
        		%Read 2 @ 2 bytes 
        		trchead_tmp(39:40) = fread(fid, 2,'int16=>int32');
        		
        		%Read 31 @ 2 bytes
        		trchead_tmp(41:71) = fread(fid, 31,'int16=>int32');
        		
        		%Read 5 @ 4 bytes
        		trchead_tmp(72:76) = fread(fid, 5,'int32');
        		
        		%Read 2 @ 2 bytes
        		trchead_tmp(77:78) = fread(fid, 2,'int16=>int32');
        		
        		%Read 1 @ 4 bytes
        		trchead_tmp(79) = fread(fid, 1,'int32');
        		
        		%Read 5 @ 2 bytes
        		trchead_tmp(80:84) = fread(fid, 5,'int16=>int32');
        		
        		%Read 1 @ 4 bytes
        		trchead_tmp(85) = fread(fid, 1,'int32');
        		
        		%Read 1 @ 2 bytes
        		trchead_tmp(86) = fread(fid, 1,'int16=>int32');
        		
        		%Read 1 @ 4 bytes
        		trchead_tmp(87) = fread(fid, 1,'int32');
        		
        		%Read 2 @ 2 bytes
        		trchead_tmp(88:89) = fread(fid, 2,'int16=>int32');
        		
        		%Read 2 @ 4 bytes
        		trchead_tmp(90:91) = fread(fid, 2,'int32');
        		
        		% Seek pointer to next header
        		fseek(fid, seismic.n_samples*4, 'cof');
        		
        		% Store temporary header samples
               	 	for i=1:length(header_bytes);
               	 		
               	 		trace_headers(trace,i)=trchead_tmp(bytes_to_samples ...
               	 					== header_bytes(i));
               	 	end %For loop over header_bytes

                    
        end % For Loop (traces_to_read)

%        trace_headers=trace_headers_in'; %Pass out condensed header info
        
             
    elseif seismic.file_type == 2 
        disp('This seismic file type is not currently supported.');
    elseif seismic.file_type == 5
       
        % Traces are IEEE32FP (singles)
        
	% Allocate memory to empty arrays
	trace_headers_in = zeros(5, n_traces_to_read,'int32');
	trchead_tmp=zeros(5,1);
	
	for trace = 1:n_traces_to_read;
        
        		
        		% Set up/clear a temp vector and read the first 4 bytes of ... 
        		% the header (Trace Number in File)
        		trchead_tmp(:) = 0;
        		trchead_tmp(1) = fread(fid, 1,'*int32');
        		
        		%Seek to srcX, 72nd byte in header. COF = 4th byte
        		fseek(fid,68, 'cof');
        		
        		% Read 4 samples (16 bytes) to get srcX, srcY, grpX, grpY
        		trchead_tmp(2:5)= fread(fid,4,'*int32');      

                	% Seek past remaining samples to next start of next trace
                	fseek(fid,(seismic.n_samples)*4+152, 'cof');               	
                
               	 	% Store temporary traces and header
               	 	trace_headers_in(:,trace)= trchead_tmp;
                    
        end % For Loop (traces_to_read)

        trace_headers=trace_headers_in'; %Pass out condensed header info
        
                
    else
        disp('This seismic file type is not currently supported.');
    end

    fclose(fid);  
end

