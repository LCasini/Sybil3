function var_ind = slct_var(us_dat_name)
% the function accept inputs from the user and returns:
% var_ind, [1 x number of selected data] row vector that stores the indices
%          of variables to be evaluated
%==========================================================================
var_num = numel(us_dat_name);
str = us_dat_name;

answer = questdlg('Select a variable?','Data menu','add variable..',...
    'cancel','add variable..');

switch answer
    case 'add variable..'
        s = 1;
    case 'cancel'
        s = 0;
end

i = 1;

var_ind = zeros(1,var_num);                     % initialize selected data

if s == 1
    [input,ok] = listdlg('PromptString','Select variable: ','SelectionMode',...
        'single','ListSize',[120 68+var_num*8],'ListString',str);
    
    if ok == 0
        h1 = warndlg('No variable selected! Closing window..');
        pause(1);
        delete(h1);
        s = 0;             % force exit
    else 
        var_ind(1) = input+2;   
    end      
else warndlg('No variable selected!');
end

str(var_ind(1)-2) = {'..'};                     % update string variables

while s == 1 && i < var_num
    
    answer = questdlg('Select another variable?','Data menu','add variable..',...
    'cancel','add variable..');

    switch answer
        case 'add variable..'
            s = 1;
        case 'cancel'
            s = 0;
    end
    
    if s == 1
        [input,ok] = listdlg('PromptString','Select data: ','SelectionMode',...
            'single','ListSize',[120 68+var_num*8],'ListString',str);
        if ok == 0
            h1 = warndlg('No variable added! Closing window..');
            pause(1);
            delete(h1);
            s = 0;             % force exit
        else
            var_ind(i+1) = input+2;
            str(var_ind(i+1)-2) = {'..'};   % update string variables..
            i = i+1;                        % update sample number..
        end
    end
end
var_ind = nonzeros(var_ind);                % indices to selected variables
end