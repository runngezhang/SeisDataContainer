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
        

        function container = regularize(obj)
            meta = obj.header.metadata;
            
            min_x = min(meta(:,1));
            max_x = max(meta(:,1));
            min_y = min(meta(:,2));
            max_y = max(meta(:,2));
            
            data = zeros(length(obj.header.scale), max_x - min_x +1, ...
                         max_y - min_y +1);
            
            trace = 0;
            for i = [meta(:,1)'-min_x; meta(:,2)'-min_y]
                trace = trace + 1;
                data(:,i(1)+1, i(2)+1) = obj.data(:,trace);
            end
            
            container = data;
        end
    end % protected methods
end % classdef