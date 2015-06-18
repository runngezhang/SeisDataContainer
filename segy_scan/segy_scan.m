function segy_scan(filepath, file_filter, header_byte_locations, ...
                   block_size, metafile)
%% --------- Function Definition ----------------------------------
    % Creates a metadata file for handling large multifile volumes of
    % segy data. Sums up blocks of segy data using compressed headers
    % of meta data.
    %
    %    Arguments:
    %       filepath (str) - Path to segy files
    %       file_filter (str) - Filter string for selecting a subset of segy
    %         files
    %       header_by_locations [] - List of header byte locations of
    %         the header values to use for trace descriptions.
    %       block_size (int) - The number of traces per data block.
    %       metafile (str) - The path/filename of the meta data summary
    %       file.
    %
    %    Write to Disk:
    %       metafile summarizing the segy volume
%%

    %% Initialize the job meta structure
    metadata = {};
    
    
    %% Find and filter the list of segy files
    [files_in,nfiles] = directory_scan(filepath,file_filter); 
    files_in.names = sort_nat(files_in.names);  
    
    
    %% Make the compressed trace header files
    for i_file = 1:nfiles

        filename = files_in.names{i_file};                         
        filepath = files_in.path{i_file};     
        
        [path, name, ext] = fileparts(filename);
     
        if(strcmp(ext,'.segy') | strcmp(ext, '.sgy') & ...
           (exist(strcat(filepath,name, '.mat_lite'), 'file') ~= 2))
            
            make_compressed_header_file(strcat(filepath, filename),...
                header_byte_locations,block_size); 
        end
    end % segy file loop
    
    %% Make the data blocks
    metadata.block_headers = [];
    metadata.ntraces = 0;
    for i_file = 1:nfiles
        
        % figure out the header file
        filename = files_in.names{i_file};                         
        filepath = files_in.path{i_file};  
        
        [path, name, ext] = fileparts(filename);
        header_file = strcat(filepath, name, '.mat_lite');
        
        seismic = read_header_file(header_file);
    
        % extract block headers mat_lite file
        block_headers = make_block_headers(header_file, block_size);
        metadata.block_headers = [metadata.block_headers, block_headers];
        
        % last two entries are min/max trace indices
        metadata.ntraces = metadata.ntraces + seismic.n_traces;
        
    end
    
    
    %% Save the metafile
    save(metafile, '-struct', 'metadata', '-v7.3');
   
end