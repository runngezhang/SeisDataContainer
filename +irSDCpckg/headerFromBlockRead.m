function header = headerFromBlockRead(segy_header, trace_headers)
% Creates a header from irSeisDataContainer 


header = {};
header.varName = 'time';
header.varUnits = 'seconds';


header.scale = (0:segy_header.n_samples-1) * segy_header.s_rate/1000;

header.metadata = trace_headers;

header.units = {'lon', 'lon', 'lat', 'lat'};
header.labels = {'srcx', 'srcy', 'recx', 'recy'};

end