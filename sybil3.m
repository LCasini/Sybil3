function sybil3
% SYBIL: a Matlab-derived code to perform multivariate spatial analysis of 
% scattered geological, geophysical and environmental data.
%
% code version: 3.0 (2013)
% programmer: L. Casini 
% contact: casini@uniss.it
% institution: University of Sassari (2013)
% developers: L. Casini, S. Cuccuru, A. Puccini, G. Oggiano
%--------------------------------------------------------------------------                
% Output results: 
% sybil3 allow to display several plots based on user-defined data 
%
% software components:
%% MAINSCRIPT
% sybil3.m - mainscript, initialize the GUI, read data from external files 
%            and controls the sub-functions
%% SUB-ROUTINES
%
% data_read1.m, load data from xls file (keep the xls file in the same
%              folder 'Sybil3' 
% get_category.m, subdivide the data into N subsets based on the label 
%                 specified in the field 'rock type' (see the excel file 
%                 sample.xls). For each subset the function stores the 
%                 subset name in cell array categories = [1 x N], 
%                 the indices of elements within each subset in a cell 
%                 array categories_size = [1 x N], and the number of 
%                 subsets in a cat_num scalar = [1 x 1] 
% get_slct_data.m, returns a row vector of indices to selected data
% freqdist1.m, calculate the frequency distribution of selected data
% filt_1.m, analyze distribution of data (find mixed clusters within
%           selected data)
% domain_eval.m, crop differently sized variable domains
%%-call2subfunction-% data_int.m, interpolate scattered data over the spatial 
%                           domain as defined by the size (m-by-n) of the 
%                           reference image
% im2vec.m, binarize custom jpeg image (reference framework for spatial 
%            analysis of data)
% mva.m, function used to perform multivariate analysis (calculation of
%        coefficient matrix, eigenvectors, extraction of Principal
%        Components)
% graph1.m, plot the raw dataset and the results of statistical analysis 
%           performed by filt_1.m
% graph2a.m, plotting commands for 2D/3D maps of single variable
%            and PCA interpolation
% data_export.m, export data of principal component analysis as excel table
%
%% OTHER COMPONENTS
%
% world_low.jpg, reference image of continents (default)
% world_prev.jpg, reference image of continents (default, low resolution)
% dataset.xls, pre-formatted xcel (97-2003) template storing the data
%               to be evaluated and displayed (to be saved as 'your file
%               name.xls in the SYBIL folder)
% mountain.mat (and similar files..), Matlab database for colormaps
% read_me.pdf, help file and instructions
%==========================================================================
 
clear all

%--------------------------------------------------------------------------
% INITIALIZE THE GUI
%--------------------------------------------------------------------------
   %  Create and then hide the GUI as it is being constructed.
   
   f = figure('Visible','off','Position',[1100,600,1100,600],'Resize','off');
 
   %  Construct the GUI components.
   
   frame1 = uipanel('Position',[0.004,0.016,0.308,0.75]);
 
   frame2 = uipanel('Title','Data management',...
       'Position',[0.007,0.505,0.205,0.248],'FontSize',7);
   
   frame3 = uipanel('Title','Statistics',...
       'Position',[0.212,0.505,0.095,0.247],'FontSize',7);
   
   frame4 = uipanel('Position',[0.312,0.016,0.685,0.97]);
   
   frame5 = uipanel('Title','Plot management',...
       'Position',[0.316,0.888,0.677,0.085],'FontSize',7);
   
   frame8 = uipanel('Title','Select sample(s): ',...
       'Position',[0.093,0.626,0.110,0.108],'FontSize',7);
   
   frame9 = uipanel('Title','Select variable(s): ',...
       'Position',[0.093,0.512,0.110,0.108],'FontSize',7);
   
   frame10 = uipanel('Title','Clustering',...
       'Position',[0.22,0.656,0.08,0.078],'FontSize',7);
   
   frame11 = uipanel('Title','Spatial Analysis',...
       'Position',[0.22,0.512,0.08,0.136],'FontSize',7);
   
   frame12 = uipanel('Title','Select data',...
       'Position',[0.320,0.894,0.129,0.06],'FontSize',7);
   
   frame13 = uipanel('Title','Set plot type',...
       'Position',[0.450,0.894,0.230,0.06],'FontSize',7);
   
   frame14 = uipanel('Title','Plot controls',...
       'Position',[0.681,0.894,0.307,0.06],'FontSize',7);
   
   frame15 = uipanel('Title','Plot management',...
       'Position',[0.007,0.416,0.3,0.085],'FontSize',7);
   
   frame16 = uipanel('Title','Select data',...
       'Position',[0.014,0.421,0.143,0.06],'FontSize',7);
   
   frame17 = uipanel('Title','Plot controls',...
       'Position',[0.157,0.421,0.143,0.06],'FontSize',7);
   
   htext = uicontrol('Style','text','String',...
       'Sybil 3.0 - A Matlab-derived software for statistical analysis of geo-referenced data. Have a look at the HELP! file before formatting your dataset',...
       'Position',[10,520,320,70],'HorizontalAlignment','left',...
       'BackgroundColor',[0.8,0.8,0.8]);
   
   htext1 = uicontrol('Style','text','String',...
       'Programmer: Leonardo Casini (casini@uniss.it)',...
       'Position',[10,516,240,20],'HorizontalAlignment','left',...
       'FontSize',7,'BackgroundColor',[0.8,0.8,0.8]);
   
   htext2 = uicontrol('Style','text','String',...
       'Institution: University of Sassari',...
       'Position',[10,504,240,20],'HorizontalAlignment','left',...
       'FontSize',7,'BackgroundColor',[0.8,0.8,0.8]);
   
   htext3 = uicontrol('Style','text','String',...
       'OS: Windows 7',...
       'Position',[10,492,240,20],'HorizontalAlignment','left',...
       'FontSize',7,'BackgroundColor',[0.8,0.8,0.8]);
   
   htext4 = uicontrol('Style','text','String',...
       'Matlab version: r2010a',...
       'Position',[10,480,240,20],'HorizontalAlignment','left',...
       'FontSize',7,'BackgroundColor',[0.8,0.8,0.8]);
      
   hload = uicontrol('Style','pushbutton','String','Load..',...
          'Position',[19,415,70,19],...
          'Callback',{@loadbutton_Callback});
      
   hcancel1 = uicontrol('Style','pushbutton','String','Cancel',...
          'Position',[19,396,70,19],...
          'Callback',{@cancelbutton1_Callback});
      
   hHELP1 = uicontrol('Style','pushbutton','String','HELP!',...
          'Position',[19,377,70,19],...
          'Callback',{@HELPbutton1_Callback});
   
   htext24 = uicontrol('Style','text','String',...
            ' ','Position',[110,419,109,9],'HorizontalAlignment','left',...
            'FontSize',7);
    
   htext25 = uicontrol('Style','text','String',...
            ' ','Position',[110,350,109,9],'HorizontalAlignment','left',...
            'FontSize',7);
   
   hpopup1 = uicontrol('Style','popupmenu',...
          'String','Initializing..',...
          'Position',[109,418,108,9],...
          'Callback',{@popup_menu_1_Callback},'FontSize',7);
   
   happend1 = uicontrol('Style','pushbutton','String','Append sample(s)',...
          'Position',[112,382,102,25],...
          'Callback',{@append1button_Callback},'FontSize',7);
      
   hpopup2 = uicontrol('Style','popupmenu',...
          'String',{'Initializing..'},...
          'Position',[109,350,108,9],...
          'Callback',{@popup_menu_2_Callback},'FontSize',7);
   
   happend2 = uicontrol('Style','pushbutton','String','Append variable(s)',...
          'Position',[112,313,102,25],...
          'Callback',{@append2button_Callback},'FontSize',7);
   
   hanalyze1 = uicontrol('Style','pushbutton','String','Analyze',...
          'Position',[259,410,56,17],...
          'Callback',{@analyze1button_Callback},'FontSize',7);
   
   hanalyze2 = uicontrol('Style','pushbutton','String','Analyze',...
          'Position',[259,358,56,17],...
          'Callback',{@analyze2button_Callback},'FontSize',7);
      
   hmva = uicontrol('Style','pushbutton','String','do MVA..',...
          'Position',[259,323,56,17],...
          'Callback',{@mvabutton_Callback},'FontSize',7);
   
   hpopup3 = uicontrol('Style','popupmenu',...
          'String','Initializing..',...
          'Position',[358,552,65,9],...
          'Callback',{@popup_menu_3_Callback},'FontSize',7);
   
   hpopup4 = uicontrol('Style','popupmenu',...
          'String','Initializing..',...
          'Position',[424,552,65,9],...
          'Callback',{@popup_menu_4_Callback},'FontSize',7);
   
   hplot1 = uicontrol('Style','pushbutton','String','Plot interpolation',...
          'Position',[850,541,100,21],...
          'Callback',{@plotbutton1_Callback},'FontSize',7);
   
   hcheck1 = uicontrol('Style','checkbox','Value',1,'String',...
       'Display samples','Position',[645,541,92,21],...
       'Callback',{@checkbutton1_Callback},'FontSize',7);
   
   visualization_mode = {'2d','3d'};
   
   hpopup5 = uicontrol('Style','popupmenu',...
          'String',visualization_mode,...
          'Position',[500,552,65,9],...
          'Callback',{@popup_menu_5_Callback},'FontSize',7);
   
   plot_type = {'Initializing..'};
   
   hpopup6 = uicontrol('Style','popupmenu',...
          'String',plot_type,...
          'Position',[566,552,65,9],...
          'Callback',{@popup_menu_6_Callback},'FontSize',7);
      
   hpopup7 = uicontrol('Style','popupmenu',...
          'String','Initializing..',...
          'Position',[755,552,95,9],...
          'Callback',{@popup_menu_7_Callback},'FontSize',7);
      
   hpopup8  = uicontrol('Style','popupmenu',...
          'String','Initializing...',...
          'Position',[22,269,72,9],...
          'Callback',{@popup_menu_8_Callback},'FontSize',7); 
      
   hplot2 = uicontrol('Style','pushbutton','String','Plot frequency',... 
          'Position',[94,258,74,21],...
          'Callback',{@plotbutton2_Callback},'FontSize',7);
      
   hcancel2 = uicontrol('Style','pushbutton','String','Clear graph',...
          'Position',[949,541,62,21],...
          'Callback',{@cancelbutton2_Callback},'FontSize',7);
      
   hcancel3 = uicontrol('Style','pushbutton','String','Clear graph',...
          'Position',[179,258,73,21],...
          'Callback',{@cancelbutton3_Callback},'FontSize',7);
      
   hexport = uicontrol('Style','pushbutton','String','Export figure',...
          'Position',[1010,541,72,21],...
          'Callback',{@exportbutton_Callback},'FontSize',7);
      
   hexport1 = uicontrol('Style','pushbutton','String','Export figure',...
       'Position',[251,258,73,21],...
       'Callback',{@exportbutton1_Callback},'FontSize',7);
      
   htext5 = uicontrol('Style','text','String',...
       'Workspace has:',...
       'Position',[13,340,90,20],'HorizontalAlignment','left',...
       'FontSize',7);
   
   htext6 = uicontrol('Style','text','String',... %%
       [num2str(0),' variable(s)'],...
       'Position',[17,320,70,20],'HorizontalAlignment','left',...
       'FontSize',7);
   
   htext7 = uicontrol('Style','text','String',...
       [num2str(0),' samples'],... %%
       'Position',[17,308,70,20],'HorizontalAlignment','left',...
       'FontSize',7);
   
   htext8 = uicontrol('Style','text','String',...
       'Report ','Position',[260 210 50 14],'HorizontalAlignment','left',...
       'FontSize',8,'FontWeight','bold');
   
   htext9 = uicontrol('Style','text','String',...
       'bulk dataset','Position',[260 190 75 12],'HorizontalAlignment','left',...
       'FontSize',8,'FontWeight','bold');
   
   str10 = 0;
   
   htext10 = uicontrol('Style','text','String',...
       ['mean: ',num2str(str10)],'Position',[262 176 55 10],'HorizontalAlignment','left',... 
       'FontSize',7);                        
   
   htext11 = uicontrol('Style','text','String',...
       ['median: ',num2str(str10)],'Position',[262 165 55 10],'HorizontalAlignment','left',...
       'FontSize',7);
   
   htext12 = uicontrol('Style','text','String',...
       ['std. dev.: ',num2str(str10)],'Position',[262 154 55 10],'HorizontalAlignment','left',...
       'FontSize',7);
   
   htext13 = uicontrol('Style','text','String',...
       'main cluster ','Position',[260 138 75 12],'HorizontalAlignment','left',...
       'FontSize',8,'FontWeight','bold');
   
   htext14 = uicontrol('Style','text','String',...
       ['population: ',num2str(str10)],'Position',[262 125 55 10],'HorizontalAlignment','left',...
       'FontSize',7);
   
   htext15 = uicontrol('Style','text','String',...
       ['median: ',num2str(str10)],'Position',[262 114 55 10],'HorizontalAlignment','left',...
       'FontSize',7);
   
   htext16 = uicontrol('Style','text','String',...
       ['std. dev.: ',num2str(str10)],'Position',[262 103 55 10],'HorizontalAlignment','left',...
       'FontSize',7);
   
   htext21 = uicontrol('Style','text','String',...
       ' ','Position',[260,397,50,9],'HorizontalAlignment','left',...
       'FontSize',7);
   
   htext22 = uicontrol('Style','text','String',...
       ' ','Position',[260,348,50,9],'HorizontalAlignment','left',...
       'FontSize',7);
   
   htext23 = uicontrol('Style','text','String',...
       ' ','Position',[260,310,50,9],'HorizontalAlignment','left',...
       'FontSize',7);
      
   h1 = axes('Units','Pixels','Position',[60,60,180,165]); 
   h2 = axes('Units','Pixels','Position',[410,60,600,450]);
   
   % Initialize the GUI.
   % Change units to normalized so components resize 
   % automatically.
   
   set([f,h1,h2,...
       hload,...
       hexport,hexport1,...
       hcancel1,hcancel2,hcancel3,...
       hplot1,hplot2,...
       hcheck1,...
       hHELP1,...
       htext,htext1,htext2,htext3,htext4,htext5,htext6,htext7,htext8,htext9,htext10,htext11,htext12,htext13,htext14,htext15,htext16,htext21,htext22,htext23,htext24,htext25,...
       hpopup1,hpopup2,hpopup3,hpopup4,hpopup5,hpopup6,hpopup7,hpopup8,...
       frame1,frame2,frame3,frame4,frame5,frame8,frame9,frame10,frame11,frame12,frame13,frame14,frame15,frame16,frame17,...
       happend1,happend2,...
       hanalyze1,hanalyze2,...
       hmva],...
       'Units','normalized');

   % initialize the GUI
   
   set(f,'Name','Syibil')
   
   % Move the GUI to the center of the screen.
   movegui(f,'center')
   
   % Make the GUI visible.
   set(f,'Visible','on');
   
   data = [];                % initialize matrix of data 
   label = {};               % initialize cell of sample labels
   all = 0;                  % initialize sample number 
   categories = {};          % categories of sample types    
   us_dat_name = {};         % categories of variables
   categories_updated = {};  % updated string for popupmenu1
   sdata = [];
   ind = [];
   var_ind = []; 
   selected_var = {};
   sdata_number = [];
   freq_data = {};
   COEFF = [];
   classes = [];
   density = [];
   cluster_size = {};
   med = {};
   std_dev = {};
   datalist = 'Initializing..';
   plot_type = 'Initializing..';
   samples_activated = 1;    % default setting display samples @ graph2
   indices = [];             % initialize indices to selected data
   selected_variable_1d = 0; % initialize variable to be shown in graph1
   selected_data_23d = 0;    % initialize index of dataset active in graph2
   data_points_land = {};    % initialize interpolated points, lands only
   data_points_all = {};     % initialize interpolated points, full domain
   z_variable_var = [];      % initialize data to be shown in graph2
   x_grid = [];
   y_grid = [];
   lon_ext = {};
   lat_ext = {};
   AVERAGE_VALUE = [];
   MEDIAN_VALUE = [];
   STD_VALUE = [];
   data_ext = {};
   variables_name = [];
   data_type = {};
   data_type_MVA = 0;
   data_type_slct = 1;
   data_23d_name = '';
   component_name = {};
   coastline = {};
   coast_points = {};
   coast = [];
   col_scale = 1;            % initialize colormap of graph2 to 'mountain'
   visualization = 1;        % initialize plot mode of graph2 to 2d
   PC_scores = {};
   colorF3 = struct('field1',{});
   string_colors = {'mountain','lights','magma','ice',...
       'moon','grayscale','sharp1','sharp2','binary','sharp3','sharp4','natural','binary1','binary2'};
   data_type = {};
   check_1D_results = 0;
   
    function loadbutton_Callback(~,~)
        [data,label,all,filename] = data_read1;
        label = label'; 
        [mm,n] = size(data);
        VARimat = isfinite(data(:,3:n));
        VARimat = sum(VARimat);                   
        VARcheck = zeros(1,n-2);
        
        for i = 1 : n-2
            if VARimat(i) >= 12  % select datatasets larger than 12 samples
                VARcheck(i) = 1;
            end
        end
                
        if sum(VARcheck) > 0                     
            [categories,~,~] = get_category(label);
            [~,us_dat_name] = xlsread([num2str(filename),'.xls'],1,'E5:BB6');
            variables_name = us_dat_name;
        end  
        categories_updated = categories;
        set(hpopup1,'String',categories);
        htext6 = uicontrol('Style','text','String',...
            [num2str(numel(variables_name)),' variable(s)'],...
            'Position',[17,321,70,20],'HorizontalAlignment','left',...
            'FontSize',7);
        htext7 = uicontrol('Style','text','String',...
            [num2str(mm),' samples'],...
            'Position',[17,308,70,20],'HorizontalAlignment','left',...
            'FontSize',7);
       
    end

    function popup_menu_1_Callback(source,~)
        % determine the selected sample categories
        str = get(source,'String');
        val = get(source,'Value');
        switch str{val};
            case cellstr(categories(val));
                sdata(val) = val;
                categories_updated(val) = {'...'};
                set(hpopup1,'String',categories_updated);
        end
    end

    function append1button_Callback(~,~)
        % select category of samples 
        delete(hpopup1);
        htext24 = uicontrol('Style','text','String',...
            'LOCKED! ','Position',[110,419,109,9],'HorizontalAlignment','left',...
            'FontSize',7);
        sdata = nonzeros(sdata); % indices of selected sample categories 
        set(hpopup2,'String',us_dat_name);
    end

    function popup_menu_2_Callback(source,~)
        % determine the selected variable categories
        if check_1D_results == 1
            str = get(source,'String');
            val = get(source,'Value');
            switch str{val};
                case cellstr(us_dat_name(val));
                    var_ind(val) = val;
                    selected_var(val) = us_dat_name(val); % togliere parentesi graffe se non funziona più
                    us_dat_name(val) = {'...'};
                    set(hpopup2,'String',us_dat_name);
            end
        else
            warndlg({'Please, evaluate the 1D distribution of variables',...
                'before Multivariate Analysis. ',...
                'Press "Analyze" button on Clustering menu, and ',...
                'inspect the probability density functions of ',...
                'each variables in the dataset.'});
        end
    end

    function append2button_Callback(~,~)   
        if check_1D_results == 1
            delete(hpopup2);
            htext25 = uicontrol('Style','text','String',...
                'LOCKED! ','Position',[110,350,109,9],'HorizontalAlignment','left',...
                'FontSize',7);
            var_ind = nonzeros(var_ind); 
        else
            warndlg({'Please, evaluate the 1D distribution of variables',...
                'before Multivariate Analysis. ',...
                'Press "Analyze" button on Clustering menu, and ',...
                'inspect the probability density functions of ',...
                'each variables in the dataset.'});
        end
    end

    %-------------------------------------%
    % Compute variance of single variables
    %-------------------------------------%  

    function analyze1button_Callback(~,~) 
        ind = get_slct_data(sdata,categories,label);
        indices = ind';
        indices = cell2mat(indices);
        data_var = size(variables_name);
        freq_data_with_nans = data(indices,3:data_var(2)+2);
        valid = isfinite(freq_data_with_nans); % check sparse dataset
        freq_data = cell(1,data_var(2));
        sdata_number = zeros(1,data_var(2)); % number of samples for each variable  
        for i = 1 : data_var(2)
            valid_par = valid(:,i);
            freq_data(i) = {freq_data_with_nans(valid_par == 1,i)}; % +2 excludes the columns of coordinates {data((valid(:,i) == 1),i+2)}
            sdata_number(i) = numel(cell2mat(freq_data(i)));
        end
        [classes,density,AVERAGE_VALUE,MEDIAN_VALUE,STD_VALUE] = freqdist1(freq_data,sdata_number);
        [cluster_size,med,std_dev] = filt_1(freq_data);
        htext21 = uicontrol('Style','text','String','done!',...
            'Position',[260,400,50,9],'HorizontalAlignment','left',...
            'FontSize',7);
        set(htext21,'Units','Normalized');
        set(hpopup8,'String',variables_name);
    end % perform cluster analysis

    %--------------------------%
    % localize selected samples
    %--------------------------%

    function analyze2button_Callback(~,~)
        % Interpolation of variables over the domain of overlap
        image_name = 'default';
        
        choice1 = questdlg('Specify domain of interpolation: ','Interpolation domain','Lands only','Lands and sea','Lands only');
        switch choice1
            case 'Lands only'
                choice_domain = 0;
            case 'Lands and sea'
                choice_domain = 1;
        end
                
        % INTERPOLATING ALL VARIABLES OVER THE DOMAIN OF INTEREST
        % Here the code interpolates the variables over a spatial domain of
        % interest (interpolation involves selected samples only!)  
    
        %===========================%
        % initialize cell structures
        %===========================%
      
        [~,N] = size(data);         % get the number of variables           
        [zz,XX,YY,background,lon_ext,lat_ext,data_ext] = domain_eval(data,indices);
        domain_extrapolated = cell2mat(zz(1));
        [q,w] = size(domain_extrapolated);
        % crop interpolated surfaces
        deconv = zeros(N-2,q*w);
        for i = 1 : N-2
            deconv(i,:) = reshape(cell2mat(zz(i)),1,q*w); % columnwise loop
        end
        eliminate = zeros(1,q*w);
        for j = 1 : q*w
            eliminate(j) = sum(deconv(:,j));
        end   
        for j = 1 : q*w
            if isnan(eliminate(j)) == 1
                deconv(:,j) = nan;
            end
        end
        for i = 1 : N-2
            zz(i) = {reshape(deconv(i,:),q,w)};
        end
        domain_extrapolated_cropped = cell2mat(zz(1));    
        zz_ind = zeros(q,w);
        for j = 1:q*w
            if isnan(domain_extrapolated_cropped(j)) == 0 
                    zz_ind(j) = 1;
            else
            end
        end
        x_grid = cell2mat(XX(1));   
        y_grid = cell2mat(YY(1));
        [sea,coast,data_points] = im2vec(y_grid,x_grid,image_name,zz_ind); 
        
        data_points_land = cell(1,N-2); % used in PCA calculations   
        coast_points = cell(1,N-2);     % used to display the cosatline
        
        if choice_domain == 1
            data_type_MVA = 0;
            data_points_all = cell(1,N-2);
            for i = 1 : N-2
                data_points_all(i) = zz(i);
            end
            for i = 1 : N-2
                datum = flipud(cell2mat(zz(i)));
                datum(isnan(data_points) == 1) = nan;
                data_points_land(i) = {flipud(datum)};
            end
            for i = 1 : N-2
                datum = flipud(cell2mat(zz(i)));
                datum(isnan(coast) == 1) = nan;
                coast_points(i) = {flipud(datum)};   
            end
        else
            data_type_MVA = 1;
            for i = 1 : N-2
                datum = flipud(cell2mat(zz(i)));
                datum(isnan(data_points) == 1) = nan;
                data_points_land(i) = {flipud(datum)};
            end
            if isempty(sea) == 0 
                data_points_all = cell(1,N-2);
                for i = 1 : N-2
                    color_background = cell2mat(background(i));
                    datum = flipud(cell2mat(data_points_land(i))); 
                    datum(isnan(sea) == 0) = color_background;
                    data_points_all(i) = {flipud(datum)};
                end
                for i = 1 : N-2
                    datum = flipud(cell2mat(data_points_land(i)));
                    datum(isnan(coast) == 1) = nan;
                    coast_points(i) = {flipud(datum)};   
                end
            else
                data_points_all = cell(1,N-2);
                for i = 1 : N-2
                    data_points_all(i) = {data_points_land(i)};
                end         
            end
        end   
        htext22 = uicontrol('Style','text','String','done!',...
            'Position',[260,348,50,9],'HorizontalAlignment','left',...
            'FontSize',7);
        set(htext22,'Units','Normalized');
        data_type = {'Univariate'};
        set(hpopup3,'String',data_type);
        set(hpopup4,'String',selected_var(var_ind));
        set(hpopup6,'String',{'Lands only','All'});
    end % interpolate variables

    function mvabutton_Callback(~,~) 
        if data_type_MVA == 1
            data_MVA = data_points_land;
        else
            data_MVA = data_points_all;
        end
            [COEFF,component_name,PC_scores] = mva(data_MVA,selected_var,var_ind);
            htext23 = uicontrol('Style','text','String','done!',...
                'Position',[260,313,50,9],'HorizontalAlignment','left',...
                'FontSize',7);
            set(htext23,'Units','Normalized');
            if iscell(PC_scores) == 1
                data_type = {'Univariate','PCA'};
            else 
                data_type = {'Univariate'}; 
            end      
            set(hpopup3,'String',data_type);  
    end % do multivariate analysis

    function popup_menu_8_Callback(source,~) 
        str = get(source, 'String');
        val = get(source,'Value');
        % Set current 1d data to selected variable
        selected_var_1d = variables_name;    
        switch str{val};
            case selected_var_1d(val);
                selected_variable_1d = val;
        end
    end % select variable to be plotted in graph1

    function plotbutton2_Callback(~,~)
        % Plot cluster analysis
        graph1(h1,AVERAGE_VALUE,MEDIAN_VALUE,classes,density,sdata_number,all,selected_variable_1d,variables_name,med,cluster_size);  
        pop = cell2mat(cluster_size);
        [pop1_val,pop1_pos] = max(pop(:,selected_variable_1d));
        string_median = cell2mat(med);
        string_std_dev = cell2mat(std_dev);
        htext10 = uicontrol('Style','text','String',...
            ['mean: ',num2str(AVERAGE_VALUE(selected_variable_1d),'% 10.2f')],'Position',[250 176 80 10],'HorizontalAlignment','left',... 
            'FontSize',7);
        htext11 = uicontrol('Style','text','String',...
            ['median: ',num2str(MEDIAN_VALUE(selected_variable_1d),'% 10.2f')],'Position',[250 165 80 10],'HorizontalAlignment','left',...
            'FontSize',7);
        htext12 = uicontrol('Style','text','String',...
            ['std. dev.: ',num2str(STD_VALUE(selected_variable_1d),'% 10.2f')],'Position',[250 154 80 10],'HorizontalAlignment','left',...
            'FontSize',7);
        htext14 = uicontrol('Style','text','String',...
            ['population: ',num2str(pop1_val)],'Position',[250 125 80 10],'HorizontalAlignment','left',...
            'FontSize',7);
        htext15 = uicontrol('Style','text','String',...
            ['median: ',num2str(string_median(pop1_pos,selected_variable_1d),'% 10.2f')],'Position',[250 114 80 10],'HorizontalAlignment','left',...
            'FontSize',7);
        htext16 = uicontrol('Style','text','String',...
            ['std. dev.: ',num2str(string_std_dev(pop1_pos,selected_variable_1d),'% 10.2f')],'Position',[250 103 80 10],'HorizontalAlignment','left',...
            'FontSize',7);
        check_1D_results = 1;
        
    end % plot results in graph1
  
    function popup_menu_3_Callback(source,~) 
        str = get(source, 'String');
        val = get(source,'Value');
            switch str{val};
                case 'Univariate' % User selects single variable mode 
                    datalist = cellstr(selected_var(var_ind));
                    plot_type = {'Lands only','All'};
                    data_type_slct = 1;      
                case 'PCA' % User selects Principal Components mode
                    datalist = cellstr(component_name);
                    plot_type = {'..','Default'};
                    data_type_slct = 11;
            end
        set(hpopup4,'String',datalist);
        set(hpopup6,'String',plot_type);
    end % select data type to be plotted in graph2
  
    function popup_menu_4_Callback(source,~) 
        % Determine the selected data set.
        str = get(source, 'String');
        val = get(source,'Value');
        % Set current data to the selected data set
        activeVar = selected_var(var_ind);
        switch str{val};   
            case datalist(val); % User selects some data..
                selected_data_23d = val;% 
                if data_type_slct == 1
                    data_23d_name = activeVar(val);
                else
                    data_23d_name = component_name(val);
                end
        end
    end % select data to be plotted in graph2

    function popup_menu_5_Callback(source,~) 
        str = get(source, 'String');
        val = get(source,'Value');
        switch str{val};
            case '2d'%visualization_mode(val) % User selects type of visualization either 2d or 3d
                visualization = 1;
            case '3d'
                visualization = 2;
        end
    end % set visualization mode either 2d or 3d

    function popup_menu_6_Callback(source,~) 
        str = get(source, 'String');
        val = get(source,'Value');
        switch str{val};
            case plot_type(val)          % User selects some type of plot..
                if data_type_slct == 1   % User choose univariate interpolation
                    if val == 1          % user choose lands only
                        z_variable_var = cell2mat(data_points_land(var_ind(selected_data_23d))); 
                    else 
                        z_variable_var = cell2mat(data_points_all(var_ind(selected_data_23d)));
                    end
                else                % user choose PCA interpolation
                    z_variable_var = cell2mat(PC_scores(selected_data_23d)); 
                end
        end
    end % interpolated over the full domain or lands only

    function checkbutton1_Callback(source,~) 
        val = get(source,'Value');
        switch val
            case 1
                samples_activated = 1; % user decide to plot samples 
            case 0
                samples_activated = 0; % plot without samples
        end
    end % eventually display samples over the interpolated surface
  
    function popup_menu_7_Callback(source,~) 
        str = get(source, 'String');
        val = get(source,'Value');
        % Set current colormap to selected colormap
        switch str{val};
            case 'mountain' 
                load('mountain','mountain')
                set(gcf,'Colormap',mountain);
                col_scale = 1;
            case 'lights' 
                load('lights','lights')
                set(gcf,'Colormap',lights);
                col_scale = 2;
            case 'magma'
                load('magma','magma');
                set(gcf,'Colormap',magma);
                col_scale = 3;
            case 'ice'
                load('ice','ice');
                set(gcf,'Colormap',ice);
                col_scale = 4;
            case 'moon'
                load('moon','moon');
                set(gcf,'Colormap',moon);
                col_scale = 5;
            case 'grayscale'
                load('grayscale','grayscale');
                set(gcf,'Colormap',grayscale);
                col_scale = 6;
            case 'sharp1'
                load('sharp1','sharp1');
                set(gcf,'Colormap',sharp1);
                col_scale = 7;
            case 'sharp2'
                load('sharp2','sharp2');
                set(gcf,'Colormap',sharp2);
                col_scale = 8;
            case 'binary'
                load('binary','binary');
                set(gcf,'Colormap',binary);
                col_scale = 9;
            case 'binary1'
                load('binary1','binary1');
                set(gcf,'Colormap',binary1);
                col_scale = 13;  
            case 'binary2'
                load('binary2','binary2');
                set(gcf,'Colormap',binary2);
                col_scale = 14;
            case 'sharp3'
                load('sharp3','sharp3');
                set(gcf,'Colormap',sharp3);
                col_scale = 10;
            case 'sharp4'
                load('sharp4','sharp4');
                set(gcf,'Colormap',sharp4);
                col_scale = 11;
            case 'natural'
                load('natural','natural');
                set(gcf,'Colormap',natural);
                col_scale = 12;
        end
    end % change colormap

    function plotbutton1_Callback(~,~)
        % Plot interpolation of the currently selected dataset.
        load('grayscale','grayscale');
        set(gcf,'Colormap',grayscale);
        graph2a(h2,x_grid,y_grid,z_variable_var,data_23d_name,lon_ext,lat_ext,data_ext,...
            selected_data_23d,col_scale,visualization,samples_activated,coast_points,variables_name);  
            set(hpopup7,'String',{'mountain','lights','magma','ice','moon','grayscale','sharp1','sharp2','binary','binary1','binary2','sharp3','sharp4','natural'});
    end % plot results in graph2

    function cancelbutton1_Callback(~,~) 
        % Clear workspace and initialize all variables
        data = [];               
        label = {};              
        all = 0;                  
        categories = {};             
        us_dat_name = {};
        categories_updated = {};  
        sdata = [];
        ind = [];
        var_ind = []; 
        selected_var = {};
        sdata_number = [];
        freq_data = {};
        classes = [];
        density = [];
        cluster_size = {};
        med = {};
        std_dev = {};
        datalist = [];
        samples_activated = 1;    
        indices = [];             
        selected_variable_1d = 0; 
        selected_data_23d = 0;    
        data_points_land = {};   
        data_points_all = {};     
        visualization = '2d';     
        z_variable_var = [];      
        type = 1;
        x_grid = [];
        y_grid = [];
        lon_ext = {};
        lat_ext = {};
        data_ext = {};
        data_type = 1;
        data_23d_name = '';
        component_name = {};
        coastline = {};
        coast = [];
        col_scale = 1;           
        visualization = 1;       
        PC_scores = {};
        htext6 = uicontrol('Style','text','String',...
            [num2str(0),' variable(s)'],...
            'Position',[17,320,70,20],'HorizontalAlignment','left',...
            'FontSize',7);
        htext7 = uicontrol('Style','text','String',...
            [num2str(0),' samples'],...
            'Position',[17,308,70,20],'HorizontalAlignment','left',...
            'FontSize',7);
        hpopup1 = uicontrol('Style','popupmenu',...
            'String','..','Position',[110,421,109,9],...
            'Callback',{@popup_menu_1_Callback},'FontSize',7); 
        hpopup2 = uicontrol('Style','popupmenu',...
            'String','..','Position',[110,352,109,9],...
            'Callback',{@popup_menu_2_Callback},'FontSize',7); 
        delete(hpopup3);
        hpopup3 = uicontrol('Style','popupmenu',...
            'String','...','Position',[360,556,67,9],...
            'Callback',{@popup_menu_3_Callback},'FontSize',7);
        delete(hpopup4);
        hpopup4 = uicontrol('Style','popupmenu',...% 4+
            'String','..','Position',[428,556,65,9],...
            'Callback',{@popup_menu_4_Callback},'FontSize',7);
        delete(hpopup6);
        hpopup6 = uicontrol('Style','popupmenu',...
            'String','...','Position',[571,556,66,9],...
            'Callback',{@popup_menu_6_Callback},'FontSize',7);
        delete(hpopup8)
        hpopup8 = uicontrol('Style','popupmenu',...
            'String','...','Position',[22,271,73,9],...
            'Callback',{@popup_menu_8_Callback},'FontSize',7);
        if isempty(htext21) == 0 || isempty(htext22) == 0 || isempty(htext23) == 0
            delete(htext21,htext22,htext23);  
        end
        cla(h1,'reset');
        cla(h2,'reset');
    end % cancel dataset and reset default values

    function cancelbutton2_Callback(~,~) 
   % Clear graph2
      cla(h2,'reset');     
   end % cancel graph1

    function cancelbutton3_Callback(~,~) 
   % Clear graph2
      cla(h1,'reset');    
   end % cancel graph2

    function exportbutton_Callback(~,~) 
        % Open graph2 in a separate window to explore and save data in raster
        % formats
        h77 = figure('Position',[100,100,500,500],'Resize','on');
        h4 = axes('Units','Pixels','Position',[70,70,440,300]);
        set([h77,h4],'Units','normalized');
        colorF3 = load(cell2mat(string_colors(col_scale)),cell2mat(string_colors(col_scale))); % structure array 
        colorF3_cell = struct2cell(colorF3);
        set(gcf,'Colormap',cell2mat(colorF3_cell)); % retrieve color information
        graph2a(h4,x_grid,y_grid,z_variable_var,data_23d_name,lon_ext,lat_ext,data_ext,...
            selected_data_23d,col_scale,visualization,samples_activated,coast_points,variables_name); 
    end % open graph2 in new figure

    function exportbutton1_Callback(~,~) 
       % Open graph1 in a separate window to explore and save data in raster
       % formats
       h99 = figure(2);
       h3 = axes('Units','Pixels','Position',[70,70,440,300]); 
       set([h99,h3],'Units','normalized');
       graph1(h3,AVERAGE_VALUE,MEDIAN_VALUE,classes,density,sdata_number,all,selected_variable_1d,variables_name,med,cluster_size);
    end % open graph1 in new figure

    function HELPbutton1_Callback(~,~) 
   % Display the help menu in a separate window
      open('read_me.pdf');
   end % load the help menu
end