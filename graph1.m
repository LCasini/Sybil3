function graph1(h1,AVERAGE_VALUE,MEDIAN_VALUE,classes,density,sdata_number,all,selected_variable_1d,variables_name,med,cluster_size)
% the function plots the result of univariate statistical analysis of  
% selected data sets 
%--------------------------------------------------------------------------
% programmer: L. Casini 
% contact: casini@uniss.it
% institution: University of Sassari (2013)
%==========================================================================

bar(h1,classes(:,selected_variable_1d),density(:,selected_variable_1d),'FaceColor',[1 0 0]);
title(h1,['Frequency distribution plot of ',...
    num2str(sdata_number(selected_variable_1d)),' out of ',num2str(all),...
    ' samples'],'FontSize',8,...
    'FontName','helvetica');
xlabel(h1,variables_name(selected_variable_1d));
ylabel(h1,'Relative frequency [%]');
hold(h1,'on')

cluster_size = cell2mat(cluster_size);
[~,pos1] = max(cluster_size(:,selected_variable_1d)); 
marker_dim = ones(1,3)*6;                 
marker_dim(pos1) = 12;
[~,pos2] = min(cluster_size(:,selected_variable_1d));
marker_dim(pos2) = 3;
med = cell2mat(med);
percent_population_cluster = (cluster_size*100)./all;
base = [0 0 0];
h3 = get(h1,'ylim');
height = percent_population_cluster*h3(2)./100;


% plot the median and mean value for the bulk population
plot(h1,[AVERAGE_VALUE(selected_variable_1d),AVERAGE_VALUE(selected_variable_1d)],[0,h3(2)*0.8],'-k','LineWidth',1);
plot(h1,[MEDIAN_VALUE(selected_variable_1d),MEDIAN_VALUE(selected_variable_1d)],[0,h3(2)*0.95],'--k','LineWidth',1.5);

for i = 1:3
    plot(h1,[med(i,selected_variable_1d) med(i,selected_variable_1d)],[base(i) height(i,selected_variable_1d)],'-b','LineWidth',1);
    plot(h1,med(i,selected_variable_1d),height(i,selected_variable_1d)*0.5,'ob','LineWidth',1,'MarkerfaceColor',...
        [1 1 1],'MarkerSize',marker_dim(i));
end
hold(h1,'off')
end