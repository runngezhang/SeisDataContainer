function assertElementsAlmostEqual(varargin)
%assertElementsAlmostEqual Assert floating-point array elements almost equal.
%   assertElementsAlmostEqual(A, B, tol_type, tol, floor_tol) asserts that all
%   elements of floating-point arrays A and B are equal within some tolerance.
%   tol_type can be 'relative' or 'absolute'.  tol and floor_tol are scalar
%   tolerance values.
%
%   If the tolerance type is 'relative', then the tolerance test used is:
%
%       all( abs(A(:) - B(:)) <= tol * max(abs(A(:)), abs(B(:))) + floor_tol )
%
%   If the tolerance type is 'absolute', then the tolerance test used is:
%
%       all( abs(A(:) - B(:)) <= tol )
%
%   tol_type, tol, and floor_tol are all optional.  The default value for
%   tol_type is 'relative'.  If both A and B are double, then the default value
%   for tol is sqrt(eps), and the default value for floor_tol is eps.  If either
%   A or B is single, then the default value for tol is sqrt(eps('single')), and
%   the default value for floor_tol is eps('single').
%
%   If A or B is complex, then the tolerance test is applied independently to
%   the real and imaginary parts.
%
%   assertElementsAlmostEqual(A, B, ..., msg) prepends the string msg to the
%   output message if A and B fail the tolerance test.

varargin = cellfun(@(p) IcDataCon.stripicon(p),...
    varargin,'UniformOutput',false');
assertElementsAlmostEqual(varargin{:});