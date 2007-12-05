function [taux,tauy,u10,v10]=wstress(u,v,z0)
% WSTRESS  computes wind stress using the Large and Pond (JPO, 1981) formulation.
%
%  USAGE: [taux,tauy,u10,v10]=wstress(u,v,z0)
%
%       u,v = eastward, northward components of wind in m/s
%       z0  = height of wind sensor in m (assumed to be 10 m if not supplied)
%     
%       taux,tauy = eastward, northward wind stress components (dynes/cm2)
%       u10,v10   = equivalent wind velocity components at 10 m.
%


%%% START USGS BOILERPLATE -------------% Program written in Matlab v6x
% Program works in Matlab v7.1.0 SP3
% Program updated in Matlab 7.2.0.232 (R2006a)
% Program ran on PC with Windows XP Professional OS.
% program ran on Redhat Enterprise Linux 4
%
% "Although this program has been used by the USGS, no warranty, 
% expressed or implied, is made by the USGS or the United States 
% Government as to the accuracy and functioning of the program 
% and related program material nor shall the fact of distribution 
% constitute any such warranty, and no responsibility is assumed 
% by the USGS in connection therewith."
%%% END USGS BOILERPLATE --------------

 
% Rich Signell  rsignell@usgs.gov
%
if(nargin==2),
 z0=10.;
end;
%
nans=ones(length(u),1)*nan;
u10=nans; 
v10=nans;
taux=nans;
tauy=nans;
%
% identify times of zero wind.  These indices will be set to zero stress.
izeros=find((abs(u)+abs(v))==0);
igood=find(finite(u)& ((abs(u)+abs(v))>0));

u=u(igood);
v=v(igood);
u=u(:);
v=v(:);
w=u+i*v;
v0=abs(w);
k=.41;
rho=1.25e-3;
a1=1/k*log(z0/10.);
d1=1.e35*ones(size(u));
c=zeros(size(u));
while (max(abs(c-d1))>.01),
  c=d1;
  cd=ones(size(u))*1.205e-3;
  ind=find(c>11);
  if(~isempty(ind))
   cd(ind)=(0.49 + 0.065*c(ind))*1.e-3;
  end
  d1=v0./(1+a1.*sqrt(cd));
end
t=(rho*cd.*d1*1.e4)./(1+a1.*sqrt(cd));
w10=(d1./v0).*w;
u10(igood)=real(w10);
v10(igood)=imag(w10);
taux(igood)=t.*u10(igood);
tauy(igood)=t.*v10(igood);
% set zero wind periods to zero stress (and U10,V10)
u10(izeros)=zeros(size(izeros));
v10(izeros)=zeros(size(izeros));
taux(izeros)=zeros(size(izeros));
tauy(izeros)=zeros(size(izeros));