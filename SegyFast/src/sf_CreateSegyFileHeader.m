function [fileheader] = sf_CreateSegyFileHeader(fields);
%% Creates a 400 byte SEGY binary file header populated with input values
% 
%   Example: fileheader = sf_CreateSegyFileHeader('dsf',5,'dt',...
%                                           8000, 'ns', ns);
% 
%   For a complete list of supported file header fields run:
%      fileheader_bytes_to_samples_fun.m
% 
%   It is strongly recommened to include atleast the sample interval (dt),
%   number of samples (ns), and the data format (dsf), as these are 
%   generally required by SEGY readers.
%
%
%   Author: 
%       Keegan Lensink
%       Seismic Laboratory for Imaging and Modeling
%       Department of Earth, Ocean, and Atmospheric Sciences
%       The University of British Columbia
%         
%   Date: March, 2017



% Load the file header template
load('template_fileheader.mat')

% Get FileHeader lookup table
bts = fileheader_bytes_to_samples_fun;
fileheader = uint8(zeros(400,1));

nfields = size(fields,2);
for i = 1:nfields;
    for j = 1:size(bts,1);
        
        % Check for match
        if strcmp(bts{j,3}, fields{1,i});
            
            % Convert input from double to int
            if bts{j,1} == 2
                
                % Check Overflow
                if fields{2,i} > intmax('int16')
                    display(['Warning: Interger overflow in field "', fields{1,i},'"'])
                    display(['Field Max is: ', num2str(intmax('int16'))])
                end
                
                % Convert
                val = int16(fields{2,i});
                nbytes = 2;

            elseif bts{j,1} == 4
                
                % Check Overflow
                if fields{2,i} > intmax('int32')
                    display(['Warning: Interger overflow in field "', fields{1,i},'"'])
                    display(['Field Max is: ', num2str(intmax('int32'))])
                end
                
                % Convert
                val = int32(fields{2,i});
                nbytes = 4;
            end
            
            % Typecast and swap to big endian
            val = typecast(swapbytes(val),'uint8');
            
            % Go to start byte and replace
            startbyte = bts{j,2};
            bytes = (startbyte:startbyte+nbytes-1) - 3200;
            fileheader(bytes) = val;

        end % if
    end % for j
end % for i



