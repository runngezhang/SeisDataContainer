function slice = subsref(A, S)

data = A.data;

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
            slice = subsref(data, S);
        end
end

end