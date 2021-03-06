function theResult = wigglex(x, y, z, varargin)

% wigglex -- Wiggle-plot with variation in x.
%  wigglex(x, y, z, ...) plots the columns of z(x, y)
%   as vertical traces, with origins given by vector x.
%   The "line" handles are returned if requested.
%   Additional arguments are passed directly to "plot".
%   The columns of z should be roughly zero-mean, with
%   variances scaled according to the x intervals.
%  wiggles(z, ...) plots z with x and y corresponding
%   to the size of the z matrix.
%  wiggles('demo') demonstrates itself.
%  wiggles(m, n) demonstrates itself for a random z-array
%   of size [m n] (default is [50 25]).


%%% START USGS BOILERPLATE -------------%
% Use of this program is described in:
%
% Acoustic Doppler Current Profiler Data Processing System Manual 
% Jessica M. C�t�, Frances A. Hotchkiss, Marinna Martini, Charles R. Denham
% Revisions by: Andr�e L. Ramsey, Stephen Ruane
% U.S. Geological Survey Open File Report 00-458 
% Check for later versions of this Open-File, it is a living document.
%
% Program written in Matlab v7.1.0 SP3
% Program updated in Matlab 7.2.0.232 (R2006a)
% Program ran on PC with Windows XP Professional OS.
%
% "Although this program has been used by the USGS, no warranty, 
% expressed or implied, is made by the USGS or the United States 
% Government as to the accuracy and functioning of the program 
% and related program material nor shall the fact of distribution 
% constitute any such warranty, and no responsibility is assumed 
% by the USGS in connection therewith."
%
%%% END USGS BOILERPLATE --------------

  
% Copyright (C) 1998 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 12-Sep-1998 06:22:41.

if nargin < 1, x = 'demo'; end

if isequal(x, 'demo'), x = 50; end

if ischar(x), x = eval(x); end

if length(x) == 1
	help(mfilename)
	if nargin < 2, y = round(x/2); end
	if ischar(y), y = eval(y); end
	m = x;
	n = y;
	x = 1:n;
	y = 1:m;
	z = rand(m, n) - 0.5;
	z = cumsum(z.').';
	s = std(z);
	for j = 1:n
		i = isfinite(z(:, j));
		if any(i)
			scale = std(z(i, j));
			z(:, j) = z(:, j) ./ scale;
		end
	end
	set(gcf, 'Name', 'WiggleX Demo')
	wigglex(x, y, z, 'm')
	set(gca, 'YDir', 'reverse')
	axis tight
	xlabel('Column #'), ylabel('Row #')
	figure(gcf)
	return
end

if nargin == 1 | ischar(y)
	if nargin > 1, varargin{1} = y; end
	z = x;
	[m, n] = size(z);
	x = 1:n;
	y = 1:m;
end

x = x(:).';		% Row-vector.
y = y(:);		% Column-vector.

[m, n] = size(z);

for j = 1:n
	z(:, j) = z(:, j) + x(j);
end

result = plot(z, y, varargin{:});

if nargout > 0, theResult = result; end
