function [traceheader] = sf_CreateSegyTraceHeader(ntraces, fields);
%% Creates an array of 240 byte SEGY trace headers populated with 
% input arguments.
%   Use: [traceheader] = sf_CreateSegyTraceHeader(ntraces, fields)

% Load the trace header template
load('template_traceheader.mat')

% Generate the lookup table
bts = traceheader_bytes_to_samples_fun;

% Generate blank headers
traceheader = repmat(template_traceheader,[1 ntraces]);

% Loop to populate headers
nfields = size(fields,2);
for i = 1:nfields;
    for j = 1:size(bts,1);
        
        % Check for match
        if strcmp(bts{j,3}, fields{1,i});
            
            % If it is a single int, convert to vector
            if length(fields{2,i}) == 1;
                fields{2,i} = repmat(fields{2,i},[ntraces,1]);
            end

            % Convert input from double to int
            if bts{j,1} == 2
             
                % Check Overflow
                if max(fields{2,i}) > intmax('int16')
                    display(['Warning: Interger overflow in field "', fields{1,i},'"'])
                    display(['Field Max is: ', num2str(intmax('int16'))])
                end
                
                % Convert
                val = int16(fields{2,i});
                nbytes = 2;

            elseif bts{j,1} == 4
                
                % Check Overflow
                if max(fields{2,i}) > intmax('int32')
                    display(['Warning: Interger overflow in field "', fields{1,i},'"'])
                    display(['Field Max is: ', num2str(intmax('int32'))])
                end
                
                % Convert
                val = int32(fields{2,i});
                nbytes = 4;
            end
            
            % Typecast
            val = typecast(swapbytes(val),'uint8');
            
            % Reshape to match template format
            val = reshape(val,nbytes,[]);

            % Go to start byte and replace
            startbyte = bts{j,2};
            bytes = (startbyte:startbyte+nbytes-1);
            traceheader(bytes,:) = val; 
            
        end % if
    end % for j
end % for i




