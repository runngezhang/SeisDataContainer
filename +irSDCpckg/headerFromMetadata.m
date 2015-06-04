function header = stackheaderFromMetaData(metadata_path)

    metadata = load(metadata_path);
    
    header = {};
    
    header.varName = 'Segy Volume';
    header.varUnits = 'Blocks';
    
    header.scale = [0:metadata.nvols];
    
    header.metadata = {'block': [0:metadata.nblocks], ...
                       'il_min': metadata.block_keys(:,1), ...
                       'il_max': metadata.block_keys(:,2), ...
                       'xl_min': metadata.block_keys(:,3), ...
                       'xl_max': metadata.block_keys(:,4)};
    

end