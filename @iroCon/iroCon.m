classdef iroCon < irSeisDataContainer
    %OCON  Out-of-core Data Container class for non-matrix data
    %
    %   oCon(HEADER,PARAMETERS...)
    %
    %   Parameters:
    %   format - The precision of the data file. default 'double'
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   PROPERTIES
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        pathname = '';
        samples_range=[];
    end
    
    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function x = iroCon(headerIn,varargin)
            % Constructor for the out-of-core data container class
            % Not supposed to be called by user
            
            % Construct            
            x = x@irSeisDataContainer(headerIn,varargin);
        end % constructor
    end % protected methods
end % classdef
    
    
