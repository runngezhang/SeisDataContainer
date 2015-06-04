function header = headerFromBlockRead(trace_headers, ilxl)
% Creates a header from irSeisDataContainer 


header = {};
header.varName = 'time';
header.varUnits = 'seconds';


header.scale = (0:trace_headers.n_samples-1) * trace_headers.s_rate/1000;

header.metadata = [ilxl(:,1), ilxl(:,2)];

header.units = {'line_num', 'line_num'};
header.labels = {'inline', 'xline'};

end