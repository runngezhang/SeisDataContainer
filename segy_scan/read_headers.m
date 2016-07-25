function [seismic_header, trace_headers] = read_headers(block_header)
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
                                          n_traces);
    
    
    
end

function [trace_headers] = read_trace_headers(seismic, start_byte,...
                                              n_traces_to_read)
    %% Reads a block of traces 

    % Scroll back to the header
    start_byte = start_byte - 240;
    
    fid = fopen(char(seismic.filepath),'r','b');
    fseek(fid,start_byte,'bof');

    if seismic.file_type == 1
        % Convert traces from IBM32FP read as UINT32 into IEEE64FP
        % (doubles) - need to make it singles

	%Set up empty arrays
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
        
             
    elseif seismic.file_type == 2 
        disp('This seismic file type is not currently supported.');
    elseif seismic.file_type == 5
       
        % Traces are IEEE32FP (singles)
        
	% Allocate memory to empty arrays
	trace_headers_in = zeros(5, n_traces_to_read,'float32');
	trchead_tmp=zeros(5,1);
	
	for trace = 1:n_traces_to_read;
        
        		
        		% Set up/clear a temp vector and read the first 4 bytes of ... 
        		% the header (Trace Number in File)
        		trchead_tmp(:) = 0;
        		trchead_tmp(1) = fread(fid, 1,'*float32');
        		
        		%Seek to srcX, 72nd byte in header. COF = 4th byte
        		fseek(fid,68, 'cof');
        		
        		% Read 4 samples (16 bytes) to get srcX, srcY, grpX, grpY
        		trchead_tmp(2:5)= fread(fid,4,'*float32');      

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


function [trace_header bytes_to_samples] = interpretbe(tmptrheader)
%% Big-Endian segy trace header reader %%%
    
    byte_type = [ ...
        2*ones(7,1); ones(4,1);
        2*ones(8,1); ones(2,1);
        2*ones(4,1); ones(46,1);
        2*ones(5,1); ones(2,1);
        2*ones(1,1); ones(5,1);
        2*ones(1,1); ones(1,1);
        2*ones(1,1); ones(2,1);
        2*ones(1,1); 2*ones(1,1)];
        
    ntr = size(tmptrheader,2);
    trace_header = zeros(91,ntr);
    bytes_to_samples = zeros(91,1);

    count =1;
    for ii = 1:91
        bytes_to_samples(ii,1) = 2*count-1;
        if byte_type(ii) == 1
            trace_header(ii,:) = double(tmptrheader(count,:));
            count = count+1;
        elseif byte_type(ii) == 2
            trace_header(ii,:) = double(tmptrheader(count+1,:))*2^16 + double(tmptrheader(count,:)); % note this is big-endian and different to one in segy_make_structure
            count = count+2;
        end
    end

    trace_header(21,:) = trace_header(21,:)-2^16;

end

