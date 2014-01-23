function[zz,XX,YY,background,lon_ext,lat_ext,data_ext] = domain_eval(data,indices)
% the function evaluate the size of interpolation domain (a rectangular
% domain, i.e., a m-by-n matrix where all samples are enclosed). The
% function evaluate also the sub-domains relevant to any of the N sample 
% categories, and returns these as N m-by-n matrices (SSS) used to build
% interpolation domain based on the choice of selected sample categories.
% Each SSS matrix may contain a different number of NaN's depending on the
% effective distribution of a specific category of samples within the
% general domain stored into OD. 
%==========================================================================
lon = data(indices,2);                           % extract longitude and 
lat = data(indices,1);                           % latitude of the activated
                                                 % domain. 
[~,N] = size(data);                              % Get the number of variables.
lon_ext = cell(1,N-2);                           % Initialize cell structure of matrices (each cell is a variable)
lat_ext = cell(1,N-2);
data_ext = cell(1,N-2);
zz = cell(1,N-2);           
XX = cell(1,N-2); 
YY = cell(1,N-2);
background = cell(1,N-2); 

 %==========================%
 % check for sparse datasets
 %==========================%

data_slctd = data(indices,:);
lon_slctd = lon;
lat_slctd = lat;
count = 0;

while count == 0
    
    latmax = max(data_slctd(:,1));
    latmin = min(data_slctd(:,1));
    lonmax = max(data_slctd(:,2));
    lonmin = min(data_slctd(:,2));
    position_xmin = find(data_slctd(:,2) == lonmin);
    position_xmax = find(data_slctd(:,2) == lonmax);
    position_ymin = find(data_slctd(:,1) == latmin);
    position_ymax = find(data_slctd(:,1) == latmax);
    
    % check existence of variable value at each points
    valid = isfinite(data_slctd(:,3:N));         
    
    if sum(valid(position_xmin,:)) < N-2             
        data_slctd(position_xmin,:) = [];
        lon_slctd(position_xmin) = [];
        count = 0;
    elseif sum(valid(position_xmax,:)) < N-2
        data_slctd(position_xmax,:) = [];
        lon_slctd(position_xmax) = [];
        count = 0;
    elseif sum(valid(position_ymin,:)) < N-2
        data_slctd(position_ymin,:) = [];
        lat_slctd(position_ymin) = [];
        count = 0;
    elseif sum(valid(position_ymax,:)) < N-2
        data_slctd(position_ymax,:) = [];
        lat_slctd(position_ymax) = [];
        count = 0;
    else
        count = 1;
    end
end

 %========================%
 % create the interpolants
 %========================%
 
 lon_slctd_max = max(lon_slctd);
 lon_slctd_min = min(lon_slctd);
 lat_slctd_max = max(lat_slctd);
 lat_slctd_min = min(lat_slctd);

 if lon_slctd_max-lon_slctd_min > 50 && lat_slctd_max-lat_slctd_min > 17
     precision = 0;
 elseif lon_slctd_max-lon_slctd_min > 10 && lat_slctd_max-lat_slctd_min > 3.4
     precision = 1;
 else
     precision = 2;
 end
 
for i = 1 : N-2
    lon_ext(i) = {lon_slctd(valid(:,i) == 1)};
    lat_ext(i) = {lat_slctd(valid(:,i) == 1)};
    data_ext(i) = {data_slctd((valid(:,i) == 1),i+2)};
    [z_variable,X,Y] = data_int(lon_ext(i),lat_ext(i),data_ext(i),precision);  
    background_val = min(min(z_variable));
    if background_val > 0
        background(i) = {0};
    else
        background(i) = {0.1*background_val+background_val};
    end
    zz(i) = {z_variable};                        % these matrices are the same size, but
    YY(i) = {Y};                                 % may contain different amount of NaN's 
    XX(i) = {X};                                 
end
end