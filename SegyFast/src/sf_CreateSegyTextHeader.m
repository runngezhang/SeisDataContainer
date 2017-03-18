function [textheader] = sf_CreateSegyTextHeader(ASCII)
%% Creates a 40x80 EBCDIC text header to be used with sf_WriteSegy
%   
%   Use: [textheader] = sf_CreateSegyTextHeader(ASCII);
% 
%   ASCII must be a 40x80 array of uint8 values.
%
%   Author: 
%       Keegan Lensink
%       Seismic Laboratory for Imaging and Modeling
%       Department of Earth, Ocean, and Atmospheric Sciences
%       The University of British Columbia
%         
%   Date: March, 2017

% Check size
s = whos('ASCII');
if s.bytes == 3200
    textheader = uint8(ascii2ebcdic(ASCII(:)))';
else 
    error('Input must be 3200 bytes.')
end



