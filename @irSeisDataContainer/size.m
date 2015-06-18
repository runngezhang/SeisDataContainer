function dims = size(A, dim)

dims = A.exsize;

if nargin == 2
    dims = dims(dim);
end

end