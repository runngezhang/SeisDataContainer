function [seismic_header, traces, trace_headers] = read_block(block_header, samples_range, header_bytes)
    %% ------------------ FUNCTION DEFINITION ---------------------------------
    % Function to read traces from a specific block with a
    % scanned segy volume
    %   Arguments:
    %   block_header: [mat_lite_file, header_byte_locs..., start_byte, n_traces]
    %
    %   Outputs:
    %       seismic_header = structure containing seismic header information
    %       traces = seismic traces as matrix (rows samples; columns traces)
    %       trace_headers = compressed metadata information for each trace
    %
    %   Writes to Disk:
    %       nothing

    %%
    
    
    seismic_header = read_header_file(block_header{1});
    start_byte = block_header{end-1};
    n_traces = block_header{end};
    
    [traces, trace_headers] = read_traces(seismic_header, start_byte, ...
                                          n_traces, samples_range, header_bytes);
    
    
    
end

function [traces,trace_headers] = read_traces(seismic, start_byte,...
                                n_traces_to_read, samples_range, header_bytes)
    %% Reads a block of traces 

    % Scroll back to the header
    start_byte = start_byte - 240;
    
    fid = fopen(char(seismic.filepath),'r','b');
    fseek(fid,start_byte,'bof');

    if isempty(header_bytes)
    	header_bytes = seismic.byte_locations;
    end
    
    if seismic.file_type == 1 || seismic.file_type == 5
 
        if ~isempty(samples_range);
        	
        	% Find the remaining bytes to skip after the range
        	toskip = (seismic.n_samples - samples_range(2))*4;
        	
    		%Read samples according to sample range
        	FullTraces_8 = fread(fid,[240+samples_range(2)*4,n_traces_to_read],...
                        [num2str(240 + samples_range(2)*4),'*uint8=>uint8'],toskip);
        else
        
        	%Read entire block
        	FullTraces_8 = fread(fid,[240+seismic.n_samples*4,n_traces_to_read],...
                           '*uint8');
        end
                         
        %Pull out trace headers and clear headers from FullTraces without 
        %duplicating the array        
        Headers_8 = FullTraces_8(1:240,:);
        FullTraces_8(1:240,:) = [];
        
        %Interpret the header values
        trace_headers = interpret_headers(Headers_8, header_bytes);
        
        switch seismic.file_type
        
        	case 1        		
        		%Interpret the data as uint32 then convert to double using
        		% ibm2num then convert to single (to save memory)
        		traces = reshape(swapbytes(typecast(FullTraces_8(:),'uint32')),...
        			[],n_traces_to_read);
        		traces = single(ibm2num(traces));
        	
        	case 5
        		%Interpret the data as single (IEEE 32 bit Floating Point)
        		traces = reshape(swapbytes(typecast(FullTraces_8(:),'single')),...
        			[],n_traces_to_read);
        end
                   
    else
        disp('This seismic file type is not currently supported.');
    end

    fclose(fid);  
end


