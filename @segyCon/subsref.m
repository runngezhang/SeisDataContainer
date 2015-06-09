function slice = subsref(A,S)
%% This will only read one block of data for now

switch S(1).type
    
    case {'.'}
        % attributes references and function calls
        if nargout > 0
            slice = builtin('subsref',A,S);
        else % function calls with no return value
            builtin('subsref',A,S);
        end
    case {'{}'}
        error('Cell-indexing is not supported.');
        
    case {'()'} % This is where all the magic happens
        if length(S) > 1
            error('Referencing from subsreffed components is not allowed');
        else
            
            if (length(S.subs) ~= 2) | (length(S.subs(1)) ~=1) | (length(S.subs(2)) ~=1)
                error('Can only read in single blocks, (m,n)')
            else
                
                slice = A.query(S.subs{1}, 'block', S.subs{2});
            end
        end
end
end