function header = shotHeaderFromMetaData(metadata_path)

    metadata = load(metadata_path);
    
    header = {};
    
    header.varName = 'Segy Volume';
    header.varUnits = 'Volume';
    
    header.scale = [1];
    
    header.metadata = metadata.block_headers;
                   
    header.labels = {'filename', 'min_srcx', 'max_srcx', 'min_recx', ...
                     'max_recx', 'max_recy', 'byte_location', 'n_traces' };
                   
    header.units = {'string', 'lon', 'lon', 'lat', 'lat', 'integer',...
                    'integer'};
    

end