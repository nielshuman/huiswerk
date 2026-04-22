close all, clear all,clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%% set the directory to save the data to %%%
p = mfilename('fullpath');
if ispc
    data_directory=p(1:max(find(p=='\')));
    winopen(data_directory);
else %is a mac
    data_directory=p(1:max(find(p=='/')));
    macopen(data_directory);
end
group_number=2;
Participant_ID=8;
%%Choose a condition you want to make a 2x2 table from
display_CND=3;

dtmp=date;year=dtmp(end-3:end);
for J=1:3
    %%%%%%%%%%%% load the data and make the analysis figure
     if J==1
        Repetition=1;
        data_filename=[data_directory 'constant_stimuli_neutral_Y_' year '_G_' num2str(group_number) '_Participant_' num2str(Participant_ID) '_repetition_' num2str(Repetition) '.mat'];
        col='r'; %the color that each bias condition is plotted
    elseif J==2
        Repetition=1;
        data_filename=[data_directory 'constant_stimuli_DontMiss_Y_' year '_G_' num2str(group_number) '_Participant_' num2str(Participant_ID) '_repetition_' num2str(Repetition) '.mat'];
        col=[0 0.7 0]; % make a slightly darker green
    elseif J==3
        Repetition=1;
        data_filename=[data_directory 'constant_stimuli_DontCry_Y_' year '_G_' num2str(group_number) '_Participant_' num2str(Participant_ID) '_repetition_' num2str(Repetition) '.mat'];
        col='b';
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    load(data_filename)
    
    X=[];
    CNDS=unique(cnd_matrix(:,2))';
    n_rep=size(cnd_matrix,1)/length(CNDS)/2;
    count=0;
    D=[];C=[];
    for CND=CNDS
        count=count+1;
        X(count)=CND;
        HIT(count)=length(find(cnd_matrix(:,2)==CND & cnd_matrix(:,3)==1 & cnd_matrix(:,5)==1))/n_rep;
        MISS(count)=length(find(cnd_matrix(:,2)==CND & cnd_matrix(:,3)==1 & cnd_matrix(:,5)==0))/n_rep;
    end
    FA=length(find(cnd_matrix(:,3)==0 & cnd_matrix(:,5)==1))/length(find(cnd_matrix(:,3)==0));
    CR=length(find(cnd_matrix(:,3)==0 & cnd_matrix(:,5)==0))/length(find(cnd_matrix(:,3)==0));
    
    HIT(find(HIT==1))=0.999; CR(find(CR==1))=0.999; FA(find(FA==1))=0.999; MISS(find(MISS==1))=0.999;    
    HIT(find(HIT==0))=0.001; CR(find(CR==0))=0.001; FA(find(FA==0))=0.001; MISS(find(MISS==0))=0.001;
               
    count=0;
    for CND=CNDS
        count=count+1;
        D(count,1)=norminv(HIT(count))-norminv(FA);
        C(count,1)=-((norminv(HIT(count))+norminv(FA))/2);
    end
     D_overall(J)=norminv(mean(HIT))-norminv(FA);
     C_overall(J)=-((norminv(mean(HIT))+norminv(FA))/2);
        
    disp([{['Bias condition ' num2str(J)  '  Stimulus condition ' num2str(display_CND)]};...
        {['Hit rate = ' num2str(HIT(display_CND)) ...
        '    Miss rate = ' num2str(MISS(display_CND))...
        '    False alarm rate = ' num2str(FA)...
        '    Correct rejection rate = ' num2str(CR)]}]);
    
    subplot(1,2,1)
    plot(X,D,'s-','linewidth',2,'color',col); hold on
    subplot(1,2,2)
    H(J)=plot(X,C,'s-','linewidth',2,'color',col); hold on    
end

subplot(1,2,1)

title('d'' as a function of stimulus level','fontsize',14)
xlabel('numbers that mean something','fontsize',14)
ylabel('d''','fontsize',14)

set(gca,'linewidth',2,'tickdir','out','fontsize',14,'xtick',sort(X),'xticklabel',[sort(round(X,2))]); box off;
box off; axis tight

subplot(1,2,2)
plot([min(X) max(X)],[0 0],'k:','linewidth',2)

title('C as a funciton of stimulus level','fontsize',14)
xlabel('numbers that mean something','fontsize',14)
ylabel('numbers that mean something','fontsize',14)
legend(H,[{'Neutral'},{'Dont Miss'},{'Dont Cry'}])

set(gca,'linewidth',2,'tickdir','out','fontsize',14,'xtick',sort(X),'xticklabel',[sort(round(X,2))]); box off;
box off;axis tight
set(gcf,'color','w')

screen_size = get(0, 'ScreenSize');
set(gcf, 'Position', [100 100 screen_size(3)-200 screen_size(4)-200 ] ); %set to scren size
set(gcf,'PaperPositionMode','auto') %set paper pos for printing
saveas(gcf,[data_directory '/Signal_detection_theory_MCS.png'])

