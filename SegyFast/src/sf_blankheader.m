function text_ascii = sf_blankheader()
%% Create a 40x80 blank header

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


