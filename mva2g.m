% mva2g: a Matlab-derived code to perform multivariate spatial analysis of 
% scattered geological data,
% change name to: sybil!!
%
% code version: 3.1 (2013)
% programmer: L. Casini 
% contact: casini@uniss.it
% institution: University of Sassari (2013)
% developers: L. Casini, S. Cuccuru, A. Puccini, G. Oggiano
%--------------------------------------------------------------------------                
% Output results: 
% mva2g allow to display several plots based on user-defined data 
% 
%--------------------------------------------------------------------------
% components:
% mva2g.m - mainscript, read data from external files and controls the
%           sub-functions
% get_category.m, subdivide the data into N subsets based on the label 
%                 specified in the field 'rock type' (see the excel file 
%                 sample.xls). For each subset the function stores the 
%                 subset name in cell array categories = [1 x N], 
%                 the indices of elements within each subset in a cell 
%                 array categories_size = [1 x N], and the number of 
%                 subsets in a cat_num scalar = [1 x 1] 
% ras2vec.m, binarize custom jpeg image (reference framework for spatial 
%            analysis of data)
% ras2vec1.m, binarize default topography and extract the standard
%             reference framework 
% freqdist1.m, calculate the frequency distribution of selected data
% data_int.m, interpolate scattered data over the spatial domain as
%             defined by the size (m-by-n) of the reference image
% filt_1.m, analyze distribution of data (find mixed clusters within
%           selected data)
% slct.m, open input dialogs allowing the user to specify the data type to 
%         be plotted and marker style and color.
% unslct.m, open input dialogs allowing the user to delete one or more data
%           sets appended to the current plot. 
% get_slct_data.m, returns a row vector of indices to selected data
% graph_1d.m, plot the raw dataset and the results of statistical analysis 
%             performed by filt_1.m
% graph_2d.m, plotting commands for 2D contour maps
% graph_3d.m, plotting commands for 3D plots
% world.jpg, reference image of continents (high resolution) used to
%            get a spatial framework where to plot data. Note that users  
%            may obtain higher resolution maps by loading custom topography
%            as  m-by-n pixels filename.jpeg images. Custom images must be
%            sized so that the four edges of the image (from lower left to 
%            upper left) match minimum lat/minimum lon, minimum lat/
%            maximum lon, maximum lat/maximum lon, maximum lat/minimum lon,
%            all coordinates set in decimal 
% world_low.jpg, reference image of continents (low resolution)
% world_prev.jpg, reference image of continents (very low resolution)
% template.xls, pre-formatted xcel (97-2003) template storing the data
%               to be evaluated and displayed (to be saved as 'your file
%               name.xls in the SYBIL folder)
% colormod.mat (and similar), Matlab database for principal component plots
%==========================================================================
close all
clear all

% load inputs--------------------------------------------------------------

 msgbox({'mva2g - A Matlab-derived package that allow';...
     'to multivariate spatial analyst and extract';...
     'the Principal Pomponents from larger system';...
     'composed of up to 15 independent variables '},...
     'Launching mva2g..','help');
 pause(1);
                    
 h1_m = msgbox({'Store data into data.xls spreadsheet before';...
     'going on with mva2g. Maximum allowance is  ';...
     '1000 observations (samples) organized in   ';...
     'columns, and 15 components (user-defined v-';...
     '-ariables) organized in rows. Start filling';...
     'from sheet1. Sparse datasets are allowed,  ';...
     'however you should keep your datasets as   ';...
     'consistent as possible in order to obtain  ';...
     'meaningful information'},...
     'Launching mva2g..','help','modal');
 pause(7);

[data,label,num] = data_read;
all = numel(label);                         % get the total number of 
                                            % observations
data = data';                               % transpose original matrix to 
                                            % fit mva design
if numel(data(:,1)) >= 7                    % user selected a valid dataset
    [m,N] = size(data);     
    i = 3;
    us_dat_name = cell(1,N-2);
    
    while i <= N
        us_dat_name(i-2) = inputdlg(['Enter name of variable var.',...
        num2str(i-2),' in data.xls spreadheet']);
        i = i+1;
    end
                
    [categories,categories_size,cat_num] = get_category(label);
    
    %--------------------------------------------%
    % SELECT SAMPLES AND VARIABLES TO BE ANALYZED
    %--------------------------------------------%
    
    var_ind = slct_var(us_dat_name);
    sdata = slct_sam(categories,cat_num);
    ind = get_slct_data(sdata,categories,label);
    indices = ind';
    indices = cell2mat(indices);
    
    %-------------------------------------%
    % Compute variance of single variables
    %-------------------------------------%
    
    freq_data = data(indices,var_ind);
    valid = isfinite(freq_data);            % check sparse dataset
    freq_data = cell(1,numel(var_ind));
    sdata_number = zeros(1,numel(var_ind)); % number of samples for 
                                            % each variable
    
    for i = 1 : numel(var_ind)
        freq_data(:,i) = {data(indices(valid(:,i) == 1),var_ind(i))}; 
        sdata_number(i) = numel(nonzeros(cell2mat(freq_data(:,i))));
    end 
    
    [classes,density] = freqdist1(freq_data,sdata_number); 
 
    [~,cluster_size,med,std_dev] = filt_1(freq_data); 

    % display results of 1d plots------------------------------------------

    color_palette = {'w','k',[0.5 0.5 0.5],'b','c','r',...
        [0.98 0.51 0.17],'y','g'};

    % optionally plot figure#1 (cluster analysis)
    
    figure(1)
   
    graph_1d(var_ind,us_dat_name,med,std_dev,cluster_size,classes,...
        density,sdata_number,all); 
  
    % REFERENCING SAMPLES TO GEOGRAPHIC COORDINATES------------------------
    %=========================%
    % localize selected samples
    %=========================%
    
    lon = data(indices,2);                   % extract sample coordinates
    lat = data(indices,1);                   % extract sample coordinates
    
    %==========================%
    % load geographic reference
    %==========================%
    
    image_name = inputdlg('Enter file name: ','Load map framework',1,{'default'});
    image_name = char(image_name);
      
    if strcmp(image_name,'default') == 1 
        image_name = 'default';
        h1 = warndlg({'No map selected! Data will be displayed  ';...
            'in the default geographic reference framework.    ';...
            'Use a custom map to improve final resolution (see ';...
            'the section 2.2 in the help menu for instructions)'});
        pause(2);
    else 

    end
    
    % INTERPOLATING ALL VARIABLES OVER THE DOMAIN OF INTEREST--------------
    % here the code interpolates all variables over the spatial domain of
    % interest (interpolation involves selected samples only!)  
    %===========================%
    % initialize cell structures
    %===========================%
    
    lon_ext = cell(1,N-2);                   % initialize extracted 
                                             % longitudes, latitudes and 
                                             % z values (each cell is a 
                                             % variable)
    lat_ext = cell(1,N-2);
    data_ext = cell(1,N-2);
    zz = cell(1,N-2);                        % initialize extrapolated z 
                                             % values, X and Y coordinates
                                             % (each cell is a variable)
                                             % as well as background value
                                             % for oceans 
    XX = cell(1,N-2); 
    YY = cell(1,N-2);
    background = cell(1,N-2);              
    coastline = cell(1,N-2);
    %==========================%
    % check for sparse datasets
    %==========================%
    
    valid = isfinite(data(indices,3:N));
    
    for i = 1 : N-2
        lon_ext(i) = {lon(valid(:,i) == 1)};
        lat_ext(i) = {lat(valid(:,i) == 1)};
        data_ext(i) = {data(indices(valid(:,i) == 1),i+2)};
        [z_variable,X,Y] = data_int(lon_ext(i),lat_ext(i),data_ext(i));  
        
        background_val = min(min(z_variable));
        
        if background_val > 0
            coastline(i) = {background_val*0.1};
            background(i) = {0};
        else
            coastline(i) = {0.1*background_val};
            background(i) = {0.1*background_val+background_val};
        end
        
        zz(i) = {z_variable};         % these matrices may contain NaN's 
        YY(i) = {Y};                  % both in lands and seas
        XX(i) = {X};
    end
    
    domain_extrapolated = cell2mat(zz(1));
    
    [q,w] = size(domain_extrapolated);
    zz_ind = zeros(q,w);
    
    for j = 1:q*w
        if isnan(domain_extrapolated(j)) == 0
                zz_ind(j) = 1;
        else
        end
    end
   
    x_grid = cell2mat(XX(1));
    y_grid = cell2mat(YY(1));
    [p,k] = size(x_grid);
    [sea,coast,data_points] = im2vec(y_grid,x_grid,image_name,zz_ind); 
    
    data_points_land = cell(1,N-2);   % to be used in multivariate analysis 
    
    for i = 1 : N-2
        datum = flipud(cell2mat(zz(i)));
        datum(isnan(data_points) == 1) = nan;
        data_points_land(i) = {flipud(datum)};
    end
    
    data_points_land_plus_sea = cell(1,N-2);
    data_points_all = cell(1,N-2);
    
    for i = 1 : N-2
        color_background = cell2mat(background(i));
        datum = flipud(cell2mat(data_points_land(i))); 
        datum(isnan(sea) == 0) = color_background;
        data_points_land_plus_sea(i) = {flipud(datum)};
    end  
    for i = 1 : N-2
        color_coastline = cell2mat(coastline(i));
        datum = flipud(cell2mat(data_points_land_plus_sea(i))); 
        datum(isnan(coast) == 0) = color_coastline;
        data_points_all(i) = {flipud(datum)}; 
    end
   

    % MULTIVARIATE ANALYSIS------------------------------------------------
    % here the code call the function mva and do multivariate analysis (see
    % the help menu in mva.m to see how it works)
     
    [COEFF,latent,explained,component_name,PC_scores] = mva(data_points_land,us_dat_name);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DISPLAY THE RESULTS
    % here the code display the results as 2/3d plots of interpolated
    % surfaces, either single variables and the results of PCA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if isempty(cell2mat(component_name)) == 1
        answer1 = questdlg('Plot the results as 2/3D maps','Option menu',...
            'Single Variable Intensity','no!','no!');
        switch answer1
            case 'Single Variable Intensity'
                s1 = 1;
            case 'no!'
                s1 = -1;
        end
    else
        answer1 = questdlg('Plot the results as 2/3D maps','Option menu',...
            'Single Variable Intensity','PCA','no!','no!');
        switch answer1
            case 'Single Variable Intensity'
                s1 = 1;
            case 'PCA'
                s1 = 0;
            case 'no!'
                s1 = -1;
        end
    end
    
    if s1 == 1 || s1 == 0
        str1 = {'2d','3d'};
        str3 = {'mountain','lights','magma','ice','moon','grayscale','sharp1','sharp2','binary'};
        plot_mode = listdlg('PromptString','Select plot type: ',...
            'SelectionMode','single','ListSize',[120 60],...
            'ListString',str1);
        plot_mode = str1(plot_mode);
        col_scale = listdlg('PromptString','Set color scale: ',...
            'SelectionMode','Single','ListSize',[120 180],...
            'ListString',str3);
        figure(2)
        
        if col_scale == 1
            load('mountain','mountain')
            set(gcf,'Colormap',mountain);
        elseif col_scale == 2
            load('lights','lights');
            set(gcf,'Colormap',lights);
        elseif col_scale == 3
            load('magma','magma');
            set(gcf,'Colormap',magma);
        elseif col_scale == 4
            load('ice','ice');
            set(gcf,'Colormap',ice);
        elseif col_scale == 5
            load('moon','moon');
            set(gcf,'Colormap',moon);
        elseif col_scale == 6
            load('grayscale','grayscale');
            set(gcf,'Colormap',grayscale);
        elseif col_scale == 7
            load('sharp1','sharp1');
            set(gcf,'Colormap',sharp1);
        elseif col_scale == 8
            load('sharp2','sharp2');
            set(gcf,'Colormap',sharp2);
        else
            load('binary','binary')
            set(gcf,'Colormap',binary);
        end
        
        if s1 == 1                                    % single variable plot
            str2 = us_dat_name(var_ind-2);
            string_length = numel(us_dat_name);
            int_data = listdlg('PromptString','Select data set: ',...
                'SelectionMode','single','ListSize',[120 68+string_length*8],...
                'ListString',str2);
            data_name = str2(int_data);
            graphic_variables(x_grid,y_grid,data_points_all,...
                data_points_land,data_name,lon_ext,lat_ext,...
                data_ext,int_data,coastline,col_scale,coast,plot_mode)
        else                                          % PCA plot
            str2 = component_name;
            string_length = numel(component_name);
            int_data = listdlg('PromptString','Select data set: ',...
                'SelectionMode','single','ListSize',[120 68+string_*8],...
                'ListString',str2);
            data_name = str2(int_data);
        
            graphic_PCA(x_grid,y_grid,PC_scores,data_name,int_data,...
                coastline,col_scale,coast,plot_mode)
        end
   else
       h4 = warndlg({'You selected no plot!'});
   end

else
    h3 = warndlg({'A minimum of 7 samples is required',...
                  'Please, improve your dataset before',...
                  'launching again mva2g'});
    pause(2);
    delete(h3);
end
% end of script
% end of code execution----------------------------------------------------
%==========================================================================



































