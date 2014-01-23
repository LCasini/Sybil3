function graph2a(h2,x_grid,y_grid,z_variable_var,data_name,lon_ext,lat_ext,data_ext,selected_data_23d,col_scale,visualization,samples_activated,coast_points,variables_name)
% the function plots the result of interpolation of scattered data over the  
% domain of interest defined by sample coordinates. Different types of plot
% are allowed
%==========================================================================

% set white coastline if dark colormaps are set to on
if col_scale == 3 || col_scale == 6 
    coast_color = 'w';
else
    coast_color = 'k';
end

coast = cell2mat(coast_points(selected_data_23d));
[m,n] = size(coast);
imx = nan(m,n);
imy = nan(m,n);
imx(isnan(coast) == 0) = x_grid(isnan(coast) == 0);
imy(isnan(coast) == 0) = y_grid(isnan(coast) == 0);
var_pos = strcmp(variables_name,data_name);
var_ind = (var_pos > 0);

if visualization == 2 % user selected 3d plot
    surf(h2,x_grid,y_grid,z_variable_var,'FaceColor','interp','EdgeColor','none',...
        'FaceLighting','phong');
    camlight('right')
    material dull                                % no specular reflections
    grid on
    zlabel(h2,cell2mat(data_name),'FontSize',7,'FontWeight','Bold')
    axis normal;
    hold(h2,'on')
    title(h2,['surf plot of ',cell2mat(data_name)],'FontSize',8,'FontWeight','bold');
    xlabel(h2,'longitude')
    ylabel(h2,'latitude')
    set(gca,'ZLim',[min(min(z_variable_var)) max(max(z_variable_var))*3]);
    set(gca,'XLim',[min(min(x_grid)) max(max(x_grid))]);
    set(gca,'YLim',[min(min(y_grid)) max(max(y_grid))]);
    colorbar('EastOutSide')
    
    % extract points on the coast line
         
    coastline = nan(m,n);
    coastline(isnan(coast) == 0) = z_variable_var(isnan(coast) == 0);
    plot3(h2,imx,imy,coastline,['.',coast_color],'MarkerSize',4);

    % request permission to display samples

    if samples_activated == 1
        x_dim = cell2mat(lon_ext(var_ind));
        y_dim = cell2mat(lat_ext(var_ind));
        z_dim = cell2mat(data_ext(var_ind));
        plot3(x_dim,y_dim,z_dim,'ok','MarkerfaceColor','w','MarkerSize',3);
    end 
    
    hold(h2,'off')  
    
else % user select 2d plot
    [C,h] = contourf(h2,x_grid,y_grid,z_variable_var,10);
    grid on
    zlabel(h2,cell2mat(data_name),'FontSize',7,'FontWeight','Bold')
    axis normal;
    hold (h2,'on')
    title(h2,['contour plot of ',cell2mat(data_name)],'FontSize',8,'FontWeight','bold');
    xlabel(h2,'longitude')
    ylabel(h2,'latitude')
    set(gca,'XLim',[min(min(x_grid)) max(max(x_grid))]);
    set(gca,'YLim',[min(min(y_grid)) max(max(y_grid))]);
    plot(h2,imx,imy,['.',coast_color],'MarkerSize',3);
    
    if samples_activated == 1
        x_dim = cell2mat(lon_ext(var_ind));
        y_dim = cell2mat(lat_ext(var_ind));
        plot(x_dim,y_dim,'ok','MarkerfaceColor','w','MarkerSize',3);
    end
    colorbar('EastOutSide')
    hold(h2,'off')
end