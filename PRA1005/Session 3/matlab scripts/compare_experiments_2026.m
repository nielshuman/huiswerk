close all, clear all,clc
%%%%%%%%%%%% load the data and make the analysis figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%% set the directory to save the data to %%%
p = mfilename('fullpath');
if ispc
    data_directory=p(1:max(find(p=='\')));
else %is a mac
    data_directory=p(1:max(find(p=='/')));
end
group_number=2;
Participant_ID=8;
dtmp=date;year=dtmp(end-3:end);

tbl=[];
figure
for J=1:3% go through the three bias conditions 
    % you need to set the Repetition for each bias condition
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
    
    %%% then you can run the analysis (press run)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    load(data_filename)
    
    count=0;X=[];clear HIT MISS
    CNDS=unique(cnd_matrix(:,2))';
    n_rep=size(cnd_matrix,1)/length(CNDS)/2;
    for CND=CNDS
        count=count+1;
        X(count)=CND;
        HIT(count)=length(find(cnd_matrix(:,2)==CND & cnd_matrix(:,3)==1 & cnd_matrix(:,5)==1))/n_rep;
        MISS(count)=length(find(cnd_matrix(:,2)==CND & cnd_matrix(:,3)==1 & cnd_matrix(:,5)==0))/n_rep;
    end
    FA=length(find(cnd_matrix(:,3)==0 & cnd_matrix(:,5)==1))/length(cnd_matrix(:,3)==0);
    CR=length(find(cnd_matrix(:,3)==0 & cnd_matrix(:,5)==0))/length(cnd_matrix(:,3)==0);
    
    P_correct=[HIT FA]
    X=[X 0];
    plot(X,P_correct,'s','markersiz',10,'color',col,'linewidth',2); hold on
    options=optimset('MaxFunEvals',10000000,'MaxIter',10000);
    %[pars,err]=fminsearch(@Weibull_fit,[mean(X) 1  FA],[],X,P_correct);
    [pars,err]=fminsearch(@Weibull_fit,[mean(X) 1  FA],options,X,P_correct);
    interesting_numbers=round(pars,2);
    
    x=min(X):0.01:max(X);
    t=pars(1); %% threshold
    b=pars(2); %% slope
    g=pars(3); %% false alarm rate
    e = 0.75;
    tbl=[tbl;t b g];

    k = (-log( (1-e)/(1-g)))^(1/b);
    y = 1- (1-g)*exp(- (k*x/t).^b);
    H(J)=plot(x,y,'-','linewidth',2,'color',col);
    
    text(t,0.2,[ num2str(pars(1),2)],'horizontalalignment','left','color',col,'rotation',45,'fontsize',16)
    plot([t t],[e 0],[col '-'])
end
Parameters_Table=array2table(tbl,'VariableNames',[{'x'}, {'y'}, {'z'}])
title('interesting stuff','fontsize',14)
xlabel('Stimulus intensity (opacity of X)','fontsize',14)
ylabel('Proportion of times stimulus is observed (X is seen)','fontsize',14)
legend(H,[{'Neutral'},{'Dont Miss'},{'Dont Cry'}],'Location','SouthEast')

set(gca,'linewidth',2,'tickdir','out','fontsize',14,'ytick',[0 0.25 0.5 0.75 1]); box off;
set(gcf,'color','w')
box off;
set(gca,'ylim',[0 1],'xlim',[-0.01 max(X)])

screen_size = get(0, 'ScreenSize');
set(gcf, 'Position', [100 100 screen_size(3)-200 screen_size(4)-200 ] ); %set to scren size
saveas(gcf,[data_directory '/MCS_comparision.png'])


if ispc
    winopen(data_directory);
else %is a mac
    macopen(data_directory);
end