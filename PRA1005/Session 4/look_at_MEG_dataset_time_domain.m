%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all, clear all,clc


addpath(genpath('C:\Users\mark.roberts\OneDrive\teaching\PRA1005\2026\Course Material\Session 4'))% set the correct folder name
data_directory = get_MEG_folder();


filename=['timelock_CND_5']
    load([data_directory  filename]);
whos
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
example_channel=62; %% what is the name of this channel? (hint look at timelock_5.label)
example_trial=1;

subplot(2,2,1);
plot(timelock_5.time,squeeze(timelock_5.trial(example_trial,example_channel,:)),'linewidth',2)
title('one thing','fontsize',14);

subplot(2,2,2)
plot(timelock_5.time,squeeze(timelock_5.avg(example_channel,:)),'linewidth',2); hold on
title('another thing','fontsize',14);
set(gcf,'color','w')

example_channel=139; %% what is the name of this channel?
example_trial=1;
subplot(2,2,3);
plot(timelock_5.time,squeeze(timelock_5.trial(example_trial,example_channel,:)),'linewidth',2)
title('one thing','fontsize',14);

subplot(2,2,4)
plot(timelock_5.time,squeeze(timelock_5.avg(example_channel,:)),'linewidth',2)
title('another thing','fontsize',14);

%%%%%%%%%% this bit makes sure that the values on the y axis are the same for all the plots
for J=1:4
    subplot(2,2,J);
    LIM(J,:)=get(gca,'ylim');
end
for J=1:4
    subplot(2,2,J);
    set(gca,'ylim',[min(LIM(:)) max(LIM(:))])
    xlabel('numbers','fontsize',14);ylabel('numbers','fontsize',14)% here you can set the axis labels for all the plots
    set(gca,'linewidth',2,'tickdir','out'); box off
end
set(gcf,'color','w')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
cfg = [];
cfg.layout = 'CTF275.lay';
cfg.interactive = 'yes';
cfg.showoutline = 'yes';
cfg.showlabels='yes';
cfg.xlim = [-0.1 0.3];
ft_multiplotER(cfg, timelock_5)
set(gcf,'color','w')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% run this bit separatly, you only need to load all the data once
for CND=1:4
    filename=['timelock_CND_' num2str(CND)]
    load([data_directory  filename]);
end

%%
close all
example_channel_name=[{'MLP51', 'MLP52'}] %% which channel is intersting to plot? these are not very good channels to choose!
example_channel=find(ismember(timelock_1.label,example_channel_name));
X_limits=[0.08 .3];%% set the limits of the X axis to highlight the interesting part
plot(timelock_5.time,squeeze(mean(timelock_5.avg(example_channel,:),1)),'linewidth',4,'color',[0 0 0]); hold on
plot(timelock_4.time,squeeze(mean(timelock_4.avg(example_channel,:),1)),'linewidth',4,'color',[0 0 0]+0.2); hold on
plot(timelock_3.time,squeeze(mean(timelock_3.avg(example_channel,:),1)),'linewidth',4,'color',[0 0 0]+0.4)
plot(timelock_2.time,squeeze(mean(timelock_2.avg(example_channel,:),1)),'linewidth',4,'color',[0 0 0]+0.6)
plot(timelock_1.time,squeeze(mean(timelock_1.avg(example_channel,:),1)),'linewidth',4,'color',[0 0 0]+0.8)
xlabel('Time','fontsize',14);ylabel('Potential difference','fontsize',14)
title(['Channels responding to various stimuli intensities' timelock_1.label{example_channel}],'fontsize',14);
set(gca,'linewidth',2,'tickdir','out','xlim',X_limits); box off
set(gcf,'color','w')
legend([{'Contrast 1'};{'Contrast 2'};{'Contrast 3'};{'Contrast 4'};{'Contrast 5'}]);  %% numbers reflecting the actual contrasts would be good names
'fontsize',16
screen_size = get(0, 'ScreenSize');screen_size(2)=screen_size(2)/2;
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4) ] ); %set to scren size
set(gcf,'PaperPositionMode','auto') %set paper pos for printing
saveas(gcf,[ 'MEG_Figure_1.png'])


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Best_time_windows=[0.12 0.12 0.3 0.2 0.4];%% you might want to adjust this if different conditions have a different 'best time'
if length(example_channel)==1
    example_channel=[example_channel example_channel];
end

figure;
Xlim=[0 0.5];window_width=0.03;

for CND=[1:5]
    subplot(2,5,CND)
    cfg = [];
    %%%% set the color limits as the min and max of the data
    cfg.layout = 'CTF275.lay';
    cfg.interactive = 'no';
    cfg.showoutline = 'yes';
    cfg.showlabels='yes';
    cfg.xlim = [Best_time_windows(CND)-window_width Best_time_windows(CND)+window_width];
    cfg.colorbar           = 'no';
    cfg.style    ='straight';
    cfg.marker ='off';
    cfg.highlight   =example_channel;
    if CND==1
        cfg.zlim =[min(min(timelock_1.avg(1:273,:))) max(max(timelock_1.avg(1:273,:)))]./1.8;
        ft_topoplotER(cfg, timelock_1)
        subplot(2,5,CND+5)
        plot(timelock_1.time,mean(timelock_1.avg(example_channel,:))); hold on
    elseif CND==2
        cfg.zlim =[min(min(timelock_2.avg(1:273,:))) max(max(timelock_2.avg(1:273,:)))]./1.8;
        ft_topoplotER(cfg, timelock_2)
        subplot(2,5,CND+5)
        plot(timelock_2.time,mean(timelock_2.avg(example_channel,:))); hold on
    elseif CND==3
        cfg.zlim =[min(min(timelock_3.avg(1:273,:))) max(max(timelock_3.avg(1:273,:)))]./1.8;
        ft_topoplotER(cfg, timelock_3)
        subplot(2,5,CND+5)
        plot(timelock_3.time,mean(timelock_3.avg(example_channel,:))); hold on
        title([timelock_5.label{example_channel}])
    elseif CND==4
        cfg.zlim =[min(min(timelock_4.avg(1:273,:))) max(max(timelock_4.avg(1:273,:)))]./1.8;
        ft_topoplotER(cfg, timelock_4)
        subplot(2,5,CND+5)
        plot(timelock_4.time,mean(timelock_4.avg(example_channel,:))); hold on
    elseif CND==5
        cfg.zlim =[min(min(timelock_5.avg(1:273,:))) max(max(timelock_4.avg(1:273,:)))]./1.8;
        ft_topoplotER(cfg, timelock_5)
        subplot(2,5,CND+5)
        plot(timelock_5.time,mean(timelock_5.avg(example_channel,:))); hold on
    end
    subplot(2,5,CND)
    title(['Condition number = '  num2str(CND)])
end
for J=1:5
    subplot(2,5,J+5);
    LIM(J,:)=get(gca,'ylim');
end
for J=1:5
    subplot(2,5,J+5);
    set(gca,'ylim',[min(LIM(:)) max(LIM(:))],'xlim',Xlim,'tickdir','out'); box off
    plot([Best_time_windows(J)-window_width Best_time_windows(J)-window_width Best_time_windows(J)+window_width Best_time_windows(J)+window_width Best_time_windows(J)-window_width],[min(LIM(:)) max(LIM(:))  max(LIM(:)) min(LIM(:)) min(LIM(:))],'k:')
   xlabel('Time','fontsize',14);ylabel('Potential difference','fontsize',14)
    % add X and Y labels
end
set(gcf,'color','w')

screen_size = get(0, 'ScreenSize');screen_size(2)=screen_size(2)/2;
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4) ] ); %set to scren size
set(gcf,'PaperPositionMode','auto') %set paper pos for printing
saveas(gcf,['MEG_Figure_2.png'])





%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


output_filename=['output_data.mat'];
%%%% combine the data in the baseline period from all conditions
%%% Average twice times, over selected channels and time
output_data.time_CND1=-squeeze(nanmean(nanmean(timelock_1.trial(:,example_channel,find(timelock_1.time>Best_time_windows(1)-window_width & timelock_1.time<Best_time_windows(1)+window_width)),3),2))';
output_data.time_CND2=-squeeze(nanmean(nanmean(timelock_2.trial(:,example_channel,find(timelock_2.time>Best_time_windows(2)-window_width & timelock_2.time<Best_time_windows(2)+window_width)),3),2))';
output_data.time_CND3=-squeeze(nanmean(nanmean(timelock_3.trial(:,example_channel,find(timelock_3.time>Best_time_windows(3)-window_width & timelock_3.time<Best_time_windows(3)+window_width)),3),2))';
output_data.time_CND4=-squeeze(nanmean(nanmean(timelock_4.trial(:,example_channel,find(timelock_4.time>Best_time_windows(4)-window_width & timelock_4.time<Best_time_windows(4)+window_width)),3),2))';
output_data.time_CND5=-squeeze(nanmean(nanmean(timelock_5.trial(:,example_channel,find(timelock_5.time>Best_time_windows(5)-window_width & timelock_5.time<Best_time_windows(5)+window_width)),3),2))';

Baseline_time_window=-0.5;
%%%%%% calculate power in the baseline period. Average TFR in the selected time window and frequency window. Gives you one number per trial
output_data.time_CND0=[                      squeeze(nanmean(nanmean(timelock_1.trial(:,example_channel,find(timelock_1.time>Baseline_time_window-window_width & timelock_1.time<Baseline_time_window+window_width)),3),2))];
output_data.time_CND0=[output_data.time_CND0;squeeze(nanmean(nanmean(timelock_2.trial(:,example_channel,find(timelock_2.time>Baseline_time_window-window_width & timelock_2.time<Baseline_time_window+window_width)),3),2))];
output_data.time_CND0=[output_data.time_CND0;squeeze(nanmean(nanmean(timelock_3.trial(:,example_channel,find(timelock_3.time>Baseline_time_window-window_width & timelock_3.time<Baseline_time_window+window_width)),3),2))];
output_data.time_CND0=[output_data.time_CND0;squeeze(nanmean(nanmean(timelock_4.trial(:,example_channel,find(timelock_4.time>Baseline_time_window-window_width & timelock_4.time<Baseline_time_window+window_width)),3),2))];
output_data.time_CND0=-[output_data.time_CND0;squeeze(nanmean(nanmean(timelock_5.trial(:,example_channel,find(timelock_5.time>Baseline_time_window-window_width & timelock_5.time<Baseline_time_window+window_width)),3),2))]';
save(output_filename,'output_data')
xlabel('Time','FontSize',11)

%%
figure
AUC(1)=my_ROC_function(output_data.time_CND0,output_data.time_CND1)
AUC(2)=my_ROC_function(output_data.time_CND0,output_data.time_CND2)
AUC(3)=my_ROC_function(output_data.time_CND0,output_data.time_CND3)
AUC(4)=my_ROC_function(output_data.time_CND0,output_data.time_CND4)
AUC(5)=my_ROC_function(output_data.time_CND0,output_data.time_CND5)
legend([{'Condition 1'} {'Contrast 2'} {'Contrast 3'} {'Contrast 4'} {'Contrast 5'}])

subplot(2,1,2)
bar(AUC)
xlabel('Contrast','FontSize',10); ylabel('AUC','FontSize',10);
title('Sensitivity of the evoked response to stimulus onsets','FontSize',11)




%%%[{'MLO12', 'MLO22', 'MLO23', 'MLO24', 'MLO33'}];%
