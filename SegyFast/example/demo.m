% Script to demo SegyFastWriter
clear;

%% ----- Create Data ----- 
% First make up some data to save as a SEGY file.

% Metadata
ns = 1001;
dt = 8000; %microseconds
dsf = 5; % (IEEE 4-bytes singles) If not specified this is the default
ntraces = 100000;
sx = (1:ntraces) + double(intmax('int32')); % The writer will warn you of int overflow
sy = 1:ntraces;
rx = 1:ntraces;
ry = 1:ntraces;

% Data
trace = 0:ns-1;
data = single(repmat(trace', [1,ntraces]));

%% -----  Create Text Header ----- 

% For the sake of this demo, we just want to prepare a text header that is empty except for
% displaying the line number in the first character of each row. To do this, create a
% 40x1 cell, then just use the 'char' function to convert it to a character array. This 
% method would allow you to write a more complicated text header without having to worry
% about padding each line with spaces.

% Initialise an empty header
text_cell = cell(40,1);

% Create 40 rows
for irow =1:40
    
    % Create an 80 character string 
    text_line = [sprintf('%02u',irow), blanks(78)];

    % Add to cell
    text_cell{irow} = text_line;

end

% Convert cell array to char array
text_char = char(text_cell);

% Finally, convert char array to ascii
text_ascii = uint8(text_char);

%% ----- Write the file -----
% Now we can just input the data and metadata into the writing function using key/value
% pairs.
filename = 'example2.segy';

% Metadata is specified using the same key/value pairs that you are probably familiar with
% from using segyMAT. To view all of the keys for supported metadata fields type
% 'help SegyFastWriter'. Metadata that varies amongst traces can be input as a vector as long
% as it is ntraces long. If the textheader is left empty, a blank header will be created.
tic;
SegyFastWriter(filename,data,[],'dt', dt, 'dsf', dsf, 'ns', ns, 'SourceX',...
                sx,'SourceY',sy,'GroupX',rx,'GroupY',ry)
t = toc;


