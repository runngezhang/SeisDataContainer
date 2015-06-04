function header = stackheaderFromMetaData(metadata_path)

    metadata = load(metadata_path);
    
    header = {};
    
    header.varName = 'Segy Volume';
    header.varUnits = 'Volumes';
    
    header.scale = [0:metadata.nvols];
    
    header.metadata = cat(1,(1:metadata.n_blocks), ...
                       metadata.block_keys(:,1)', ...
                       metadata.block_keys(:,2)', ...
                       metadata.block_keys(:,3)', ...
                       metadata.block_keys(:,4)');
                   
    header.labels = {'block', 'min_il', 'max_il', 'min_xl', 'max_xl'};
                   
    header.units = {'index', 'line_num', 'line_num', 'line_num', 'line_num'};
    

end