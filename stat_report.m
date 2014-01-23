function stat_report(COEFF_nonrotated,COEFF,latent,explained)
% the function export a report of statistical results arranged as .xls file
xl_size = size(COEFF);
xl_col = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','AA','AB','AC','AD','AE','AF','AG','AH','AI','AJ','AK','AL','AM','AN','AO','AP','AQ','AR','AS','AT','AU','AV','AW','AX','AY','AZ','BA','BB'};
string_xl1 = (['B3:',char(xl_col(xl_size(1)+1)),num2str(xl_size(1)+2)]);
label_xl1 = 1:xl_size(1);

string00 = {'Component loadings'};
xlswrite('statistic_results.xls',string00,'results','B2:B2');
xlswrite('statistic_results.xls',COEFF_nonrotated,'results',string_xl1);
xlswrite('statistic_results.xls',label_xl1','results',['A3:','A',num2str(xl_size(1)+2)]);

string11 = {'Eigenvalues'};
xlswrite('statistic_results.xls',string11,'results',[char(xl_col(xl_size(1)+3)),'2:',char(xl_col(xl_size(1)+3)),'2']);
xlswrite('statistic_results.xls',latent,'results',[char(xl_col(xl_size(1)+3)),'3:',char(xl_col(xl_size(1)+3)),num2str(xl_size(1)+2)]);    

string22 = {'% of variance'};
xlswrite('statistic_results.xls',string22,'results',[char(xl_col(xl_size(1)+5)),'2:',char(xl_col(xl_size(1)+5)),'2']);
xlswrite('statistic_results.xls',explained,'results',[char(xl_col(xl_size(1)+5)),'3:',char(xl_col(xl_size(1)+5)),num2str(xl_size(1)+2)]);

string33 = {'Rotated component loadings'};
xlswrite('statistic_results.xls',string33,'results',[char(xl_col(xl_size(1)+7)),'2:',char(xl_col(xl_size(1)+7)),'2']);
xlswrite('statistic_results.xls',COEFF,'results',[char(xl_col(xl_size(1)+7)),'3:',char(xl_col(xl_size(1)*2+6)),num2str(xl_size(1)+2)]);
end