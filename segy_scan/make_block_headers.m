function block_headers = make_block_headers(header_file, block_size)
%%----------------Function Definition------------------------
% Breaks the trace header information into blocks and returns
% header values to fully describe each block
%
%   Arguvments:
%     header_file (str): Path the mat_lite file with the compressed
%           trace headers.
%     block_size (int): The number of traces per block
%
%  Returns:
%    [v1_min, v1_max,......, vn_min, vn_max, start_ind, end_ind]
%%
    
    block_headers = [];
    
    seismic = read_header_file(header_file);
    
    n_blocks = floor(seismic.n_traces / block_size)
    
    for block=1:n_blocks
        
        start_ind = (block-1)*block_size +1;
        end_ind = block * block_size;
        
        headers = seismic.compressed_headers(start_ind:end_ind, :);
      
        block_header = populate_block_header(header_file, seismic, ...
                                             headers, block_size);
      
        block_headers = [block_headers; block_header];
        
    end
    
    % Left overs
    block_size = seismic.n_traces - (n_blocks * block_size);
    if block_size > 0
        start_ind = floor(n_blocks * block_size) + 1
        
        headers = seismic.compressed_headers(start_ind:end, :);
        
        block_header = populate_block_header(header_file, seismic, ...
                                             headers, block_size);
       
        block_headers = [block_headers; block_header];
    end
    
end

function block_header = populate_block_header(header_file, seismic, ...
                                              headers, block_size)
    
    block_header = {header_file};
    
    % Get the min and max value of each field
    ind = 2;
    for field =1:seismic.n_fields
        
        block_header{ind} = min(headers(:,field));
        ind = ind + 1;
        block_header{ind} = max(headers(:, field));
        ind = ind + 1;
        
    end
    
    % Get the byte locations
    block_header{end+1} = min(headers(:, end));
    
    % Number of traces in block
    block_header{end+1} = block_size;   
    
end