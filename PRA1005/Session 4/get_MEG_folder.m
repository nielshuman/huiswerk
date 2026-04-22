function [data_directory] = get_MEG_folder()
p = mfilename('fullpath');
if ispc
    data_directory=p(1:max(find(p=='\')));
    winopen(data_directory);
    data_directory=[data_directory 'MEG output\'];
    
else %is a mac
    data_directory=p(1:max(find(p=='/')));
    %macopen(data_directory);
    data_directory=[data_directory 'MEG output/'];
end
addpath(genpath(cd))

end

