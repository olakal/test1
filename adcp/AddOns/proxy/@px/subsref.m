function theResult = subsref(self, theStruct)

% subsref -- Get a field value.
%  subsref(self, theStruct) returns the field value of
%   self, a "px" object, for "theResult = self.theField",
%   including fields of the associated "HandleGraphics"
%   entity, which take precedent.  The empty matrix []
%   is returned for fields that do not exist.  Use the
%   case-sensitive spelling 'UserData' for that field.
%   Self is a "px" object.


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

 
% Copyright (C) 1997 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 05-Apr-1997 09:57:00.

if nargin < 1, help(mfilename), return, end

theValue = [];

theSyntax = theStruct(1).type;
theField = theStruct(1).subs;

switch theSyntax
case '.'
   theValue = pxget(self, theField);
case '()'
   if strcmp(theField, ':')
      theValue = get(px(self), 'UserData');
   end
otherwise
   warning([' ## The "' theSyntax '" syntax is' ...
           ' not available to "px" objects.'])
   help(mfilename)
end

if nargout > 0
   theResult = theValue;
else
   disp(theValue)
end
