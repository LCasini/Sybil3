function [classes, density,AVERAGE_VALUE,MEDIAN_VALUE,STD_VALUE] = freqdist1(freq_data,sdata_number)
% the function calculates the frequency distribution for a given
% dataset of scalar data (data) sampled with the required frequency (step)
%==========================================================================

step = 10; % define 1% bins
[~,n] = size(freq_data);

classes = zeros(step,n);
density = zeros(step,n);
AVERAGE_VALUE = zeros(1,n);
MEDIAN_VALUE = zeros(1,n);
STD_VALUE = zeros(1,n);

for i = 1 : n
    f_data = cell2mat(freq_data(:,i));
    classes(:,i) = linspace(min(f_data),max(f_data),step);
    density(1,i) = (100*numel(find(f_data < classes(1,i))))/sdata_number(i);
    AVERAGE_VALUE(i) = mean(f_data);
    MEDIAN_VALUE(i) = median(f_data);
    STD_VALUE(i) = std(f_data);
    for j = 2 : step
        density(j,i) = (100*(numel(find(f_data < classes(j,i)))-...
            numel(find(f_data < classes(j-1,i)))))/sdata_number(i);
    end  
end
end