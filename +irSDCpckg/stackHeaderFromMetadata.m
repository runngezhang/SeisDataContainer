function header = stackHeaderFromMetaData(metadata_path)

    metadata = load(metadata_path);
    
   header = {};
    
    header.varName = 'Segy Volume';
    header.varUnits = 'Volume';
    
    header.scale = [1];
    
    header.metadata = metadata.block_headers;
                   
    header.labels = {'filename', 'min_il', 'max_il', 'min_xl','max_xl', ...
                     'byte_location', 'n_traces' };
                   
    header.units = {'string', 'integer', 'integer', 'integer', 'integer', ...
                    'integer', 'integer'};
    

end