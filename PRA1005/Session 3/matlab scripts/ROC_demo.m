close all, clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mean_noise=4;% the mean of the noise distribution
signal_offset=[0.5:0.5:3];% the level of signal added to the noise distribution
C_all=mean([mean_noise mean(signal_offset+mean_noise)])+[-1 0 1]; %Criterion levels, the centerpoint between noise and signal + noise +- 1 standard deviation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
col=colormap(jet(length(signal_offset)));
markers=[{'o'},{'square'},{'^'},{'diamond'},{'+'},{'x'},{'v'},{'<'},{'>'},{'.'},{'*'}];
markers=[markers markers markers];
ROC=[];x = [0:.1:13];

for S=1:length(signal_offset)
    subplot(2,2,1)
    %%%% make some data with a normal distribution and a mean of the mean_noise
    NoiseDist= normpdf(x,mean_noise,1); %for a smooth plot of the distribution
    plot(x,NoiseDist,'linewidth',4,'color',[0.1 0.1 0.1]); hold on %noise in black
    NoiseDist=randn(1,10000)+mean_noise;NoiseDist(find(NoiseDist<0))=[];%now make a distribution of 10000 'noise' data points
    [n,~]=hist(NoiseDist,x);
    
    %%%% make another set of data with a higher mean
    offset=mean_noise+signal_offset(S);
    SignalDist = normpdf(x,offset,1);%a smooth signal+noise distribution
    plot(x,SignalDist,'-','color',col(S,:),'linewidth',4); hold on%plot this in color
    SignalDist=randn(1,10000)+offset;SignalDist(find(SignalDist<0))=[];%now make a distribution of 1000 'signal+noise' data points
    [n,~]=hist(SignalDist,x);
    % set up the figure
    box off, set(gcf,'color','w')
    set(gca,'fontsize',16,'tickdir','out','linewidth',2)
    xlabel('Response','fontsize',16),    ylabel('Proportion count','fontsize',16)
    title('Signal Distribution','fontsize',16)
    txtdata=[{'Noise'};{'Stimulus + Noise'}];
    
    %%% plot the performance for three critera
    clc; count=0;col2=[0 0.7 0;1 0 0;0 0 1];
    for J=C_all
        count=count+1;
        txtdata=[txtdata; {['Criterion ' num2str(count)]}];

        subplot(2,2,1)
        plot([J J],[0 .4],'-','linewidth',2,'color',col2(count,:)); hold on
        
        subplot(2,2,2)
        Hit_rate=length(find(SignalDist>J))/length(SignalDist); % hit rate
        False_alarm_rate=length(find(NoiseDist>J))/length(NoiseDist);% fale alarm rate
        if Hit_rate==1,Hit_rate=0.999;end, if False_alarm_rate==1,False_alarm_rate=0.999;end%make sure that the rates are between 0 and 1
        if Hit_rate==0,Hit_rate=0.001;end, if False_alarm_rate==0,False_alarm_rate=0.001;end

        plot(False_alarm_rate,Hit_rate,markers{S},'color',col2(count,:),'markersize',10,'linewidth',2); hold on
        D(S,count)=norminv(Hit_rate)-norminv(False_alarm_rate); %% D' is the differenc between the z scored hit and FA rate
        C(S,count)=-(norminv(Hit_rate)+norminv(False_alarm_rate))/2;%% critera is the mean of the two
        
        subplot(2,2,3)
        plot(signal_offset(S),D(S,count),markers{S},'color',col2(count,:),'markersize',10,'linewidth',2); hold on
        subplot(2,2,4)
        plot(signal_offset(S),C(S,count),markers{S},'color',col2(count,:),'markersize',10,'linewidth',2); hold on
    end
    subplot(2,2,1)
    legend(txtdata,'fontsize',16)
    
    %%% test all possable critera to calculate the ROC curve
    criterions=sort([NoiseDist SignalDist],'descend');%go through every data point as a possable criterion
    for i=1:length(criterions)
        Hit_rate(i)=length(find(SignalDist>criterions(i)))/length(SignalDist); % hit rate
        False_alarm_rate(i)=length(find(NoiseDist>criterions(i)))/length(NoiseDist);% fale alarm rate
    end
    Hit_rate=[0 Hit_rate 1];        False_alarm_rate=[0 False_alarm_rate 1]; %make sure ROC curve starts at 0 and ends at 1
    subplot(2,2,2)
    xlabel('FA rate');    ylabel('Hit rate')
    axis square;    box off
    set(gca,'fontsize',16,'tickdir','out','linewidth',2,'xlim',[0 1],'ylim',[0 1],'xtick',[0:0.2:1],'ytick',[0:0.2:1])
    plot([0,1],[0 1],':','linewidth',2,'color',[0.5 0.5 0.5])%chance level
    plot(False_alarm_rate,Hit_rate,'-','linewidth',2,'color',col(S,:))
    
    ROC(S) = trapz(False_alarm_rate, Hit_rate);%the area under the curve
    title(['ROC curve AUC = ' num2str(ROC,2)],'fontsize',16)
    xlabel('FA rate')
    ylabel('Hit rate')
    axis square
    box off
    set(gca,'fontsize',16,'tickdir','out','linewidth',2,'xlim',[0 1],'ylim',[0 1],'xtick',[0:0.2:1],'ytick',[0:0.2:1])
    
     subplot(2,2,3)
    xlabel('stimulus strength');    ylabel("D'");    box off
    set(gca,'fontsize',16,'tickdir','out','linewidth',2),grid on
    
    subplot(2,2,4)
    xlabel('stimulus strength');    ylabel("C");    box off
    set(gca,'fontsize',16,'tickdir','out','linewidth',2),grid on
end
for J=1:3%plot the D and C data
    subplot(2,2,3)
    plot(signal_offset,D(:,J),'-','color',col2(J,:),'linewidth',2)
    subplot(2,2,4)
    plot(signal_offset,C(:,J),'-','color',col2(J,:),'linewidth',2); hold on
end
%%
%% repeat the model, but with criteria tuned to each stimulus strength
figure

ROC=[];
for S=1:length(signal_offset)
    subplot(2,2,1)
    %%%% make some data with a normal distribution and a mean of the mean_noise
    NoiseDist= normpdf(x,mean_noise,1); %for a smooth plot of the distribution
    plot(x,NoiseDist,'linewidth',4,'color',[0.1 0.1 0.1]); hold on %noise in black
    NoiseDist=randn(1,10000)+mean_noise;NoiseDist(find(NoiseDist<0))=[];%now make a distribution of 10000 'noise' data points
    [n,~]=hist(NoiseDist,x);
    
    %%%% make another set of data with a higher mean
    offset=mean_noise+signal_offset(S);
    SignalDist = normpdf(x,offset,1);%a smooth signal+noise distribution
    plot(x,SignalDist,'-','color',col(S,:),'linewidth',4); hold on%plot this in color
    SignalDist=randn(1,10000)+offset;SignalDist(find(SignalDist<0))=[];%now make a distribution of 1000 'signal+noise' data points
    [n,~]=hist(SignalDist,x);
    % set up the figure
    box off, set(gcf,'color','w')
    set(gca,'fontsize',16,'tickdir','out','linewidth',2)
    xlabel('Response','fontsize',16),    ylabel('Proportion count','fontsize',16)
    title('Signal Distribution','fontsize',16)
    txtdata=[{'Noise'};{'Stimulus + Noise'}];
    
    %%% plot the performance for three critera
    clc; count=0;col2=[0 0.7 0;1 0 0;0 0 1];
    for J=mean([mean_noise signal_offset(S)+mean_noise])+[-1 0 1]
        count=count+1;
        txtdata=[txtdata; {['Criterion ' num2str(count)]}];

        subplot(2,2,1)
        plot([J J],[0 .4],'-','linewidth',2,'color',col2(count,:)); hold on
        
        subplot(2,2,2)
        Hit_rate=length(find(SignalDist>J))/length(SignalDist); % hit rate
        False_alarm_rate=length(find(NoiseDist>J))/length(NoiseDist);% fale alarm rate
        if Hit_rate==1,Hit_rate=0.999;end, if False_alarm_rate==1,False_alarm_rate=0.999;end%make sure that the rates are between 0 and 1
        if Hit_rate==0,Hit_rate=0.001;end, if False_alarm_rate==0,False_alarm_rate=0.001;end

        plot(False_alarm_rate,Hit_rate,markers{S},'color',col2(count,:),'markersize',10,'linewidth',2); hold on
        D(S,count)=norminv(Hit_rate)-norminv(False_alarm_rate); %% D' is the differenc between the z scored hit and FA rate
        C(S,count)=-(norminv(Hit_rate)+norminv(False_alarm_rate))/2;%% critera is the mean of the two
        
        subplot(2,2,3)
        plot(signal_offset(S),D(S,count),markers{S},'color',col2(count,:),'markersize',10,'linewidth',2); hold on
        subplot(2,2,4)
        plot(signal_offset(S),C(S,count),markers{S},'color',col2(count,:),'markersize',10,'linewidth',2); hold on
    end
    subplot(2,2,1)
    legend(txtdata,'fontsize',16)
    
    %%% test all possable critera to calculate the ROC curve
    criterions=sort([NoiseDist SignalDist],'descend');%go through every data point as a possable criterion
    for i=1:length(criterions)
        Hit_rate(i)=length(find(SignalDist>criterions(i)))/length(SignalDist); % hit rate
        False_alarm_rate(i)=length(find(NoiseDist>criterions(i)))/length(NoiseDist);% fale alarm rate
    end
    Hit_rate=[0 Hit_rate 1];        False_alarm_rate=[0 False_alarm_rate 1]; %make sure ROC curve starts at 0 and ends at 1
    subplot(2,2,2)
    xlabel('FA rate');    ylabel('Hit rate')
    axis square;    box off
    set(gca,'fontsize',16,'tickdir','out','linewidth',2,'xlim',[0 1],'ylim',[0 1],'xtick',[0:0.2:1],'ytick',[0:0.2:1])
    plot([0,1],[0 1],':','linewidth',2,'color',[0.5 0.5 0.5])%chance level
    plot(False_alarm_rate,Hit_rate,'-','linewidth',2,'color',col(S,:))
    
    ROC(S) = trapz(False_alarm_rate, Hit_rate);%the area under the curve
    title(['ROC curve AUC = ' num2str(ROC,2)],'fontsize',16)
    xlabel('FA rate')
    ylabel('Hit rate')
    axis square
    box off
    set(gca,'fontsize',16,'tickdir','out','linewidth',2,'xlim',[0 1],'ylim',[0 1],'xtick',[0:0.2:1],'ytick',[0:0.2:1])
    
     subplot(2,2,3)
    xlabel('stimulus strength');    ylabel("D'");    box off
    set(gca,'fontsize',16,'tickdir','out','linewidth',2),grid on
    
    subplot(2,2,4)
    xlabel('stimulus strength');    ylabel("C");    box off
    set(gca,'fontsize',16,'tickdir','out','linewidth',2),grid on
end
for J=1:3
    subplot(2,2,3)
    plot(signal_offset,D(:,J),'-','color',col2(J,:),'linewidth',2)
    subplot(2,2,4)
    plot(signal_offset,C(:,J),'-','color',col2(J,:),'linewidth',2); hold on
end