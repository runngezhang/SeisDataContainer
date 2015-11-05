classdef irSeisDataContainer
    % Abstract class for irregularly spaced seismic data
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Properties
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (SetAccess = protected)
        header = struct(); % header struct for dataContainer
        exsize = []; % Explicit dimensions of data
        perm   = []; % Permutation of data (since original construction)
        type   = ''; % Type of data container
    end
    
    properties ( Access = protected )
        data   = []; % Actual data for the container
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Private Methods
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = private)
        
        function check = validate_scale(obj, scale)
            
            check = size(scale,1) == obj.exsize(1);
        end
        
        function check = validate_metadata(obj, metadata)
            
            check = size(metadata, 2) == obj.exsize(2);
        end
        
    end
            
            
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Public Methods
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        
        % DataCon Constructor
        function x = irSeisDataContainer(headerIn, data_dims)
                                               
            % Set attributes
            x.header = headerIn;
            x.exsize = data_dims;

            p = inputParser;
            
            % number of spatial dimensions
            ldim = size(x.header.metadata,1);
            
            % Sample axis(time, frequency, depth, etc)
            p.addParamValue('varName',x.header.varName,@ischar);
            p.addParamValue('varUnits',x.header.varUnits,@ischar);
            p.addParamValue('scale',x.header.scale,@x.validate_scale);
            
            % Trace positions(n_dimensional)
            p.addParamValue('metadata', x.header.metadata, @x.validate_metadata)
            
            % units and unit labels for positions
            p.addParamValue('units',x.header.units,@(x)iscell(x)&&length(x)==ldims);
            p.addParamValue('labels',x.header.labels,@(x)iscell(x)&&length(x)==ldims);
            
            p.parse();
            
            
            % Add into the header structure
            x.header.varName  = p.Results.varName;
            x.header.varUnits = p.Results.varUnits;
            x.header.scale = p.Results.scale;
            
            x.header.metadata = p.Results.metadata;
            x.header.units = p.Results.units;
            x.header.labels = p.Results.labels;
            
        end % Constructor
                
    end % Public methods
    
end % Classdef