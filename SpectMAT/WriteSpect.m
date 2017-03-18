function WriteSpect(pathtowrite,filename,file_header,headers,complexdata)
%% Write complex data into .spect format
% Use: WriteSpect(pathtowrite,filename,fileheader,headers,complexdata)
%
%
% FORMAT IS ALL IN  DOUBLES
% towrite = [32 byte File Header] + {[32 byte Trace Header] + [ns*8 bytes real part of trace]
%           + [ns*8 bytes imag part of trace]}*ntraces
%
% FILE HEADER, must be a 4x1 vector
% 	1st sample in file header is f0, the frequency of the first sample
% 	2nd sample in file header is df, the frequency resolution
% 	3rd sample in file header is ns, the number of samples before being decomposed into
% 	real and imag parts.
% 	4th sample in file header is ntraces, the number of traces in the file.
%
% TRACE HEADER, must be a (4,ntraces) aray
% 	1: Source X
%	2: Source Y
%	3: Receiver X
%	4: Receiver Y
%
% Then all real parts, followed by all imaginary parts for 
% each trace.

% Decompose complex data into real and imag parts
Dr = real(complexdata);
Di = imag(complexdata);

% Get metadata from file_header
ns = file_header(3);
ntraces = file_header(4);

% Create array to write
towrite = [headers; Dr; Di];

% Open file for writing
fid = fopen([pathtowrite,filename],'w');

% Write in the towrite vector
fwrite(fid,[file_header; towrite(:)],'double');

% Close the file
fclose(fid);

