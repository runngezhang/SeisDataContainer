function [trace_headers] = interpret_headers(Headers_8, HeaderBytes, SeismicByteLocations) 
%% Interprets 240 byte long trace headers and passes out the values specified by the vector of starting bytes ' HeaderBytes'

%Check for headerbytes overwrite
if isempty(HeaderBytes);
	StartingLocations = SeismicByteLocations;
else
	StartingLocations = HeaderBytes;
end %IF

%Pre-allocate memory for trace headers
trace_headers = zeros(size(Headers_8,2), length(StartingLocations));

%Load byte location lookup table
load('bytes_to_samples.mat')
bytes_to_samples=cell2mat(bytes_to_samples_cell(:,1));

for field = 1:length(StartingLocations);
	
	%Prevent index outside domain
	if StartingLocations(field) == 237;
		byte_type=4;
	else
		i = find(bytes_to_samples == StartingLocations(field));
		byte_type = bytes_to_samples(i+1) - bytes_to_samples(i);
	end %IF
	
	%Assign precision for conversion
	if byte_type == 4;
		precision = 'int32';
	elseif byte_type ==2;
		precision = 'int16';
	else 
		display('Invalid Byte type')
		return
	end %IF
	
	%Isolate bytes that correspond to header value
	iso = Headers_8(StartingLocations(field):StartingLocations(field)+byte_type-1,:);
	
	%Interpret according to precision and write to trace_headers
	trace_headers(:,field) = swapbytes(typecast(iso(:), precision));
	
end %FOR


end %FUNC
