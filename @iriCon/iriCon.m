classdef iriCon < irSeisDataContainer
    %ICON  In Core Data Container class for non-matrix data
    %
    %   oCon(HEADER,PARAMETERS...)
    %
    %   Parameters:
    %   format - The precision of the data file. default 'double'
    
    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function x = iriCon(headerIn,varargin)
            % Constructor for the out-of-core data container class
            % Not supposed to be called by user
            
            % Construct            
            x = x@irSeisDataContainer(headerIn,varargin{:});
        end % constructor
    end % protected methods
end % classdef