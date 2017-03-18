function sf_WriteSegy(filename,textheader,fileheader,traceheader,data, dsf)
%% Writes a segy file using headers generated with the sf toolbox
% Use: sf_WriteSegy(filename,textheader,fileheader,traceheader,data)

% Open the file for writing
fid = fopen(filename, 'w', 'b');

% Convert the data to ieee singles
switch dsf
    
    % IEEE 754 4-Bytes Singles
    case 5
    data = single(data);
    
    % IBM 4-Byte Floats
    case 1
    data = num2ibm(data); % Function from segyMAT package

end
    
[ns, ntraces] = size(data);

% Typecast as little endian uint8
data = typecast(swapbytes(data(:)),'uint8');

% Reshape back for concatonation
data = reshape(data,[],ntraces);

% Concatonate for writing
towrite = [traceheader;
           data];

% Clear mem
traceheader = [];
data = [];

% Prep for write
towrite = [textheader(:); fileheader(:); towrite(:)];

% Write
fwrite(fid,towrite);

fclose(fid);





