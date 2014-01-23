function[categories,categories_size,cat_num] = get_category(label)
% the function inport the vector of sample labels, and get:
% cat_num = [scalar], number of categories specified by the user as label  
%           entries (column 'rock type' in the samples.xls file)
% categories = [1 x cat_num, cell array], store the name of each data set
% categories_size = [1 x cat_num, cell array], store the vectors of indices
%                   of elements within each data set
%==========================================================================
CATEGORIES = cell(1,numel(label));
sample_num = cell(1,numel(label));
CATEGORIES_SIZE = cell(1,numel(label));
CATEGORIES(1) = label(1);
i = 1;                                     % initialize categories count
sample_num(1) = {strcmp(char(CATEGORIES(1)),label)};
CATEGORIES_SIZE(1) = {find(cell2mat(sample_num(1)))};
count = cell2mat(sample_num(1));
samples = sum(cell2mat(sample_num(1)));

while samples < numel(label)
    CATEGORIES(i+1) = label(find(count == 0,1)); 
    sample_num(i+1) = {strcmp(char(CATEGORIES(i+1)),label)};
    CATEGORIES_SIZE(i+1) = {find(cell2mat(sample_num(i+1)))};
    count = count + cell2mat(sample_num(i+1));
    samples = samples + sum(cell2mat(sample_num(i+1)));
    i = i+1;
end

cat_num = i;

j = 1;
categories = cell(1,i);
categories_size = cell(1,i);

while ischar(cell2mat(CATEGORIES(j))) == 1
    categories(j) = CATEGORIES(j);
    categories_size(j) = CATEGORIES_SIZE(j);
    j = j+1;
end
end
