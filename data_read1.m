function [data,label,num,filename] = data_read1
% the function open input dialog, get the name of xls file from the user's
% input and store data as matrix data [16 x number of data]. Data ID/label
% are stored in a cell structure label [1 x number of data]
%==========================================================================
filename = inputdlg('Enter name of .xls file: ','Load inputs',1);
if strcmp(filename,'') == 0
    filename = char(filename);
    
    [data,label] = xlsread([num2str(filename),'.xls'],1,'B7:BB2500'); 
    [num,~] = size(data);
else
    warndlg('No data selected!');
    data = [];
    label = [];
    filename = '';
end
end