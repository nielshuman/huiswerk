function [data_folder,DRIVE] = get_drive
if 1==0%exist('N:\FSE_MSP\PRA1005\','dir')
    %on athena
    data_folder='N:\FSE_MSP\PRA1005\Helper Functions Do Not Copy\Spikes material\data\';
    function_folder='N:\FSE_MSP\PRA1005\Helper Functions Do Not Copy\Spikes material\helper_functions\';
    p = mfilename('fullpath');        DRIVE=p(1:max(find(p=='\')));
else
    %on a USB stick or downloaded
    p = mfilename('fullpath');
    if ispc
        DRIVE=p(1:max(find(p=='\')));
        data_folder=[DRIVE '\data\'];
        function_folder=[DRIVE '\helper_functions\'];
    else
        DRIVE=p(1:max(find(p=='/')));
        data_folder=[DRIVE '/data/'];
        function_folder=[DRIVE '/helper_functions/'];
    end
end
addpath(function_folder);
    
    
    
end

