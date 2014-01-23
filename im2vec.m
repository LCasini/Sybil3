function [sea,coast,data_points] = im2vec(lat,lon,img,zz_ind)
% the function vectorize the reference geographic framework, extracting the
% coast line, lands and the seas
%
% programmer: Leonardo Casini 
% Institution: University of Sassari (2013)
% contact: casini@uniss.it
%==========================================================================
if iscell(lon) == 1                % check if data are stored into cell
    lon = cell2mat(lon);           % structure, and eventually unpack cell 
else
end
if iscell(lat) == 1                % check if data are stored into cell     
    lat = cell2mat(lat);           % structure, and eventually unpack cell 
else
end

[m,n] = size(lat);                 % reshape data stored into m-by-n matrix 
lon_res = reshape(lon,m*n,1);      % and eventually convert it into column
lat_res = reshape(lat,m*n,1);      % vector

%---------------------------------%
% find coordinates of image edges
%---------------------------------%
lonmax = max(lon_res);
lonmin = min(lon_res);
latmax = max(lat_res);
latmin = min(lat_res);

%----------------%
% load topography
%----------------%
if lonmax-lonmin > 50 && latmax-latmin > 17
    I = imread('world_prev.jpg');
    check_image_existence = 1;
elseif lonmax-lonmin > 10 && latmax-latmin > 3.4
    I = imread('world_low.jpg');
    check_image_existence = 1;
else 
    warndlg({'Samples are too close; load a custom image to ';...
        'display the results in the appropriate geographic';...
        'reference frame. Have a look at the help menu to ';...
        'know how to do this.'});
        I = imread('geography.jpg');
        check_image_existence = 0;
end

if strcmp(img,'default') == 1 && check_image_existence == 1
    I_gray = rgb2gray(I);
    [m n] = size(I_gray);
    %----------------------------------------------------------------------
    % make topography and data match if no custom topography is selected
    %----------------------------------------------------------------------
    % i) construct coordinate matrix from raster image
    lon_x = linspace(-180,180,n);
    lat_y = linspace(-66.5,66.5,m);
    LAT = repmat(flipud(lat_y'),1,n);
    
    % ii) crop topography to match the actual sample distribution
    mat_lon = find(lon_x >= lonmin & lon_x <= lonmax);    % column indices
    mat_lat = find(LAT(:,1) >= latmin & LAT(:,1)...       % row indices
        <= latmax); 
    ind1 = numel(mat_lon);
    ind2 = numel(mat_lat);
    map = I_gray(mat_lat(1:ind2),mat_lon(1:ind1));               
    
    % iii) evaluate the size of cropped image
    [p q] = size(map);
    
    % iv) reshape image in order to make both the matrix that stores a 
    % raster reference image and the matrix of extrapolated data the same 
    % size 
    [r,s] = size(lon);
    dim1 = p/r;                             % y_direction axis ratio
    dim2 = q/s;                             % x_direction axis ratio
    if (dim1-dim2)^2 < 0.1                  % matrix are not distorted or 
        map_reshape = imresize(map,[r,s]);  % acceptably distorpted
    else 
        map_reshape = map;
    end
    
    map_reshaped = nan(r,s);
    map_reshaped(flipud(zz_ind) == 1) = map_reshape(flipud(zz_ind) == 1);
    
    sea = nan(r,s);
    coast = nan(r,s);
    data_points= nan(r,s);
    
    for i = 1:r*s                            % loop column-wise  
            if map_reshaped(i) < 100
                coast(i) = 1;
                data_points(i) = 1;             
            elseif map_reshaped(i) >=  250   % create fictious seas points
                sea(i) = 1;
            else
                data_points(i) = 1;          % land points of extrapolated
            end                              % samples
    end           
else
    if isempty(I) == 0
        map = rgb2gray(I);
        
        % i) construct coordinate matrix from raster image
        [r,s] = size(lon);
        map_reshape = imresize(map,[r,s]);  % acceptably distorpted
        map_reshaped = nan(r,s);
        map_reshaped(flipud(zz_ind) == 1) = map_reshape(flipud(zz_ind) == 1);
        sea = nan(r,s);
        coast = nan(r,s);
        data_points= nan(r,s);
    
        for i = 1:r*s                        % loop column-wise  
            if map_reshaped(i) < 100
                coast(i) = 1;
                data_points(i) = 1;
            elseif map_reshaped(i) >=  250   % create fictious seas points
                sea(i) = 1;
            else
                data_points(i) = 1;          % land points of extrapolated
            end                              % samples
        end 
    end
end 
end