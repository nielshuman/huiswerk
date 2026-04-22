%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all, clear all
data_directory=['C:\Users\mark\surfdrive\Matlab_practical2\'];
% load([data_directory 'downsampled_data.mat'])
% whos
% 
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cfg=[];
% cfg.resamplefs =300;
% downsampled_data= ft_resampledata(cfg, data_iccleaned_thorough);
% whos
% clear data_iccleaned_thorough
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir([data_directory 'output']) %% this makes a new folder in your directory. 

load([data_directory 'downsampled_data.mat'])
%%
for CND=[2 4 6 8 16]
    cfg=[];cfg.vartrllength =2;cfg.keeptrials='yes';
    cfg.trials=find(downsampled_data.trialinfo==CND);
    cfg.demean          = 'yes';
    cfg.baselinewindow  = [-0.5 0];
    if CND==2
        filename=['timelock_CND_1'];
        timelock_1=ft_timelockanalysis(cfg,downsampled_data);
        save([data_directory 'output/' filename],'timelock_1');
    elseif CND==4
        filename=['timelock_CND_2'];
        timelock_2=ft_timelockanalysis(cfg,downsampled_data);
        save([data_directory 'output/' filename],'timelock_2');
    elseif CND==6
        filename=['timelock_CND_3'];
        timelock_3=ft_timelockanalysis(cfg,downsampled_data);
        save([data_directory 'output/' filename],'timelock_3');
    elseif CND==8
        filename=['timelock_CND_4'];
        timelock_4=ft_timelockanalysis(cfg,downsampled_data);
        save([data_directory 'output/' filename],'timelock_4');
    elseif CND==16
        filename=['timelock_CND_5'];
        timelock_5=ft_timelockanalysis(cfg,downsampled_data);
        save([data_directory 'output/' filename],'timelock_5');
    end
end
clear downsampled_data
winopen([data_directory 'output'])%% this opens the folder in windows explorer - handy!



