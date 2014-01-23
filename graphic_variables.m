function graphic_variables(x_grid,y_grid,data_points_all,data_points_land,data_name,lon_ext,lat_ext,data_ext,int_data,coastline,col_scale,coast,plot_mode)
% the function plots the result of interpolation of scattered data over the  
% domain of interest defined by sample coordinates. Different types of plot
% are allowed
%==========================================================================

choice1 = questdlg('Set visualization mode?','Choose between LANDS (Variable interpolation shown only for emerged areas), and ALL (Variable interpolation over the whole area):..','LANDS','ALL','ALL');
switch choice1
    case 'LANDS'
        z_variable = cell2mat(data_points_land(int_data)); 
        check1 = 1;
    case 'ALL'
        z_variable = cell2mat(data_points_all(int_data)); 
        ckeck1 = 0;
end

% set white coastline if dark colormaps are set to on
if col_scale == 3 || col_scale == 6 
    coast_color = 'w';
else
    coast_color = 'k';
end

selplot = strcmp('3d',plot_mode);

if selplot == 1
    surf(x_grid,y_grid,z_variable,'FaceColor','interp','EdgeColor','none',...
        'FaceLighting','phong');
    camlight('right')
    material dull                                % no specular reflections
    grid on
    zlabel(cell2mat(data_name),'FontSize',7,'FontWeight','Bold')
    axis normal;
    hold on
    title(['surf plot of ',cell2mat(data_name)],'FontSize',8,'FontWeight','bold');
    xlabel('longitude')
    ylabel('latitude')
    set(gca,'ZLim',[min(min(z_variable)) max(max(z_variable))*3]);
    set(gca,'XLim',[min(min(x_grid)) max(max(x_grid))]);
    set(gca,'YLim',[min(min(y_grid)) max(max(y_grid))]);
    colorbar('EastOutSide')
    
    % extract points on the coast line
    
    if check1 == 0
        coast = flipud(coast); 
        [m,n] = size(coast);
        imx = nan(m,n);
        imy = nan(m,n);
        imx(coast == 1) = x_grid(coast == 1);
        imy(coast == 1) = y_grid(coast == 1);
        z_scale = cell2mat(coastline(int_data));
        imz = imx*z_scale;

        plot3(imx,imy,imz,['.',coast_color],'MarkerSize',1);
    end

    % request permission to display samples

    choice2 = questdlg('display samples?','Load inputs','yes','no','no');
    x_dim = cell2mat(lon_ext(int_data));
    y_dim = cell2mat(lat_ext(int_data));
    z_dim = cell2mat(data_ext(int_data));

    switch choice2
        case 'yes'
            plot3(x_dim,y_dim,z_dim,'ok','MarkerfaceColor','w','MarkerSize',3);
        case 'no'
    end
else
    contourf(x_grid,y_grid,z_variable);
    grid on
    zlabel(cell2mat(data_name),'FontSize',7,'FontWeight','Bold')
    axis normal;
    hold on
    title(['contour plot of ',cell2mat(data_name)],'FontSize',8,'FontWeight','bold');
    xlabel('longitude')
    ylabel('latitude')
    set(gca,'XLim',[min(min(x_grid)) max(max(x_grid))]);
    set(gca,'YLim',[min(min(y_grid)) max(max(y_grid))]);
    colorbar('EastOutSide')
end