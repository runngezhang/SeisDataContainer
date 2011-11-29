classdef oCon < dataContainer
    %OCON  Out-of-core Data Container class
    %
    %   oCon(TYPE,DIMS,ISCOMPLEX)
    %
    %   Parameters:
    %   format - The precision of the data file. default 'double'
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   PROPERTIES
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (Access = protected)
        pathname = '';
        iscomplex; % True if data is complex
    end
    
    methods (Access = protected)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function x = oCon(type,dims,iscomplex,varargin)
            % Constructor for the out-of-core data container class
            % Not supposed to be called by user
            
            % Preprocess input arguments
            assert(isnumeric(dims),'Dimensions must be a numeric')
            assert(isvector(dims), 'Dimensions must be a vector')
            
            % Construct
            x           = x@dataContainer(type,dims,dims,varargin{:});
            x.iscomplex = iscomplex;
%             x.excoddims = length(dims) - 1;
%             x.imcoddims = x.excoddims;
%             x.excodpart = DataContainer.utils.defaultDistribution(dims(end-1));
%             x.imcodpart = x.excodpart;
                        
        end % constructor
    end % protected methods
    
    methods
        % delete function
        function delete(x)
            % Amazing deletion happens here            
        end % delete
    end
       
end % classdef























