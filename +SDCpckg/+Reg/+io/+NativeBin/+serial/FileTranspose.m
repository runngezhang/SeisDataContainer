function FileTranspose(dirnameIn,dirnameOut,sepDim)
%DATATRANSPOSE Transposes input data and writes it to output file
%
%   FileTranspose(DIRNAMEIN,DIRNAMEOUT,SEPDIM)
%   allocates binary file for serial data writing.
%
%   dirnameIn  - A string specifying the input directory
%   dirnameOut - A string specifying the output directory
%   SEPDIM - A scalar specifying the separation dimension
%
%   Warning: If the specified output file already exists, it will be 
%            overwritten.

SDCpckg.Reg.io.isFileClean(dirnameIn);
SDCpckg.Reg.io.isFileClean(dirnameOut);
narginchk(3, 3);
assert(ischar(dirnameIn), 'input directory name must be a string')
assert(isdir(dirnameIn),'Fatal error: input directory %s does not exist',dirnameIn);
assert(ischar(dirnameOut), 'output directory name must be a string')
assert(isscalar(sepDim), 'dimensions must be given as a vector')

% Read header
headerIn = SDCpckg.Reg.io.NativeBin.serial.HeaderRead(dirnameIn);

% Making the transpose vector
dim2D    = [prod(headerIn.size(1:sepDim)) prod(headerIn.size(sepDim+1:end))];

% Setting up the output header
headerOut = headerIn;
headerOut.size = [headerIn.size(sepDim+1:end) headerIn.size(1:sepDim)];
headerOut.origin = [headerIn.origin(sepDim+1:end) headerIn.origin(1:sepDim)];
headerOut.delta = [headerIn.delta(sepDim+1:end) headerIn.delta(1:sepDim)];
headerOut.unit = [headerIn.unit(sepDim+1:end) headerIn.unit(1:sepDim)];
headerOut.label = [headerIn.label(sepDim+1:end) headerIn.label(1:sepDim)];
SDCpckg.Reg.io.NativeBin.serial.HeaderWrite(dirnameOut,headerOut);

% Transpose file
SDCpckg.Reg.io.NativeBin.serial.FileAlloc(dirnameOut,headerOut);
SDCpckg.Reg.io.setFileDirty(dirnameOut);
SDCpckg.Reg.io.NativeBin.serial.DataTranspose(dirnameIn,dirnameOut,'real',...
    dim2D,headerOut.precision);
if headerOut.complex
    SDCpckg.Reg.io.NativeBin.serial.DataTranspose(dirnameIn,dirnameOut,'imag',...
        dim2D,headerOut.precision);
end
SDCpckg.Reg.io.setFileClean(dirnameOut);

end
