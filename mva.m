function [COEFF,component_name,PC_scores] = mva(data_points_land,us_dat_name,var_ind)
% The function perform multivariate analysis of large datasets stored in a
% m-by-N matrix (data) where the number of rows m is the number of 
% samples and the number of column N is the number of variables.
% 
% HOW TO MAKE MVA FUNCTION:
%
% Each dataset must contain the same number of data, so that sample of 
% different datasets have consistent coordinate pairs. The function 
% MVA should be applied to evaluate homogeneous datasets, however 
% heterogeneous samples may be evaluated as well by pre-processing the
% original data matrices (e.g., interpolation of scattered data) 
% 
%--------------------------------------------------------------------------
% programmer: Leonardo Casini
% Institution: University of Sassari (2013)
% contact: casini@uniss.it
% OS specification: Windows7 (64bit)
% Matlab version: r2010a
%==========================================================================
                                                 
%N = numel(data_points_land);                % get variables number
N = numel(var_ind);   
% extract numeric values only, the results are stored into N column vectors
% of k-by-1 dimension (where k is the number of not NaN elements of each 
% dataset matrix data_PCA

data_PCA = cell(1,N);
data_PCA_ind = find(~isnan(cell2mat(data_points_land(1))));  % index of points where PCA   
                                                             % applies

for i = 1 : N
    data = cell2mat(data_points_land(var_ind(i))); 
    data_PCA(i) = {data(data_PCA_ind)};
end

%-----------------------------%
% STANDARDIZATION OF VARIABLES
%-----------------------------%
% here the code transform the original variable into standard Z-scores 
% in order to compare datasets ranging over several orders of magnitude.
% The method involves subtracting the mean and divide by the standard 
% deviation of each variable at any given point    
standard_scores = cell(1,N);

for i = 1 : N    
    standard_scores(i) = {(cell2mat(data_PCA(i))-...
        mean(cell2mat(data_PCA(i))))./std(cell2mat(data_PCA(i)))};
end      
%------------------------------%
% PRINCIPAL COMPONENTS ANALYSIS
%------------------------------%
% compute covariance matrix (C), the matrix of loadings (COEFF), the 
% eigenvalues (latent) and percentage of total variance allowed to each 
% variable (explained). Data in the covariance matrix [p,q] are arranged 
% as usual (each of the p rows represents an observation of q variables). 
    
C = cov(cell2mat(standard_scores));
[COEFF_nonrotated,latent,explained] = pcacov(C);

% find significant components (eigenvalues greater than 1. Eigenvalues are 
% stored in a 1-by-N column vector where the first element represent the
% first variable and so on).

PC_ind = find(latent > 1,1,'last');
COEFF_nonrotated = COEFF_nonrotated(:,1:PC_ind); 
% The check eventually stop code execution if PC are less than 2

[~,check_consistency] = size(COEFF_nonrotated); 
component_name = cell(1,check_consistency);
PC_scores = cell(1,check_consistency);

if check_consistency > 1  
% Varimax rotation of the loadings matrix; this maximize the component 
% loading variance (high loadings are made higher and low ones are reduced 
% for each component to improve interpretability)

    COEFF = rotatefactors(COEFF_nonrotated);% alternative method: --> 'Method','promax'
    stat_report(COEFF_nonrotated,COEFF,latent,explained);   % export the results of PCA as .xls file tables
    
    %---------------------------------%
    % SET NAME OF PRINCIPAL COMPONENTS
    %---------------------------------%
    for i = 1 : check_consistency
        var_ID_pos = find(COEFF(:,i) > 0.6);
        var_ID_neg = find(COEFF(:,i) < -0.6);
        variables_pos = {};
        variables_neg = {};
        var_ID_pos_low = find(COEFF(:,i) >= 0.3 & COEFF(:,i) < 0.6);
        var_ID_neg_low = find(COEFF(:,i) < -0.3 & COEFF(:,i) > -0.6);
        variables_pos_low = {};
        variables_neg_low = {};
        varName = us_dat_name(var_ind); % extract name of active variables
        
        % find names of variables onto which PC have positive loadings
        %------------------------------------------------------------------
        if isempty(var_ID_pos) == 0                   % check the component
            num = size(var_ID_pos);                   % has high positive 
                                                      % loadings
            if num(1) > 1  
                variables_pos = cell(1,2*num(1)-1);
                j = 1;
                while j <= 2*num(1)-1
                    if j/2 == ceil(j/2)               % select pair number
                        variables_pos(j) = {', '};
                    else
                        variables_pos(j) = varName(var_ID_pos((j/2)+0.5));
                    end
                    j = j + 1;
                end   
            else
                variables_pos  = varName(var_ID_pos(1));
            end
        else
        end 
        
        % find names of variables onto which PC have negative loadings
        %------------------------------------------------------------------
        if isempty(var_ID_neg) == 0                   % check the component 
            num = size(var_ID_neg);                   % has negative load 
                                                      
            if num(1) > 1  
                variables_neg = cell(1,2*num(1)-1);
                
                j = 1;
                while j <= 2*num(1)-1
                    if j/2 == ceil(j/2)               % select pair number
                        variables_neg(j) = {', '};
                    else
                        variables_neg(j) = varName(var_ID_neg((j/2)+0.5));
                    end
                    j = j + 1;
                end      
            else
                variables_neg  = varName(var_ID_neg(1));
            end
        else
        end 
        % find names of variables onto which PC have low positive loadings
        %------------------------------------------------------------------
        if isempty(var_ID_pos_low) == 0           % check the component
            num = size(var_ID_pos_low);           % has positive load
            if num(1) > 1  
                variables_pos_low = cell(1,2*num(1)-1);
                j = 1;
                while j <= 2*num(1)-1
                    if j/2 == ceil(j/2)               % select pair number
                        variables_pos_low(j) = {', '};
                    else
                        variables_pos_low(j) = varName(var_ID_pos_low((j/2)+0.5));
                    end
                        j = j + 1;
                end
            else
                variables_pos_low  = varName(var_ID_pos_low(1));
            end
        else
        end
        % find names of variables onto which PC have low negative loadings
        %-----------------------------------------------------------------
        if isempty(var_ID_neg_low) == 0               % check the component
            num = size(var_ID_neg_low);               % has positive load
            if num(1) > 1  
                variables_neg_low = cell(1,2*num(1)-1);
                j = 1;
                while j <= 2*num(1)-1
                    if j/2 == ceil(j/2)               % select pair number
                        variables_neg_low(j) = {', '};
                    else
                        variables_neg_low(j) = varName(var_ID_neg_low((j/2)+0.5));
                    end
                        j = j + 1;
                end
            else
                variables_neg_low = varName(var_ID_neg_low(1));
            end
        else
        end
        % evaluate loadings
        poss1 = isempty(cell2mat(variables_pos));
        poss2 = isempty(cell2mat(variables_pos_low));
        poss3 = isempty(cell2mat(variables_neg));
        poss4 = isempty(cell2mat(variables_neg_low));
        
        if poss1 == 0 && poss2 == 0 && poss3 == 0 && poss4 == 0 % case1 [1 1 1 1]
            prompt = ['Component ',num2str(i),...
                ' has HIGH positive (>0.6) loadings on the variable(s): ',...
                variables_pos,', LOW positive (>0.3) loadings on the variable(s): ',...
                variables_pos_low,', HIGH negative (<-0.6) loadings in the variable(s): ',...
                variables_neg,', and LOW negative (<-0.3) loadings on the variable(s): ',...
                variables_neg_low,'. What the component name should be?'];
        elseif poss1 == 0 && poss2 == 0 && poss3 == 0 && poss4 == 1 % case2 [1 1 1 0]
            prompt = ['Component ',num2str(i),...
                ' has HIGH positive (>0.6) loadings on the variable(s): ',...
                variables_pos,', LOW positive (>0.3) loadings on the variable(s): ',...
                variables_pos_low,', and HIGH negative (<-0.6) loadings in the variable(s): ',...
                variables_neg,'. What the component name should be?']; 
        elseif poss1 == 0 && poss2 == 0 && poss3 == 1 && poss4 == 1 % case3 [1 1 0 0]
            prompt = ['Component ',num2str(i),...
                ' has HIGH positive (>0.6) loadings on the variable(s): ',...
                variables_pos,', and LOW positive (>0.3) loadings on the variable(s): ',...
                variables_pos_low,'. What the component name should be?']; 
        elseif poss1 == 0 && poss2 == 1 && poss3 == 1 && poss4 == 1 % case4 [1 0 0 0]
            prompt = ['Component ',num2str(i),...
                ' has only HIGH positive (>0.6) loadings on the variable(s): ',...
                variables_pos,'. What the component name should be?']; 
        elseif poss1 == 0 && poss2 == 0 && poss3 == 1 && poss4 == 0 % case5 [1 1 0 1]
            prompt = ['Component ',num2str(i),...
                ' has HIGH positive (>0.6) loadings on the variable(s): ',...
                variables_pos,', LOW positive (>0.3) loadings on the variable(s): ',...
                variables_pos_low,', and LOW negative (<-0.3) loadings on the variable(s): ',...
                variables_neg_low,'. What the component name should be?'];
        elseif poss1 == 0 && poss2 == 1 && poss3 == 1 && poss4 == 0 % case6 [1 0 0 1]
            prompt = ['Component ',num2str(i),...
                ' has high (>0.6) positive loadings on the variable(s): ',...
                variables_pos,', and LOW negative (<-0.3) loadings on the variable(s): ',...
                variables_neg_low,'. What the component name should be?'];
        elseif poss1 == 0 && poss2 == 1 && poss3 == 0 && poss4 == 1 % case7 [1 0 1 0]
            prompt = ['Component ',num2str(i),...
                ' has HIGH positive (>0.6) loadings on the variable(s): ',...
                variables_pos,', and HIGH negative (<-0.6) loadings in the variable(s): ',...
                variables_neg,'. What the component name should be?'];
        elseif poss1 == 1 && poss2 == 0 && poss3 == 0 && poss4 == 0 % case8 [0 1 1 1]
            prompt = ['Component ',num2str(i),...
                ' has LOW positive (>0.3) loadings on the variable(s): ',...
                variables_pos_low,', HIGH negative (<-0.6) loadings in the variable(s): ',...
                variables_neg,', and LOW negative (<-0.3) loadings on the variable(s): ',...
                variables_neg_low,'. What the component name should be?'];
        elseif poss1 == 1 && poss2 == 1 && poss3 == 0 && poss4 == 0 % case9 [0 0 1 1]
            prompt = ['Component ',num2str(i),...
                ' has HIGH negative (<-0.6) loadings in the variable(s): ',...
                variables_neg,', and LOW negative (<-0.3) loadings on the variable(s): ',...
                variables_neg_low,'. What the component name should be?'];
        elseif poss1 == 1 && poss2 == 1 && poss3 == 1 && poss4 == 0 % case10 [0 0 0 1]
            prompt = ['Component ',num2str(i),...
                ' has only LOW negative (<-0.3) loadings on the variable(s): ',...
                variables_neg_low,'. What the component name should be?'];
        elseif poss1 == 1 && poss2 == 1 && poss3 == 0 && poss4 == 1 % case11 [0 0 1 0]
            prompt = ['Component ',num2str(i),...
                ' has only HIGH negative (<-0.6) loadings on the variable(s): ',...
                variables_neg,'. What the component name should be?'];
        elseif poss1 == 1 && poss2 == 0 && poss3 == 1 && poss4 == 1 % case11 [0 1 0 0]
            prompt = ['Component ',num2str(i),...
                ' has only LOW positive (>0.3) loadings on the variable(s): ',...
                variables_pos_low,'. What the component name should be?'];
        elseif poss1 == 1 && poss2 == 0 && poss3 == 0 && poss4 == 1 % case12 [0 1 1 0]
            prompt = ['Component ',num2str(i),...
                ' has LOW positive (>0.3) loadings in the variable(s): ',...
                variables_pos_low,', and HIGH negative (<-0.6) loadings on the variable(s): ',...
                variables_neg,'. What the component name should be?'];
        elseif poss1 == 1 && poss2 == 0 && poss3 == 1 && poss4 == 0 % case13 [0 1 0 1]
            prompt = ['Component ',num2str(i),...
                ' has LOW positive (>0.3) loadings in the variable(s): ',...
                variables_pos_low,', and LOW negative (<-0.3) loadings on the variable(s): ',...
                variables_neg_low,'. What the component name should be?'];
        elseif poss1 == 0 && poss2 == 1 && poss3 == 0 && poss4 == 0 % case14 [1 0 1 1]
            prompt = ['Component ',num2str(i),...
                ' has HIGH positive (>0.6)loadings on the variable(s): ',...
                variables_pos,', HIGH negative (<-0.6) loadings on the variable(s): ',...
                variables_neg,' and LOW negative (<-0.3) loadings on the variable(s): ',...
                variables_neg_low,'. What the component name should be?'];
        end
        component_name(i) = inputdlg(cell2mat(prompt),'Set component name',1);   
        pause(2); 
        
    end
    %-------------------------%
    % CREATE PCA MAPS Z-VALUES
    %-------------------------% 
    [row_PCA,col_PCA] = size(cell2mat(data_points_land(1)));
    scores = cell2mat(standard_scores);
    samples = size(scores);
    for i = 1 : check_consistency            
        PC_val = zeros(samples(1),1);
        for j = 1 : samples(1)
            PC_val(j) = sum(scores(j,:)./COEFF(:,i)');
        end
        PC_scores_nan = NaN*(ones(row_PCA,col_PCA));
        PC_scores_nan(data_PCA_ind) = PC_val;
        PC_scores(i) = {PC_scores_nan};
    end  
else
    h1 = warndlg({'Too few uncorrelated components.',...
                  'Increase the number of variables',...
                  'or choice other datasets to     ',...
                  'improve statistical performance!'});
    PC_scores = 0;
    pause(3);
    delete(h1)
end
end