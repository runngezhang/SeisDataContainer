function y = metacopy(x,y)
%METACOPY   Function that copies metadata between data containers
%
%   y = metacopy(x,y) will copy the metadata of data container x into y and
%   return y.

y.exsize = x.exsize;
y.perm   = x.perm;
y.strict = x.strict;