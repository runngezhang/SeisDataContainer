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

    % Scroll back to the header
    start_byte = start_byte - 240;
    
    fid = fopen(char(seismic.filepath),'r','b');
    fseek(fid,start_byte,'bof');

    if seismic.file_type == 1 || seismic.file_type == 5
 
        %Read entire block as uint8
        FullTraces_8 = fread(fid,[240+seismic.n_samples*4,n_traces_to_read],...
                           '*uint8');
                           
        %Pull out trace headers       
        Headers_8 = FullTraces_8(1:240,:);
        
        %Interpret the header values
        trace_headers = interpret_headers( Headers_8, header_bytes, seismic.byte_locations);
        
                   
    else
        disp('This seismic file type is not currently supported.');
    end

    fclose(fid);  
end

