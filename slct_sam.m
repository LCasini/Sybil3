function [sdata] = slct_sam(categories,cat_num)
% the function accept inputs from the user and returns:
% sdata, [1 x number of selected data] row vector that stores the indices
%        of categories added to the plot (number of the cell within cell 
%        structure 'categories')
%--------------------------------------------------------------------------
% programmer: L. Casini 
% contact: casini@uniss.it
% institution: University of Sassari (2013)
%==========================================================================

str = categories;

answer = questdlg('Select samples?','Data menu','append data..',...
    'cancel','append data..');

switch answer
    case 'append data..'
        s = 1;
    case 'cancel'
        s = 0;
end

i = 1;

sdata = zeros(1,cat_num);                    % initialize selected data
if s == 1
    [input,ok] = listdlg('PromptString','Select category: ','SelectionMode',...
        'single','ListSize',[120 68+cat_num*8],'ListString',str);
    
    if ok == 0
        h1 = warndlg('No data selected! Closing window..');
        pause(1);
        delete(h1);
        s = 0;                               % force exit
    else 
        sdata(1) = input;
    end
       
else warndlg('No data selected!');
end

str(sdata(1)) = {'..'};                      % update string categories 


while s == 1 && i < cat_num
    
    answer = questdlg('Select another category?','Data menu','add samples',...
    'cancel','add samples');

    switch answer
        case 'add samples'
            s = 1;
        case 'cancel'
            s = 0;
    end
    
    if s == 1
        [input,ok] = listdlg('PromptString','Select category: ','SelectionMode',...
            'single','ListSize',[120 68+cat_num*8],'ListString',str);
        if ok == 0
            h1 = warndlg('No data added! Closing window..');
            pause(1);
            delete(h1);
            s = 0;                           % force exit
        else
            sdata(i+1) = input;
            i = i+1;                         % update sample number..   
        end
    end
    str(sdata(i)) = {'..'};
end
sdata = nonzeros(sdata);                     % indices of selected dataset
end