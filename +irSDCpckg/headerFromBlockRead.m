function header = headerFromBlockRead(segy_header, trace_headers, type, header_bytes)
% Creates a header from irSeisDataContainer 


header = {};
header.varName = 'time';
header.varUnits = 'seconds';


header.scale = (0:segy_header.n_samples-1) * segy_header.s_rate/1000;

header.metadata = trace_headers;

if strcmp(type, 'stack');
    header.units = {'integer', 'integer'};
    header.labels = {'il', 'xl'};
elseif strcmp(type, 'shot');
    header.units = {'lat', 'lon', 'lat', 'lon'};
    header.labels = {'srcx', 'srcy', 'recx', 'recy'};
elseif strcmp(type, 'custom');

	if isempty(header_bytes);
		header_bytes = segy_header.byte_locations;
	end %IF
	
	load('bytes_to_samples.mat');
	header.labels =  {};
   	header.units =  {};
    	
   	% Define labels based on chosen headerbytes using lookup table	
	for i=1:length(header_bytes)
		ii = cell2mat(bytes_to_samples_cell(:,1)) == header_bytes(i);
		header.labels = [header.labels bytes_to_samples_cell{ii,2}];
		header.units = [header.units []];
        end %FOR

end

end
