function y = inv(x)
%INV    Matrix inverse.
%   INV(X) is the inverse of the square matrix X.
%   A warning message is printed if X is badly scaled or
%   nearly singular.

y             = inv(double(x));
if isa(y, 'distributed')
    y = piCon(y);
else
    y = iCon(y);
end
y             = metacopy(x,y);
y.perm        = fliplr(x.perm);
y.exsize      = fliplr(x.exsize);
indshift      = y.exsize(1);
y.exsize(:,1) = y.exsize(:,1) - indshift + 1;
y.exsize(:,2) = y.exsize(:,2) + indshift - 1;