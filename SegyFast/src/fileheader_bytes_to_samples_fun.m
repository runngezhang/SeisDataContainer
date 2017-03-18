function [fileheader_bytes_to_samples_cell] = fileheader_bytes_to_samples_func;
%% [fileheader_bytes_to_samples_cell] = fileheader_bytes_to_samples_func;
% Returns the array describing how the file header in SEGY files 
% is organized

fileheader_bytes_to_samples_cell = {...
4 [3201] 'JobID';
4 [3205] 'LineNumber';
4 [3209] 'ReelNumber';
2 [3213] 'DataTracesPerRecord';
2 [3215] 'AuxiliaryTracesPerRecord';
2 [3217] 'dt';
2 [3219] 'dt_orig';
2 [3221] 'ns'; 
2 [3223] 'ns_orig';
2 [3225] 'dsf'; 
2 [3227] 'CDPfold';
2 [3229] 'TraceSortingCode'};

