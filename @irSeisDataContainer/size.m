function dims = size(A, dim)

dims = A.exsize{1};

if nargin == 2
    dims = dims(dim);
end

end