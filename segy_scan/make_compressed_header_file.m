function make_compressed_header_file(segyfile, header_byte_locations, ...
                                     block_size)
 %% -------------------------Function Definition-----------------------
    % Summarize the trace headers of a segy file using a few header
    % fields.
    %
    %    Arguments:
    %         segyfile (str): Path to the segyfile
    %         header_byte_locations []: List of header byte locations of
    %            the header values to use for trace descriptions.
    %         block_size (int): The number of trace headers to read
    %            into memory at once.
    %
    %    Writes to Disk:
    %        mat_lite file with the summarized trace headers
 %%
 
    % Get the segy file header
    seismic_header = extract_seismic_header(segyfile);
    
    % Summarize the trace headers
    header_file_init(seismic_header, block_size, header_byte_locations);
    
    
end


function header_file_init(seismic, block_size, ...
                          header_byte_locations)
%% --------------------Function Definition---------------------------
% Makes a matlite file that summarizes the byte locations for each trace.
%%
    bytes_per_sample = seismic.bytes_per_sample;
  
    % Break up file into path and extentions
    [filepath, filename, ext] = fileparts(seismic.filepath);
    matfile_lite = strcat(filepath,'/', filename, '.mat_lite');

    % Convert File path into 64-bit integer array
    filepath_binary = uint64(seismic.filepath);  

    % Padding for file path by zeros at the end to make its length 2000
    pad_filepath = zeros(1,(2000-length(filepath_binary)));  
    filepath_binary = [filepath_binary,pad_filepath];

    % write basic information into .mat_orig_lite file
    fid_write = fopen(matfile_lite,'w');                           
    fwrite(fid_write,[filepath_binary';seismic.file_type;seismic.s_rate;...
                      seismic.n_samples;seismic.n_traces; ...
                      length(header_byte_locations)], 'double');
    
    skip_textual_binary = 3600; % Length of EBCIDIC header (bytes)
    trc_head = 240;             % Length of Trace Header (bytes)
    trc_length = seismic.n_samples*bytes_per_sample; % Length of trace (bytes)
    last_byte = 0;

    
    % Set number of traces per block
    blocktr = block_size;       
    if seismic.n_traces < blocktr
        blocktr = seismic.n_traces;
    end
    loop_end = floor(seismic.n_traces/blocktr);    

    % Loop to read segy data 
    for ii = 1:loop_end
        
        % Read blocktr x trace headers and trace data as uint32 into a 
        % temporary matrix
        tmptr = fread(seismic.fid,...
                      [120+(bytes_per_sample/2)*seismic.n_samples,blocktr],...
                      'uint16=>uint16');
        tmptr = tmptr(1:120,:);
        
        % Extract the header and byte mapping
        [trace_header bytes_to_samples] = interpret(tmptr);

        % Get the header values
        for jj = 1:length(header_byte_locations)
            compressed_header(:,jj) = trace_header(bytes_to_samples ==...
                                                   header_byte_locations(jj),:);
        end
        
        
        % byte location of start of block
        compressed_header(:,end+1) = last_byte+(trc_head:trc_head+...
                                              trc_length:blocktr* ...
                                              (trc_length+trc_head));
        
        % store to add on during loop
        last_byte = compressed_header(end,end+1)+trc_length;
        compressed_header(:,end+1) = compressed_header(:,end)+ ...
            skip_textual_binary;
        
        % write out the structure
        fwrite(fid_write,reshape(compressed_header',[],1),'double');
        
    end
    
    % Calculate the number of trace headers not read by the loop above
    leftovers = seismic.n_traces-loop_end*blocktr;

    % Read the remaining trace headers (if any)
    clearvars tmptrheader trace_header bytes_to_samples compressed_header
    if leftovers > 0
        tmptr = fread(seismic.fid,[120+2*seismic.n_samples,leftovers],'uint16=>uint16');
        tmptr = tmptr(1:120,:);
        [trace_header, bytes_to_samples] = interpret(tmptr);
        
        
        % Get the header values
        for jj = 1:length(header_byte_locations)
            compressed_header(:,jj) = trace_header(bytes_to_samples ==...
                                                   header_byte_locations(jj),:);
        end
        
        
        % byte location of start of block
        compressed_header(:,end+1) = last_byte+(trc_head:trc_head+...
                                              trc_length:leftovers* ...
                                              (trc_length+trc_head));
        
        % store to add on during loop
        last_byte = compressed_header(end,end+1)+trc_length;
        compressed_header(:,end+1) = compressed_header(:,end+1)+ ...
            skip_textual_binary;
        
        % write out the structure
        fwrite(fid_write,reshape(compressed_header',[],1), ...
               'double');
    end

    % Close segy file
    
    fclose('all');                                         
end


function seismic = extract_seismic_header(segyfile)
%% -------------------------Function Definition-----------------------
%  Extracts the seismic file header into a matlab structure
%  
%  Returns a seismic header structure
% 
%  Fields:
%    filepath: Path to the segy file
%    fid: Unique file id descriptor (fopen)
%    text_header: Ascii header from the segy file
%    binary_header: Binary header from the segy file
%    n_samples: Number of samples per trace
%    s_rate: Sample rate of the data [hz]
%    file_type: (1:5) integer specifying the type of segy file
%    n_traces: Number of traces in the segy file
%%
    
      % Create a structure seismic for the segy file header information
    seismic = {};

    % Read input file
    seismic.filepath = segyfile;     

    % Find and store file ID after opening in Big-endian ordering
    seismic.fid = fopen(seismic.filepath,'r','b');               
    
    % Read the seismic EBCDIC HEADER first 3200 characters
    seismic.text_header = fread(seismic.fid,3200,'uchar');  

    % Reshape the string of 3200 characters into a 80 x 40 matrix and
    % convert to ASCII
    seismic.text_header = char(ebcdic2ascii(reshape(seismic.text_header,80,40)')); 
    
    % Read binary header (400 bytes)
    seismic.binary_header = fread(seismic.fid,400,'uint8'); 

    % Re-interpret binary header as uint16 or uint32 as required
    two_bytes = seismic.binary_header(1:2:399)*256 + seismic.binary_header(2:2:400);
    four_bytes = ((seismic.binary_header(1:4:9)*256 + ...
                   seismic.binary_header(2:4:10))*256+ ...
                  seismic.binary_header(3:4:11))*256+seismic.binary_header(4:4:12);
    seismic.binary_header = [four_bytes(1:3);two_bytes(7:200)];

  
    %-------------------------------------------------------------------
    %-----WRITE SOME MORE INFORMATION IN THE STUCTURE FROM HEADERS------------
    seismic.n_samples = seismic.binary_header(8);             
    seismic.s_rate = seismic.binary_header(6);                 
    seismic.file_type = seismic.binary_header(10);            
    
    
    % need to break if not 1 or 5 because we don't handle it
    if seismic.file_type < 1 || seismic.file_type > 5 
        msgID = 'segy_make_structure:BadFileType';
        msg = 'segy file type must be between 1 and 5';
        baseException = MException(msgID,msg);
        throw(baseException);
    else
        bytes_per_sample = 4;  % Assign default 4 bytes per sample
    end
    
    seismic.bytes_per_sample = bytes_per_sample;
    
    ll = dir(seismic.filepath);

    % Number of traces = (file size - header size)/ 
    %                    (size of each trace+size of trace header)
    seismic.n_traces = (1/bytes_per_sample)*(ll.bytes-3600)/ ...
        (seismic.n_samples+60); 
    
end

function [trace_header bytes_to_samples] = interpret(tmptrheader)
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
            trace_header(ii,:) = double(tmptrheader(count,:))*2^16 + ...
                double(tmptrheader(count+1,:));
            count = count+2;
        end
    end

    trace_header(21,:) = trace_header(21,:)-2^16;

end