%% oMatCon Walkthrough
% A concise guide to the functionality and guts of the oMatCon Out-of-Core
% Native Binary Data Container.
%
% *Required software packages*
%
% You will need SLIM's spot and datacontainer packages installed to be able
% to run this demo.
%
% * *Spot* - <https://github.com/slimgroup/spot>
% * *oSpot* - <https://github.com/slimgroup/oSpot>
% * *SeisDataContainer* - <https://github.com/slimgroup/SeisDataContainer>

%% Basic Usage
% The oMatCon data container is designed to open external files stored in
% hard drives and load them in as a Matlab object, and exposing as little
% as possible the low level complexities and tinkering needed for such a
% maneuver to work. For example:
%

%%
% *Directory name*
%
% Here we have a preconfigured data file in native binary format
% stored in the specified directory:
directory = [SDCpckg.path 'demos' filesep 'data' filesep 'data1']

%%
% *Loading the file as an oMatCon datacontainer*
x = oMatCon.load(directory)

%%
% *Displaying the data contained*
%
% _Note: due to the large amount of data usually contained, calling double
% on an oMatCon is not recommended._
double(x)

%%
% *Setting up and applying kronecker product on data*

A = opoKron(opDFT(5),opDFT(5));
y = A*x(:)

%%
% *Displaying the answer*
double(y)


%% Other oft-used functions
%
% These functions are mostly overloads of Matlab's builtin methods
%
% * *reshape*
% * *transpose*
% * *norm*
% * *vec*
% * *invvec*
%
% For more information please type "help oMatCon/<function name>" in the
% Matlab console.

%% Breakdown of oMatCon components
% The oMatCon design philosophy is to empower users so they could use and 
% manipulate large data files living on harddisk as if they were mere 
% matlab arrays. It also provides a convenient handle to the file's
% metadata and intelligently handles it along the way of the data process.
%
%

%%
% *The pathname*
%
% All out-of-core datacontainers has an attribute called |pathname| which 
% holds the file's directory address where it physically stores the data. 
%
% In this specific implementation of the out of core container, oMatCon's
% pathname actually represents a contained folder where all of the
% datacontainer's information are stored in 3 seperate files:
%
% * *header.mat* - Where all of the file's metadata is stored. For more
% information please refer to the header section.
% * *real* - Stores the real part of the data in native binary format.
% * *imag* - Stores the imaginary part of the data in native binary format.
% If the data is purely real, this file will be absent.

%%
% *The header*
%
% The header is where all of the metadata pertaining to the data is stored.
% In oMatCon we currently have these attributes:
%
% Care must be taken to update the header.mat file after every operation
% so that it is synchronized with the object's version of the header.
%
% * *varName* - string holding the name of variable
% * *varUnits* - string holding the units of variable
% * *dims* - number of dimensions of the array
% * *size* - sizes of the array
% * *origin* - row vector holding the origin coordinate for each axis
% * *delta* - row vector holding the delta of coordinate value for each axis
% * *precision* - array precision
% * *complex* - if complex (no=0 or yes=1)
% * *unit* - cell array of strings with units for each axis
% * *label* - cell array of strings with label for each axis
% * *distributedIO* - if distributed IO (no=0 or yes=1)
