function ct2nc(ss,tvari,matname,varargin)
% A function to convert a matlab workspace into a netcdf file. This example
% is for CT data but could be modified to velocity data
%
% INPUT:
% 	ss - a cell array that lists the names of all variables, except the
% 		time variable, that will be saved into the new netcdf file. Strings
% 		may be case-sensitive depending on platform. an example of ss reads like
% 			ss={'velU','velV','temperature'}
% 	tvari - the name of the timebase variable in the workspace. The unit of the
% 		timebase must be in true julian days
% 	matname - the name of the matlab file containing all the variables
% 	cdfname - optional, a string designates the netcdf file name
% 
% OUTPUT:
% 	none
% 	
% NOTES: The timebase and all variables listed in ss will be loaded into the
% 	workspace first. So it may take a few seconds...
 
% csullivan, 09/21/04 I am editing the code mat2netcdf.m to work
%                     specifically with CT data
% csullivan, 10/19/04 I change the name of this code to ct2nc.m.  It was
%                     formerly ct2netcdf.m.  

if nargin<1
	help(mfilename)
	return;
end;

if ~ischar(matname)
   error(['File name input needs to be a string']);
end;
if nargin<4

   [s1,s2,s3]=fileparts(matname);
	cdfname=[s2 '.nc'];
else
   cdfname=varargin{1};
   if ~ischar(cdfname)
      error(['File name input needs to be a string']);
   end;
end;

for i=1:length(ss),load(matname,ss{i});end;
load(matname,tvari);
gattname={'DataOrigin','Mooring','Description','Latitude','Longitude',...
      'MagneticVariation','WaterDepth','CreationDate','DataType','CoordSystem'};
def={'USGS','No.xxx','csullivan adjusted CT data',num2str(lat),num2str(lon),...
      '0.0',[num2str(depth),' M'],'today''s date','Time Series','Geographical'};
tit='Global Attribute';
lineno=1;
gatt=inputdlg(gattname,tit,lineno,def);

vattname={'name','units','epic_code'};
ss=sort(ss);
for i=1:length(ss)
	def={ss{i},' ','-999'};
   tit=['Attributes for <' ss{i} '>'];
   vari(i).att=inputdlg(vattname,tit,lineno,def);
end;
eval(['time=' tvari ';']);
mytime=floor(time);
mytime2=(time-mytime)*86400000;
limits=length(mytime);

cdf=netcdf(cdfname,'clobber');
for i=1:length(gatt)

   eval(['cdf.' gattname{i} '=ncchar(gatt{i});']);
end;


cdf('time')=0;
cdf{'time'}=ncdouble('time');

cdf{'time'}.name='epic time';

cdf{'time'}.units='true julian day';

cdf{'time'}.epic_code=624;

cdf{'time2'}=ncdouble('time');

cdf{'time2'}.name='epic time2';

cdf{'time2'}.units='milliseconds';

cdf{'time2'}.epic_code=624;

for i=1:length(ss)
	eval(['myarray=' ss{i} ';']);
	[m,n]=size(myarray);
	if m<n
		myarray=myarray';
		[m,n]=size(myarray);
   end;

   cols{i}=['cols' num2str(n)];

   if m<limits

      rows{i}=['rows' num2str(m)];

   end;

   if n>1

   	cdf(cols{i})=n;

      cdf{ss{i}}=ncfloat('time',cols{i});

      if m<limits

         cdf{ss{i}}=ncfloat(rows{i},cols{i}); 

      end;

   else

      cdf{ss{i}}=ncfloat('time');

      if m<limits

         cdf{ss{i}}=ncfloat(rows{i}); 

      end;

   end;

   for j=1:length(vattname)

      eval(['cdf{ss{i}}.' vattname{j} '=vari(i).att{j} ;']);
   end;
end;

cdf{'time'}(1:limits,1)=mytime;

cdf{'time2'}(1:limits,1)=mytime2;

for i=1:length(ss)
	eval(['myarray=' ss{i} ';']);
	[m,n]=size(myarray);
   cdf{ss{i}}(1:m,1:n)=myarray;

end;

fprintf('\nCompleted...\n');

close(cdf);

return;


