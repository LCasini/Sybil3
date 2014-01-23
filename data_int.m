function [z_variable,X,Y] = data_int(lon,lat,int_data,precision) 
% The function interpolate a dataset of spatially scattered data over a
% rectangular domain defined by 4 vertices of coordinates
% (lonmin,latmin), (lonmax,latmin), (lonmin,latmax) and (lonmax,latmax).
% The coordinates of vertices are passed as function input arguments and
% must be set decimal degrees. 
% The function returns outputs that define the natural interpolation of 
% data over the domain of interest.
%==========================================================================

if iscell(lon) == 1
    lon = cell2mat(lon);                        % column vector
else
end
if iscell(lat) == 1
    lat = cell2mat(lat);                        % column vector
else
end
if iscell(int_data) == 1
    int_data = cell2mat(int_data);              % column vector
else
end
[m,n] = size(lat);                 % reshape data stored into m-by-n matrix 
lon_res = reshape(lon,m*n,1);
lat_res = reshape(lat,m*n,1);
lonmax = max(lon_res);
lonmin = min(lon_res);
latmax = max(lat_res);
latmin = min(lat_res);
int_data_res = reshape(int_data,m*n,1);

%----------------------------------%
% ROUND SAMPLE POSITION COORDINATES
%----------------------------------%
% here the data_int function converts real sample coordinates to 
% approximate position, the multiplication factor allow to 0, 0.1 and 0.01 
% decimal degree precision (roughly 113, 11,3 and 1.3 km accuracy, respectively)
% depending on the size of the interpolation domain

if precision == 0
    conv_factor = 1;
elseif precision == 1
    conv_factor = 10;
else
    conv_factor = 1000;
end

lon100_min = fix(lonmin*conv_factor);               
lon100_max = fix(lonmax*conv_factor);               
lat100_min = fix(latmin*conv_factor);
lat100_max = fix(latmax*conv_factor);
x_size = (lon100_max-lon100_min)+1;
y_size = (lat100_max-lat100_min)+1;

%--------------------------------------------------------------------------
% interpolate scattered data using linear interpolation 

xlin = (linspace(lon100_min,lon100_max,x_size))/conv_factor;
ylin = (linspace(lat100_min,lat100_max,y_size))/conv_factor;

app_variable = TriScatteredInterp(lon_res,lat_res,int_data_res,'natural');
[X,Y] = meshgrid(xlin,ylin);
z_variable = app_variable(X,Y);
end