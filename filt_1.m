function [cluster_size,med,std_dev] = filt_1(freq_data)
% the function search for cluster of data within irregularly distributed 
% datasets and returns the following outputs:
% p = 2-by-1 array, stores coefficients of linear regression to sorted data 
% bin = scalar, stores the bin size (number of samples) that represents the
%       threshold set by the user
% cluster_number = scalar, stores the number of clusters
% cluster_size = cluster_number-by-1 vector, stores the number of values
%                within clusters 
% med = cluster_number-by-1 vector, stores the median value of clusters 
% std_dev = cluster_number-by-1 vector, stores the standard deviation
%           around median values
%--------------------------------------------------------------------------
% programmer: L. Casini 
% contact: casini@uniss.it
% institution: University of Sassari (2013)
%==========================================================================
N = numel(freq_data);              % number of variables
data_sorted = cell(1,N);
num = zeros(1,N);
groups = cell(1,N);
cluster_size = cell(1,N);          % each cell stores a 3x1 column vector 
                                   % of number of data within each cluster;
                                   % the number of cell indicates different
                                   % variable so that cluster_size(1) is 
                                   % for variable 1, and so on..
med = cell(1,N);                   % same as cluster_size (median values) 
std_dev = cell(1,N);               % same as cluster_size (std dev values) 
clust = zeros(3,N);

for i = 1 : N
    data_with_nans = cell2mat(freq_data(i));
    freq_data_valid = isnan(data_with_nans);
    data_sorted(i) = {sort(data_with_nans(freq_data_valid == 0))};
    num(i) = numel(cell2mat(data_sorted(i)));
    groups(i) = {clusterdata(cell2mat(data_sorted(i)),'maxclust',3,'distance','seuclidean')};
end

for i = 1 : N
    group = cell2mat(groups(i));
    datum_sorted = cell2mat(data_sorted(i));
    M = zeros(3,1);
    S = zeros(3,1);
    for j = 1 : 3
        clust(j,i) = numel(find(group == j));
        M(j) = median(datum_sorted(group == j));
        S(j) = std(datum_sorted(group == j));    
    end
    cluster_size(i) = {clust(:,i)};
    med(i) = {M};
    std_dev(i) = {S};
end

end


