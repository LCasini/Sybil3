function ind = get_slct_data(sdata,categories,label)
% The function returns a cell array [number_of_selected_datasets*1] 
% that store  indices to selected data.
%==========================================================================
sdata_num = numel(sdata);               % get number of selected data sets

ind = cell(sdata_num,1);                % initialize cell structure storing 
                                        % vector of indices to selected 
                                        % data (0 = unselected, 1 = 
                                        % selected)
indices = cell2mat(ind);                % convert cell structure to matrix

for i = 1 : sdata_num
    ind(i) = {strcmp(categories(sdata(i)),label)}; 
    indices(i,:) = (cell2mat(ind(i)) == 1);
    ind(i) = {find(indices(i,:) == 1)};
end
end