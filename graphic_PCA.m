function graphic_PCA(x_grid,y_grid,PC_scores,data_name,int_data,coastline,col_scale,coast,plot_mode)
% the function plots the result of interpolation of scattered data over the  
% domain of interest defined by sample coordinates. Different types of plot
% are allowed
%==========================================================================

z_variable = cell2mat(PC_scores(int_data)); 

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

    coast = flipud(coast); 
    [m,n] = size(coast);
    imx = nan(m,n);
    imy = nan(m,n);
    imx(coast == 1) = x_grid(coast == 1);
    imy(coast == 1) = y_grid(coast == 1);
    z_scale = cell2mat(coastline(int_data));
    imz = imx*z_scale;

    plot3(imx,imy,imz,['.',coast_color],'MarkerSize',1);

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