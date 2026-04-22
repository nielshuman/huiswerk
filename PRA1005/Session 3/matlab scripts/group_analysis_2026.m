close all force, clear all,clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%% set the directory the data is saved in %%%

p = mfilename('fullpath');
if ispc
    data_directory1=p(1:max(find(p=='\')));
    data_directory=[data_directory1 'group data\'];
    winopen(data_directory);
else %is a mac
    data_directory1=p(1:max(find(p=='/')));
    data_directory=[data_directory1 'group data/'];
    macopen(data_directory);
end
%data_directory1 % where we come from
%data_directory % dir with group data

cd(data_directory)
D=dir;
directory_list=[{data_directory}];
for d=3:length(D)
    if D(d).isdir
        directory_list=[directory_list;{[data_directory  D(d).name '/']}]
    end
end

N_CND=5% make sure this matches the number of contrast conditions you used
count_ID=[0 0 0];ID_txt=[];

f1_h=figure('Units','normalized','Position',[.1 .1 .8 .8]); % FS
for F=fliplr(1:length(directory_list))
    directory_list{F}
    D=dir(directory_list{F});
    groups=[1:10];
    for year=2026
        for G=groups
            for Participant_ID=1:100
                for J=1:3
                    GO=0;
                    % Notice that the order that the data is loaded is 1) don't miss 2) neutral 3) don't cry
                    for Repetition=1:5
                        if J==1
                            data_filename=[directory_list{F} 'constant_stimuli_DontMiss_Y_' num2str(year) '_G_' num2str(G) '_Participant_' num2str(Participant_ID) '_repetition_' num2str(Repetition) '.mat'];
                            col=[0 0.7 0]; % make a slightly darker green
                        elseif J==2
                            data_filename=[directory_list{F} 'constant_stimuli_neutral_Y_' num2str(year) '_G_' num2str(G) '_Participant_' num2str(Participant_ID) '_repetition_' num2str(Repetition) '.mat'];
                            col='r'; %the color that each bias condition is plotted
                        elseif J==3
                            data_filename=[directory_list{F} 'constant_stimuli_DontCry_Y_' num2str(year) '_G_' num2str(G) '_Participant_' num2str(Participant_ID) '_repetition_' num2str(Repetition) '.mat'];
                            col='b';
                        end
                        if exist(data_filename,'file')
                            GO=1;
                            break
                        end
                    end
                    if GO
                        load(data_filename)
                        length(unique(cnd_matrix(:,2) ))
                        if length(unique(cnd_matrix(:,2) ))==N_CND
                            count_ID(J)=count_ID(J)+1;
                            [~,display_CND]=min(abs(staircase_threshold-(unique(cnd_matrix(:,2) )) ) );
                            
                            display_CND=display_CND;
                            
                            X=[]; HIT=[]; MISS=[];
                            CNDS=unique(cnd_matrix(:,2))';
                            CNDS=CNDS./staircase_threshold;
                            %CNDS=fliplr(CNDS);%./max(CNDS));
                            n_rep=size(cnd_matrix,1)/length(CNDS)/2;
                            count=0;
                            D=[];C=[];
                            for CND=unique(cnd_matrix(:,2))'
                                count=count+1;
                                X(count)=CNDS(count);
                                HIT(count)=length(find(cnd_matrix(:,2)==CND & cnd_matrix(:,3)==1 & cnd_matrix(:,5)==1))/n_rep;
                                MISS(count)=length(find(cnd_matrix(:,2)==CND & cnd_matrix(:,3)==1 & cnd_matrix(:,5)==0))/n_rep;
                            end
                            FA=length(find(cnd_matrix(:,3)==0 & cnd_matrix(:,5)==1))/length(cnd_matrix(:,3)==0);
                            CR=length(find(cnd_matrix(:,3)==0 & cnd_matrix(:,5)==0))/length(cnd_matrix(:,3)==0);
                            
                            HIT(find(HIT==1))=0.99;      HIT(find(HIT==0))=0.01;
                            CR(find(CR==1))=0.99;        CR(find(CR==0))=0.01;
                            FA(find(FA==1))=0.99;        FA(find(FA==0))=0.01;
                            MISS(find(MISS==1))=0.99;    MISS(find(MISS==0))=0.01;
                            count=0;
                            for CND=CNDS
                                count=count+1;
                                D(count,1)=norminv(HIT(count))-norminv(FA);
                                C(count,1)=-((norminv(HIT(count))+norminv(FA))/2);
                            end
                            
                            P_correct=[FA (HIT) ];
                            X=sort([0 X*staircase_threshold]);
                            subplot(2,3,1)
                            H1(Participant_ID)=plot(X,P_correct,'.','color',[0 0 0]); hold on
                            plot(X,P_correct,'.','color',col); hold on
                            cd(data_directory1); %FS to find the Weibull
                            [pars,err]=fminsearch(@Weibull_fit,[mean(X) 1  FA],[],X,P_correct);
                            cd(data_directory); %FS and back
                            if max(HIT)>0.75
                                Thresholds(count_ID(J),J)=pars(1);
                            else
                                Thresholds(count_ID(J),J)=NaN;
                            end
                            x=min(X):0.01:max(X);
                            t=pars(1); %% threshold
                            b=pars(2); %% slope
                            g=pars(3); %% false alarm rate
                            e = 0.75;
                            
                            k = (-log( (1-e)/(1-g)))^(1/b);
                            y = 1- (1-g)*exp(- (k*x/t).^b);
                            H2(J)=plot(x,y,'-','color',col);
                            
                            
                            X(1)=[];
                            subplot(2,3,2)
                            plot(X,D,['-'],'color',col); hold on
                            
                            D_primes(count_ID(J),J)=D(display_CND);
                            C_Data(count_ID(J),J)=C(display_CND);
                            
                            D_primes_all(count_ID(J),J,:)=D;
                            C_Data_all(count_ID(J),J,:)=C;
                            
                            subplot(2,3,3)
                            H(J)=plot(X,C,['-'],'color',col); hold on
                            
                            if J==3
                                %%%%%%%% You can represent the data as relative to the participants' average data
                                Thresholds(count_ID(J),:)=Thresholds(count_ID(J),:)./mean(Thresholds(count_ID(J),:),"omitnan");
                                D_primes(count_ID(J),:)=D_primes(count_ID(J),:)./mean(D_primes(count_ID(J),:),"omitnan");
                                C_Data(count_ID(J),:)=C_Data(count_ID(J),:)./mean(C_Data(count_ID(J),:),"omitnan");

                                D_primes_all(count_ID(J),:,:)=D_primes_all(count_ID(J),:,:)./mean(D_primes(count_ID(J),:),"omitnan");
                                C_Data_all(count_ID(J),:,:)=C_Data_all(count_ID(J),:,:)./mean(C_Data(count_ID(J),:),"omitnan");
                            end
                        end
                    end
                end
                if count_ID(1)~=count_ID(3)
                    count_ID(1:3)=min(count_ID);
                end
            end%participants
        end% groups
    end%years
end%folders
%%
subplot(2,3,1)
title('interesting things','fontsize',14)
xlabel('numbers that mean something','fontsize',14)
ylabel('numbers that mean something','fontsize',14)
title('Psychometric function')
set(gca,'linewidth',2,'tickdir','out','fontsize',14,'xtick',[0 (X)]); box off;
box off; axis tight
legend([H2],[{'somthing green'},{'somthing red'},{'something blue'},ID_txt],'Location','SouthEast')
text(0,max(get(gca,'ylim')),['  N = ' num2str(count_ID(1)) ' participants'],'fontsize',14)


subplot(2,3,2)
title('interesting things','fontsize',14)
xlabel('numbers that mean something','fontsize',14)
ylabel('numbers that mean something','fontsize',14)
title('D prime')
set(gca,'linewidth',2,'tickdir','out','fontsize',14,'xtick',[0 (X)]); box off;
box off; axis tight
X2=get(gca,'xlim');

subplot(2,3,3)
plot([min(X2) max(X2)],[0 0],'k:','linewidth',2)
title('other interesting things','fontsize',14)
xlabel('numbers that mean something','fontsize',14)
ylabel('numbers that mean something','fontsize',14)
title('Criterion')
set(gca,'linewidth',2,'tickdir','out','fontsize',14,'xtick',[0 (X)]); box off;
box off;axis tight
set(gcf,'color','w')

subplot(2,3,4)
errorbar(1:3,mean(Thresholds,1,"omitnan"),std(Thresholds,0,1,"omitnan")./sqrt(size(Thresholds,1)),'color','k','linewidth',2)
ylabel('Threshold','fontsize',14)
box off;axis tight
set(gca,'linewidth',2,'tickdir','out','fontsize',14,'xtick',[1 2 3],'xlim',[0.8 3.2],'xticklabel',[{'dont miss'},{'neutral'},{'dont cry'}]); box off;

subplot(2,3,5)
errorbar(1:3,mean(D_primes,1,"omitnan"),std(D_primes,0,1,"omitnan")./sqrt(size(Thresholds,1)),'color','k','linewidth',2); hold on
ylabel('D prime','fontsize',14)
box off;axis tight
set(gca,'linewidth',2,'tickdir','out','fontsize',14,'xtick',[1 2 3],'xlim',[0.8 3.2],'xticklabel',[{'dont miss'},{'neutral'},{'dont cry'}]); box off;

subplot(2,3,6)
errorbar(1:3,mean(C_Data,1,"omitnan"),std(C_Data,0,1,"omitnan")./sqrt(size(Thresholds,1)),'color','k','linewidth',2); hold on
ylabel('Criterion','fontsize',14)
box off;axis tight
set(gca,'linewidth',2,'tickdir','out','fontsize',14,'xtick',[1 2 3],'xlim',[0.8 3.2],'xticklabel',[{'dont miss'},{'neutral'},{'dont cry'}]); box off;

%screen_size = get(0, 'ScreenSize');screen_size(2)=screen_size(2)/2;
%origSize = get(gcf, 'Position'); % grab original on screen size
%set(gcf, 'Position', [0 0 screen_size(3) screen_size(4) ] ); %set to scren size
set(gcf,'PaperPositionMode','auto') %set paper pos for printing
saveas(gcf,[data_directory1 '/Group_data_fig1.png'])
%%

%figure();
f2_h=figure('Units','normalized','Position',[.1 .1 .8 .8]); % FS
[X,ix]=sort(CNDS);%fliplr(round([1/2 1/1.5 1 1.5 2],2));

subplot(2,2,1)
imagesc([1:1:length(CNDS)],[1:3],squeeze(mean(D_primes_all,1,"omitnan")));
colorbar
axis square;
set(gca,'ytick',[1:3],'xtick',[1:length(CNDS)],'tickdir','out','fontsize',14,'YTickLabel',[{'one'} {'two'} {'three'}]); box off
xlabel('whatsits')

subplot(2,2,2)
imagesc([1:1:length(CNDS)],[1:3],squeeze(mean(C_Data_all,1,"omitnan")))
colorbar
axis square
set(gca,'ytick',[1:3],'xtick',[1:length(CNDS)],'tickdir','out','fontsize',14,'YTickLabel',[]); box off
xlabel('something I forgot')

subplot(2,2,3);cla
A=squeeze(mean(D_primes_all,1,"omitnan"));
S=squeeze(std(D_primes_all,0,1,"omitnan"))./sqrt(size(C_Data_all,1));

errorbar(X,A(1,:),S(1,:),'color',[0 0.7 0],'linewidth',2); hold on
errorbar(X,A(2,:),S(1,:),'r','linewidth',2); hold on
errorbar(X,A(3,:),S(1,:),'b','linewidth',2); hold on
set(gca,'linewidth',2,'tickdir','out','fontsize',14,'xtick',sort(X)); box off;
box off;axis tight
set(gcf,'color','w')
ylabel("D'",'fontsize',14)
xlabel('things','fontsize',14)

subplot(2,2,4); cla
A=squeeze(mean(C_Data_all,1,"omitnan"));
S=squeeze(std(C_Data_all,0,1,"omitnan"))./sqrt(size(C_Data_all,1));
errorbar(X,A(1,:),S(1,:),'color',[0 0.7 0],'linewidth',2); hold on
errorbar(X,A(2,:),S(1,:),'r','linewidth',2); hold on
errorbar(X,A(3,:),S(1,:),'b','linewidth',2); hold on
set(gca,'linewidth',2,'tickdir','out','fontsize',14,'xtick',sort(X)); box off;
box off;axis tight
set(gcf,'color','w')
ylabel("C",'fontsize',14)
xlabel('stuff','fontsize',14)
legend([{'green'} {'red'}  {'blue'}])
%screen_size = get(0, 'ScreenSize');screen_size(2)=screen_size(2)/2;
%origSize = get(gcf, 'Position'); % grab original on screen size
%set(gcf, 'Position', [0 0 screen_size(3) screen_size(4) ] ); %set to scren size
set(gcf,'PaperPositionMode','auto') %set paper pos for printing
saveas(gcf,[data_directory1 '/Group_data_fig2.png'])

A_data1=[];grp1=[];grp2=[];grp3=[]
A_data2=[];
for C=1:length(X) %contrast level
    for R=1:3 %bias condition
        A_data1=[A_data1 squeeze(D_primes_all(:,R,C))'];
        A_data2=[A_data2 squeeze(C_Data_all(:,R,C))'];
        grp1=[grp1 zeros(1,size(D_primes_all,1))+C];
        grp2=[grp2 zeros(1,size(D_primes_all,1))+R];
        grp3=[grp3 1:size(D_primes_all,1)];
    end
end
T=table(A_data1',A_data2',grp1',grp2',grp3','VariableNames',[{'D'},{'C'},{'Stimulus'},{'Bias'},{'ID'}]);
T.Bias=categorical(T.Bias);
T.Stimulus=categorical(T.Stimulus);
T.ID=nominal(T.ID);

lme = fitlme(T,['D ~ Stimulus + Bias + (1|ID)'],...
    'FitMethod','REML','DummyVarCoding','effects');
D_prime_ANOVA=anova(lme)

lme = fitlme(T,['C ~ Stimulus + Bias + (1|ID)'],...
    'FitMethod','REML','DummyVarCoding','effects');
Criterion_ANOVA=anova(lme)




%%
% % test power with different numbers of participants
% N_participants=5; %12;
% out=[]; %clc
% niter=0;
% for R=1:niter
%     fprintf('%d ',R);
%     ix=find(ismember(grp3,datasample(unique(grp3),N_participants,'replace',false)));
%     
%     T=table(A_data1(ix)',A_data2(ix)',grp1(ix)',grp2(ix)',grp3(ix)','VariableNames',[{'D'},{'C'},{'Stimulus'},{'Bias'},{'ID'}]);
%     T.Bias=categorical(T.Bias);
%     T.Stimulus=categorical(T.Stimulus);
%     T.ID=nominal(T.ID);
%     
%     lme = fitlme(T,['D ~ Stimulus + Bias + (1|ID)'],...
%         'FitMethod','REML','DummyVarCoding','effects');
%     D_prime_ANOVA=anova(lme);
%     
%     lme = fitlme(T,['C ~ Stimulus + Bias + (1|ID)'],...
%         'FitMethod','REML','DummyVarCoding','effects');
%     Criterion_ANOVA=anova(lme);
%     out(R,:)=[D_prime_ANOVA{2,5} D_prime_ANOVA{3,5}  Criterion_ANOVA{2,5} Criterion_ANOVA{3,5}];
% end
% if niter > 0
%     sum(out<0.05)/R
% end
%%
%not repeated measures anovan(A_data1,[{grp1} {grp2}],'varnames',[{'D Contrast'};{'D Risk'}]);
%not repeated measures anovan(A_data2,[{grp1} {grp2}],'varnames',[{'C Contrast'};{'C Risk'}]);

cd(data_directory1); %FS to go back to where we came from



