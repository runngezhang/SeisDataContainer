function [seismic_header, traces, trace_headers] = ...
        read_block(block_header)
    %% ------------------ FUNCTION DEFINITION ---------------------------------
    % node_segy_read: function to read traces from a specific block with a
    % scanned segy volume
    %   Arguments:
    %       job_meta_path = path to job_meta .mat file
    %       i_block = integer indicating which block to load from volume
    %
    %   Outputs:
    %       seismic = structure containing seismic header information
    %       traces = seismic traces as matrix (rows samples; columns traces)
    %       trace_headers = simple metadata information for each trace
    %
    %   Writes to Disk:
    %       nothing

    %%


    seismic_header = read_header_file(block_header{1});
    start_byte = block_header{end-1};
    n_traces = block_header{end};
    
    [traces, trace_headers] = read_traces(seismic_header, start_byte, ...
                                          n_traces);
    
    
    
end

function [traces,trace_headers] = read_traces(seismic, ...
                                              start_byte,...
                                              n_traces_to_read)

    % Scroll back to the header
    start_byte = start_byte - 240;
    
    fid = fopen(char(seismic.filepath),'r','b');
    fseek(fid,start_byte,'bof');

    if seismic.file_type == 1
        % Convert traces from IBM32FP read as UINT32 into IEEE64FP (doubles) - need to make it singles
        %traces_tmp = fread(fid,[60+seismic.n_samples,n_traces_to_read],strcat(num2str(seismic.n_samples),'*uint32=>uint32'));
        traces_tmp = fread(fid,[60+seismic.n_samples,n_traces_to_read],'*uint32');
        
        
        %ilxl_read = traces_tmp(48:49,:)'; % what happens if the inline and crossline are not in this location  
        trchead = traces_tmp(1:60,:);
        [trace_header bytes_to_samples] = interpretbe(reshape(typecast(trchead(:),'uint16'),120,[]));
        
        % get the headers
        for field=1:seismic.n_fields
            trace_headers(:, field) = ...
                int32(trace_header(bytes_to_samples == ...
                                   seismic.byte_locations(field),:))';
        end
        

        
        traces = single((1-2*double(bitget(traces_tmp(61:end,:),32))).*16.^ ...
        (double(bitshift(bitand(traces_tmp(61:end,:),uint32(hex2dec('7f000000'))),-24))-64).* ...
        (double(bitand(traces_tmp(61:end,:),uint32(hex2dec('00ffffff'))))/2^24));
    elseif seismic.file_type == 2 
        disp('This seismic file type is not currently supported. Please speak to Charles Jones.');
    elseif seismic.file_type == 5
        % Traces are IEEE32FP (singles)   
        traces = fread(fid,[60+seismic.n_samples,n_traces_to_read],strcat(num2str(seismic.n_samples),'*float32=>float32'));
        %trace_headers = typecast(single(reshape(traces(1:60,:),1,60*n_traces_to_read)),'int32');  
        %trace_headers = reshape(trace_headers,60,n_traces_to_read);
        
        trchead = typecast(single(reshape(traces(1:60,:),1,60*n_traces_to_read)),'uint16');  
        %trchead = reshape(trchead,120,n_traces_to_read);
        
        [trace_header bytes_to_samples] = interpretbe(reshape(trchead,120,[]));
        
        % get the headers
        for field=1:seismic.n_fields
            trace_headers(:, field) = ...
                int32(trace_header(bytes_to_samples == ...
                                   seismic.byte_locations(field),:))';
        end
        
        %ilxl_read = trace_headers(48:49,:)';        
        %offset_read = trace_headers(10,:)';        
        traces = traces(61:end,:);            
    else
        disp('This seismic file type is not currently supported. Please speak to Charles Jones.');
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

