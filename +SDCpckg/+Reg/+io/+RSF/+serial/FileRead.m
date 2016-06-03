function [x header] = FileRead(filename)
%FILEREAD  Read serial data and header from RSF file
%
%   [X, HEADER] = FileRead(FILENAME) reads
%       the serial array X from RSF file FILENAME and
%       puts RSF file attributes into HEADER struct (described
%       in help for SDCpckg.Reg.basicHeaderStruct)
%
%   FILENAME     - A string specifying the RSF file name
%
%   Note! needs MADAGASCAR SVN rev. 8140 or newer
%
 
    narginchk(1, 1);
    assert(SDCpckg.Reg.io.isFile(filename),...
        'Fatal error: file %s does not exist',filename)

% Read file
    [x dims delta origin label unit]=rsf_read_all(filename);

% Update header woth file atributes
    header = SDCpckg.Reg.basicHeaderStructFromX(x);
    [pathstr,header.varName,ext] = fileparts(filename);
    header.origin = origin;
    header.delta = delta;
    header.label = label;
    header.unit = unit;
    % label not implemented in rsf_par
    SDCpckg.Reg.verifyHeaderStructWithX(header,x);

end
