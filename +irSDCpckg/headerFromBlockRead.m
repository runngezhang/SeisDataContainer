function header = headerFromBlockRead(segy_header, trace_headers, type)
% Creates a header from irSeisDataContainer 


header = {};
header.varName = 'time';
header.varUnits = 'seconds';


header.scale = (0:segy_header.n_samples-1) * segy_header.s_rate/1000;

header.metadata = trace_headers;

if strcmp(type, 'stack')
    header.units = {'integer', 'integer'};
    header.labels = {'il', 'xl'};
else
    header.units = {'lon', 'lon', 'lat', 'lat'};
    header.labels = {'srcx', 'srcy', 'recx', 'recy'};
end

end