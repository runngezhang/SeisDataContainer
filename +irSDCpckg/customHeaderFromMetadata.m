function header = customHeaderFromMetaData(metadata_path)

    metadata = load(metadata_path);
    seismic = read_header_file(metadata.block_headers{1});
    header = {};
    
    header.varName = 'Segy Volume';
    header.varUnits = 'Volume';
    
    header.scale = [1];
    
    header.metadata = metadata.block_headers;
    
	load('bytes_to_samples.mat');
	header.labels =  {};
	header.units =  {};
    	
	% Define labels based on chosen headerbytes using lookup table	
	for i=1:length(seismic.byte_locations);
		ii = cell2mat(bytes_to_samples_cell(:,1)) == seismic.byte_locations(i);
		header.labels = [header.labels, strcat('Min_',bytes_to_samples_cell{ii,2}),...
					strcat('Max_',bytes_to_samples_cell{ii,2})];
		header.units = [header.units, [], []];
	end %FOR
        
        
       % Add in the mandatory fields
       header.labels = ['filename', header.labels, 'byte_location', 'n_traces'];

end
