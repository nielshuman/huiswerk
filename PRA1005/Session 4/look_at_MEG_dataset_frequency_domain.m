%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all, clear all
data_directory = 'C:\Users\mark.roberts\OneDrive\teaching\PRA1005\2025\Course Material\Session 4\MEG output'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cfg              = [];
cfg.output       = 'pow';
cfg.channel      = 'MEG';
cfg.method       = 'mtmconvol';
cfg.taper        = 'dpss';
cfg.keeptrials=   'yes';
cfg.tapsmofrq     = 6;
cfg.foi          = 20:2:80;                         % analysis 2 to 30 Hz in steps of 2 Hz
cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;    % length of time window = 0.5 sec
cfg.toi        = -1:0.1:2;
for J=1:5
    if J==1
        TFRfilename=['TFR_CND_1'];
        if exist([data_directory TFRfilename '.mat'])~=2
            filename=['timelock_CND_1'];
            load([data_directory filename]);
            TFR_dpss_1 = ft_freqanalysis(cfg, timelock_1);
            save([data_directory TFRfilename],'TFR_dpss_1');
            clear timelock_1
        else
            load([  data_directory TFRfilename]);
        end
    elseif J==2
        TFRfilename=['TFR_CND_2'];
        if  exist([data_directory TFRfilename '.mat'])~=2
            filename=['timelock_CND_2'];
            load([  data_directory filename]);
            TFR_dpss_2 = ft_freqanalysis(cfg, timelock_2);
            save([data_directory TFRfilename],'TFR_dpss_2');
            clear timelock_2
        else
            load([  data_directory TFRfilename]);
        end
    elseif J==3
        TFRfilename=['TFR_CND_3'];
        if exist([  data_directory TFRfilename '.mat'])~=2
            filename=['timelock_CND_3'];
            load([  data_directory filename]);
            TFR_dpss_3 = ft_freqanalysis(cfg, timelock_3);
            save([  data_directory TFRfilename],'TFR_dpss_3');
            clear timelock_3
        else
            load([  data_directory TFRfilename]);
        end
    elseif J==4
        TFRfilename=['TFR_CND_4'];
        if exist([  data_directory TFRfilename '.mat'])~=2
            filename=['timelock_CND_4'];
            load([  data_directory filename]);
            TFR_dpss_4 = ft_freqanalysis(cfg, timelock_4);
            save([  data_directory TFRfilename],'TFR_dpss_4');
            clear timelock_4
        else
            load([  data_directory TFRfilename]);
        end
    elseif J==5
        TFRfilename=['TFR_CND_5'];
        if  exist([  data_directory TFRfilename '.mat'])~=2
            filename=['timelock_CND_5'];
            load([  data_directory filename]);
            TFR_dpss_5 = ft_freqanalysis(cfg, timelock_5);
            save([  data_directory TFRfilename],'TFR_dpss_5');
            clear timelock_5
        else
            load([ data_directory TFRfilename]);
        end
    end
end
whos


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cfg = [];
cfg.baseline     = [-0.5 -0.1];
cfg.baselinetype = 'relchange';
cfg.showlabels   = 'yes';
cfg.layout       = 'CTF275.lay';
cfg.showoutline ='yes';
figure
ft_multiplotTFR(cfg, TFR_dpss_5);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
example_channel_name=[{'MRC17', 'MRF66', 'MRF67', 'MRP57', 'MRT13', 'MRT14', 'MRT23', 'MRT24'}] %% these are not very good channels to choose!
example_channel=find(ismember(TFR_dpss_5.label,example_channel_name))
if length(example_channel)==1
    example_channel=[example_channel example_channel];
end
cfg = [];
cfg.xlim = [0.75 1.5]; %%% set the time you want to plot
cfg.ylim = [35 65];%%% set the frequencies you want to plot
cfg.baseline     = [-1 -0.25]; %%% this time is used for 'no stimulus data'


cfg.layout = 'CTF275.lay';
cfg.interactive = 'no';
cfg.showoutline = 'yes';
cfg.showlabels='yes';
hold_cfg=cfg;
cfg.baselinetype = 'relchange';
cfg.colorbar           = 'no';
cfg.style    ='straight';
cfg.marker ='off';
cfg.highlight   =example_channel;
cfg.highlightsymbol='.';
cfg2=cfg;
cfg2.xlim = [-1 1.7];
cfg2.ylim = [20 90];
cfg2.channel=example_channel;


figure;
screen_size = get(0, 'ScreenSize');screen_size(2)=screen_size(2)/2;
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4) ] ); %set to scren size
set(gcf,'PaperPositionMode','auto') %set paper pos for printing

Xlim=[0 0.5];window_width=0.02;
for CND=[1:5]
    subplot(2,5,CND)
    if CND==1
        subplot(2,5,CND)
        ft_topoplotTFR(cfg, TFR_dpss_1)
        subplot(2,5,CND+5)
        ft_singleplotTFR(cfg2, TFR_dpss_1); hold on
        [baseline_corrected_1] = ft_freqbaseline(cfg2, TFR_dpss_1);
        title([ ])
    elseif CND==2
        ft_topoplotTFR(cfg, TFR_dpss_2)
        subplot(2,5,CND+5)
        ft_singleplotTFR(cfg2, TFR_dpss_2); hold on
        [baseline_corrected_2] = ft_freqbaseline(cfg2, TFR_dpss_2);
        title([ ])
    elseif CND==3
        ft_topoplotTFR(cfg, TFR_dpss_3)
        subplot(2,5,CND+5)
        ft_singleplotTFR(cfg2, TFR_dpss_3); hold on
        [baseline_corrected_3] = ft_freqbaseline(cfg2, TFR_dpss_3);
        title([TFR_dpss_5.label{example_channel}])
    elseif CND==4
        ft_topoplotTFR(cfg, TFR_dpss_4)
        subplot(2,5,CND+5)
        ft_singleplotTFR(cfg2, TFR_dpss_4); hold on
        [baseline_corrected_4] = ft_freqbaseline(cfg2, TFR_dpss_4);
        title([ ])
    elseif CND==5
        ft_topoplotTFR(cfg, TFR_dpss_5)
        subplot(2,5,CND+5)
        ft_singleplotTFR(cfg2, TFR_dpss_5); hold on
        [baseline_corrected_5] = ft_freqbaseline(cfg2, TFR_dpss_5);
        title([ ])
    end
    subplot(2,5,CND)
    title(['Condition number = '  num2str(CND)])
    drawnow
end
for J=1:5
    subplot(2,5,J);
    LIM(J,:)=get(gca,'clim');
end
for J=1:5
    subplot(2,5,J);
    set(gca,'clim',[min(LIM(:)) max(LIM(:))/1.5]); box off
end
for J=1:5
    subplot(2,5,J+5);
    LIM(J,:)=get(gca,'clim');
end
for J=1:5
    subplot(2,5,J+5);
    set(gca,'clim',[min(LIM(:)) max(LIM(:))/1.5],'tickdir','out'); box off
    plot([hold_cfg.xlim(1) hold_cfg.xlim(1) hold_cfg.xlim(2) hold_cfg.xlim(2) hold_cfg.xlim(1)],[hold_cfg.ylim(1) hold_cfg.ylim(2)  hold_cfg.ylim(2) hold_cfg.ylim(1) hold_cfg.ylim(1)],'k:')
end
set(gcf,'color','w')
saveas(gcf,[  'MEG_Figure_4.png'])


figure
plot(baseline_corrected_1.freq,squeeze(nanmean(nanmean(nanmean(baseline_corrected_1.powspctrm(:,example_channel,:,find(baseline_corrected_5.time>0.3)),4),2))),'linewidth',4,'color',[0 0 0]+0.8);hold on
plot(baseline_corrected_1.freq,squeeze(nanmean(nanmean(nanmean(baseline_corrected_2.powspctrm(:,example_channel,:,find(baseline_corrected_5.time>0.3)),4),2))),'linewidth',4,'color',[0 0 0]+0.6);
plot(baseline_corrected_1.freq,squeeze(nanmean(nanmean(nanmean(baseline_corrected_3.powspctrm(:,example_channel,:,find(baseline_corrected_5.time>0.3)),4),2))),'linewidth',4,'color',[0 0 0]+0.4);
plot(baseline_corrected_1.freq,squeeze(nanmean(nanmean(nanmean(baseline_corrected_4.powspctrm(:,example_channel,:,find(baseline_corrected_5.time>0.3)),4),2))),'linewidth',4,'color',[0 0 0]+0.2);
plot(baseline_corrected_1.freq,squeeze(nanmean(nanmean(nanmean(baseline_corrected_5.powspctrm(:,example_channel,:,find(baseline_corrected_5.time>0.3)),4),2))),'linewidth',4,'color',[0 0 0]);
xlabel('somthing');ylabel('change in somthing from baseline');legend([{'one'};{'two'};{'three'};{'four'};{'five'}])
set(gcf,'color','w'), box off
set(gca,'linewidth',2,'tickdir','out'); box off
screen_size = get(0, 'ScreenSize');screen_size(2)=screen_size(2)/2;
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4) ] ); %set to scren size
set(gcf,'PaperPositionMode','auto') %set paper pos for printing
saveas(gcf,[  'MEG_Figure_3.png'])

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output_filename=[  'output_data'];
load(output_filename)

%%%% combine the data in the baseline period from all conditions
%%% Average three times, over selected channels, frequencies and time
output_data.gamma_CND1=squeeze(nanmean(nanmean(nanmean(TFR_dpss_1.powspctrm(:,example_channel,find(TFR_dpss_4.freq>cfg.ylim(1) & TFR_dpss_4.freq<cfg.ylim(2)),find(TFR_dpss_4.time>cfg.xlim(1) & TFR_dpss_4.time<cfg.xlim(2))),3),4),2))';
output_data.gamma_CND2=squeeze(nanmean(nanmean(nanmean(TFR_dpss_2.powspctrm(:,example_channel,find(TFR_dpss_4.freq>cfg.ylim(1) & TFR_dpss_4.freq<cfg.ylim(2)),find(TFR_dpss_4.time>cfg.xlim(1) & TFR_dpss_4.time<cfg.xlim(2))),3),4),2))';
output_data.gamma_CND3=squeeze(nanmean(nanmean(nanmean(TFR_dpss_3.powspctrm(:,example_channel,find(TFR_dpss_4.freq>cfg.ylim(1) & TFR_dpss_4.freq<cfg.ylim(2)),find(TFR_dpss_4.time>cfg.xlim(1) & TFR_dpss_4.time<cfg.xlim(2))),3),4),2))';
output_data.gamma_CND4=squeeze(nanmean(nanmean(nanmean(TFR_dpss_4.powspctrm(:,example_channel,find(TFR_dpss_4.freq>cfg.ylim(1) & TFR_dpss_4.freq<cfg.ylim(2)),find(TFR_dpss_4.time>cfg.xlim(1) & TFR_dpss_4.time<cfg.xlim(2))),3),4),2))';
output_data.gamma_CND5=squeeze(nanmean(nanmean(nanmean(TFR_dpss_5.powspctrm(:,example_channel,find(TFR_dpss_4.freq>cfg.ylim(1) & TFR_dpss_4.freq<cfg.ylim(2)),find(TFR_dpss_4.time>cfg.xlim(1) & TFR_dpss_4.time<cfg.xlim(2))),3),4),2))';


%%%%%% calculate power in the baseline period. Average TFR in the selected time window and frequency window. Gives you one number per trial
output_data.gamma_CND0=[                       squeeze(nanmean(nanmean(nanmean(TFR_dpss_1.powspctrm(:,example_channel,find(TFR_dpss_1.freq>cfg.ylim(1) & TFR_dpss_1.freq<cfg.ylim(2)),find(TFR_dpss_1.time>cfg.baseline(1) & TFR_dpss_1.time<cfg.baseline(2))),3),4),2))];
output_data.gamma_CND0=[output_data.gamma_CND0;squeeze(nanmean(nanmean(nanmean(TFR_dpss_2.powspctrm(:,example_channel,find(TFR_dpss_1.freq>cfg.ylim(1) & TFR_dpss_1.freq<cfg.ylim(2)),find(TFR_dpss_1.time>cfg.baseline(1) & TFR_dpss_1.time<cfg.baseline(2))),3),4),2))];
output_data.gamma_CND0=[output_data.gamma_CND0;squeeze(nanmean(nanmean(nanmean(TFR_dpss_3.powspctrm(:,example_channel,find(TFR_dpss_1.freq>cfg.ylim(1) & TFR_dpss_1.freq<cfg.ylim(2)),find(TFR_dpss_1.time>cfg.baseline(1) & TFR_dpss_1.time<cfg.baseline(2))),3),4),2))];
output_data.gamma_CND0=[output_data.gamma_CND0;squeeze(nanmean(nanmean(nanmean(TFR_dpss_4.powspctrm(:,example_channel,find(TFR_dpss_1.freq>cfg.ylim(1) & TFR_dpss_1.freq<cfg.ylim(2)),find(TFR_dpss_1.time>cfg.baseline(1) & TFR_dpss_1.time<cfg.baseline(2))),3),4),2))];
output_data.gamma_CND0=[output_data.gamma_CND0;squeeze(nanmean(nanmean(nanmean(TFR_dpss_5.powspctrm(:,example_channel,find(TFR_dpss_1.freq>cfg.ylim(1) & TFR_dpss_1.freq<cfg.ylim(2)),find(TFR_dpss_1.time>cfg.baseline(1) & TFR_dpss_1.time<cfg.baseline(2))),3),4),2))]';
save(output_filename,'output_data')
    
figure
AUC(1)=My_ROC_Function(output_data.gamma_CND0,output_data.gamma_CND1)
AUC(2)=My_ROC_Function(output_data.gamma_CND0,output_data.gamma_CND2)
AUC(3)=My_ROC_Function(output_data.gamma_CND0,output_data.gamma_CND3)
AUC(4)=My_ROC_Function(output_data.gamma_CND0,output_data.gamma_CND4)
AUC(5)=My_ROC_Function(output_data.gamma_CND0,output_data.gamma_CND5)


subplot(2,1,2)
plot(AUC)

