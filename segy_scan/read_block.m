function [seismic_header, traces, trace_headers] = read_block(block_header, samples_range)
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
                                          n_traces, samples_range);
    
    
    
end

function [traces,trace_headers] = read_traces(seismic, start_byte,...
                                              n_traces_to_read, samples_range)
    %% Reads a block of traces 

    % Scroll back to the header
    start_byte = start_byte - 240;
    
    fid = fopen(char(seismic.filepath),'r','b');
    fseek(fid,start_byte,'bof');

    if seismic.file_type == 1
        % Convert traces from IBM32FP read as UINT32 into IEEE64FP
        % (doubles) - need to make it singles
        
        if ~isempty(samples_range);
    		display(['Sample Range not supported for this Data Format.'...
    		         ' All samples will be read']);
        end
        
        traces_tmp = fread(fid,[60+seismic.n_samples,n_traces_to_read],...
                           '*int32');
        
        trchead = traces_tmp(1:60,:);
        [trace_header bytes_to_samples] = ...
            interpretbe(reshape(typecast(trchead(:),'int16'),120,[]));
        
        % get the headers
        for field=1:seismic.n_fields
            trace_headers(:, field) = ...
                int32(trace_header(bytes_to_samples == ...
                                   seismic.byte_locations(field),:))';
        end
        

        
        traces = single((1-2*double(bitget(traces_tmp(61:end,:),32))).*16.^ ...
        (double(bitshift(bitand(traces_tmp(61:end,:),...
                                int32(hex2dec('7f000000'))),-24))-64).* ...
        (double(bitand(traces_tmp(61:end,:), ...
                       int32(hex2dec('00ffffff'))))/2^24));
        
    elseif seismic.file_type == 2 
        disp('This seismic file type is not currently supported.');
    elseif seismic.file_type == 5
 
 	    
        if isempty(samples_range);
    		%samples_range=[1 seismic.n_samples];
    		rangetype=1; %Read all samples at once
    	elseif length(samples_range)~= 2;
    		disp('Invalid Sample Range. Use an empty vector to read whole traces')
    	elseif samples_range(2)>seismic.n_samples;
    		disp('Invalid Sample Range. Range exceeds trace length')
    	elseif samples_range(1)>samples_range(2);
    		error(['Invalid Sample Range. Use [Range_Minimum Range_Maximum]', ...
    		       ' where Range_Maximum > Range_Minimum']) 
    	else
    		rangetype=2; %Read an interval of samples
    	end

       
        % Traces are IEEE32FP (singles)
        
%-----klensink---------------------------------------------------------------------
        % Allocate space in memory before loop
        if rangetype==2;
        	n_samples_to_read=samples_range(2)-samples_range(1)+1;
        
        	traces = zeros(60+n_samples_to_read, n_traces_to_read);
        	%Loop over all traces in block
        	for trace = 1:n_traces_to_read;
        
        		% Read just headers (first 240 bytes / 60 samples)
        		trchead_tmp = fread(fid, 60,...
        			strcat(num2str(n_samples_to_read),'*float32=>float32'));
        		
        		% Seek to first sample w/ 4 bytes per sample
        		fseek(fid, (samples_range(1)-1)*4, 'cof'); 
        	
        		% Read until last sample
        		trc_tmp = fread(fid, samples_range(2)-samples_range(1)+1,...
        			strcat(num2str(n_samples_to_read),'*float32=>float32'));
        		       
                	% Seek past remaining samples to next trace
                	remainder=seismic.n_samples-samples_range(2);
                	fseek(fid,(remainder)*4, 'cof');
                
               	 	% Dump temporary traces and header
               	 	traces(1:60,trace)=trchead_tmp;
               	 	traces(61:end,trace)=trc_tmp;
                    
        	end % For Loop (traces_to_read)

        elseif rangetype==1;
        	traces = fread(fid,[60+seismic.n_samples,n_traces_to_read],...
                         strcat(num2str(seismic.n_samples),'*float32=>float32'));
        end
%-------------------------------------------------------------------------------
        trchead = typecast(single(reshape(traces(1:60,:),...
                                          1,60*n_traces_to_read)),'uint16');  
        
        [trace_header bytes_to_samples] = interpretbe(reshape(trchead,120,[]));
        
        % get the headers
        for field=1:seismic.n_fields
            trace_headers(:, field) = ...
                int32(trace_header(bytes_to_samples == ...
                                   seismic.byte_locations(field),:))';
        end
      
        traces = traces(61:end,:);            
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

