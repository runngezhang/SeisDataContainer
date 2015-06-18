function seismic = read_header_file(header_file)
    
    % main field location
    filepath_length = 2000;
    file_type_length = filepath_length+1;
    s_rate_length = file_type_length+1;
    n_samples_length = s_rate_length+1;
    n_traces_length = n_samples_length+1; 
    n_fields_length = n_traces_length +1;
    
    % open the file
    fid = fopen(header_file,'r');                        
    message = ferror(fid); 
    tmp_seismic = fread(fid,'double');                        

    %------------------CREATING THE STRUCTURE TO OUTPUT-------------------
    seismic.filepath = char(tmp_seismic(1:filepath_length,1)'); % File Path
    seismic.file_type = tmp_seismic(file_type_length,1);        % File Type
    seismic.s_rate = tmp_seismic(s_rate_length,1);              % Sample Rate
    seismic.n_samples = tmp_seismic(n_samples_length,1);        % Number of samples in a trace?
    seismic.n_traces = tmp_seismic(n_traces_length,1);         
    
    seismic.n_fields = tmp_seismic(n_fields_length); 
    
    index = n_fields_length +1;
    for field = 1:seismic.n_fields
        seismic.byte_locations(field) = tmp_seismic(index);
        index = index+1;
    end
    
    
    
    
    
    traces_length = index;


    seismic.compressed_headers = reshape(tmp_seismic(traces_length:end),...
                                         seismic.n_fields+1,[])';


    fclose(fid);                                                % Close File
end