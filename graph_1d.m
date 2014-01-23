function graph_1d(var_ind,us_dat_name,med,std_dev,cluster_size,classes,density,sdata_number,all)
% the function plots the result of univariate statistical analysis of  
% selected data sets 
%--------------------------------------------------------------------------
% programmer: L. Casini 
% contact: casini@uniss.it
% institution: University of Sassari (2013)
%==========================================================================
str = us_dat_name(var_ind-2);             % exclude coordinate columns
cat_num = numel(str);
[var,ok] = listdlg('PromptString','Select variable: ','SelectionMode',...
        'single','ListSize',[120 68+cat_num*8],'ListString',str);

if ok == 0
    h1 = warndlg('No variable selected!');
    pause(1)
    delete(h1);
else
    figure(1);
    h2 = area(classes(:,var),density(:,var));
    set(h2,'FaceColor',[1 0 0]);
    title(['Frequency distribution plot of ',...
        num2str(sdata_number(var)),' out of ',num2str(all),...
        ' samples'],'FontSize',9,'FontWeight','bold',...
        'FontName','helvetica');
    xlabel(str(var),'FontWeight','bold');
    ylabel('Relative frequency [%]','FontWeight','bold');
    hold on
end

[val,pos1] = max(cell2mat(cluster_size(var)));
marker_dim = ones(1,3)*3;                 % initialize marker size values
marker_dim(pos1) = 7;
[~,pos2] = max(cell2mat(cluster_size(var))-val);
marker_dim(pos2) = 5;
med = cell2mat(med);
std_dev = cell2mat(std_dev);
cluster_size = cell2mat(cluster_size);
for i = 1 : 3
    plot([med(i,var) med(i,var)],[0 max(density(i,var))*0.75],'-b','LineWidth',1.5);
    plot(med(i,var),max(density(i,var))*0.35,'ob','LineWidth',1,'MarkerfaceColor',...
        [1 1 1],'MarkerSize',marker_dim(i));
    height = max(density(i,var))*0.4;
    text(med(i,var)-std_dev(i,var),height,['median = ',num2str(med(i,var),'% 10.2f')],...
        'FontSize',6,'FontWeight','bold','FontName','helvetica',...
        'BackGroundColor','w');
    text(med(i,var)-std_dev(i,var),height-1,['std. dev. = ',num2str(std_dev(i,var),'% 10.2f')],...
        'FontSize',6,'FontWeight','bold','FontName','helvetica',...
        'BackGroundColor','w');
    text(med(i,var)-std_dev(i,var),height-2,['population = ',num2str(((cluster_size(i,var)*100)/sdata_number(var)),'% 10.1f'),' %'],...
        'FontSize',6,'FontWeight','bold','FontName','helvetica',...
        'BackGroundColor','w');
end
end