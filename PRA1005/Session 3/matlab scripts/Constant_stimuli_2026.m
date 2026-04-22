function []=Constant_stimuli_2025()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Befor running this script, discuss the experiment setup with your group
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% set the directory to save the data to %%%
close all, clear all,clc
p = mfilename('fullpath');
if ispc
    data_directory=p(1:max(find(p=='\')));
else ismac %is a mac
    data_directory=p(1:max(find(p=='/')));
end
cd(data_directory)

group_number=2;          % Your tutorial group number, e.g. 1
Participant_ID=8;      % Each member of your group should have an individual number
% Each member should use their own threshold estimate from the staircase
staircase_threshold=0.3;

% Which stimulus levels will you test? Everyone in the group should use the same conditions
% set your stimulus levels as multiples of your individual threshold
CNDS=[2 1.5 0.75 0.5]; %set this as multiples e.g. [2 1 0.5]

CNDS=CNDS.*staircase_threshold;
% how many trials per conditions will you test. Everyone in the group should use the same
n_rep=50;

% You can calculate how long your planned experiment will take

% These numbers are signal-to-noise ratio
%CNDS=1./CNDS;% these numbers are the contrast of the target

% 3 2 1
% There are three bias conditions, 
% Everyone in the group should participate in all three in the order you decided
Bias_condition=1;
% if you repeat an experiment set the repetion number
Repetition=1;

% Your data will be saved in this filename
dtmp=date;year=dtmp(end-3:end);
if Bias_condition==1
    data_filename=[data_directory 'constant_stimuli_neutral_Y_' year '_G_' num2str(group_number) '_Participant_' num2str(Participant_ID) '_repetition_' num2str(Repetition) '.mat'];
elseif Bias_condition==2
    data_filename=[data_directory 'constant_stimuli_DontMiss_Y_' year '_G_' num2str(group_number) '_Participant_' num2str(Participant_ID) '_repetition_' num2str(Repetition) '.mat'];
elseif Bias_condition==3
    data_filename=[data_directory 'constant_stimuli_DontCry_Y_' year '_G_' num2str(group_number) '_Participant_' num2str(Participant_ID) '_repetition_' num2str(Repetition) '.mat'];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Experiment loop %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist(data_filename)~=2
    session_start=tic;
    close all
    count=0;cnd_matrix=[];
    for CND=CNDS
        for show=[0 1]
            for rep=1:n_rep
                count=count+1;
                cnd_matrix=[cnd_matrix;[count CND show rep 0 NaN]];
            end
        end
    end
    total_number_of_trials = length(cnd_matrix)
    
    %%%%%%%%%%%%%%%%%%%%%%% make the figures that will be used
    pause on
    colormap(gray)
    fill([0 0 1 1 0],[0 1 1 0 0],[1 1 1]); set(gca,'xlim',[0 1],'ylim',[0 1]);
    text(0.5, 0.5,'X','fontsize',100,'fontweight','bold','horizontalalignment','center'); axis square
    I=getframe; close all
    tst=mean(I.cdata,3)./255;
    tst=tst-mean(tst(:)');
    tst=tst./4;
    imagesc([0 1],[0 1],tst); set(gca,'xlim',[0 1],'ylim',[0 1]);
    set(gca,'xtick',[],'ytick',[],'clim',[-1 1]); set(gcf,'color','w')
    colormap(gray)
    
    figure
    N = [size(I.cdata,1) size(I.cdata,2)]; % size in pixels of image
    F = 20;        % frequency-filter width
    [X,Y] = ndgrid(1:N(1),1:N(2));
    i = min(X-1,N(1)-X+1);
    j = min(Y-1,N(2)-Y+1);
    H = exp(-.5*(i.^2+j.^2)/F^2);
    Z = real(ifft2(H.*fft2(randn(N))));
    imagesc([0 1],[0 1],Z); set(gca,'xlim',[0 1],'ylim',[0 1]);
    set(gca,'xtick',[],'ytick',[],'clim',[-1 1]); set(gcf,'color','w')
    colormap(gray)
    
    figure
    imagesc([0 1],[0 1],tst+Z); set(gca,'xlim',[0 1],'ylim',[0 1]);
    set(gca,'xtick',[],'ytick',[],'clim',[-1 1]); set(gcf,'color','w')
    colormap(gray)
    close all
    
    %%%%%%%% start the experiment, conditions are presented in a randomized order using randperm
    figure('Color','w','Menubar','none','ToolBar','none','DockControls','off','Resize','off','units','normalized','position',[0.025 0.025 .95 .95]);      %'WindowState','fullscreen');
    S1=subplot('position',[0.3 0.3 0.4 0.4],'color','none','xcolor','none','ycolor','none','xtick',[],'ytick',[]); set(gca,'xlim',[0 1],'ylim',[0 1]);axis square
        fig1=gcf; 
    figure(fig1)
    drawnow
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% start the countdown    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%% give different instructions depending on condtion %%
    if Bias_condition==1
        colormap(gray)
        fill([0 0 1 1 0],[0 1 1 0 0],[1 1 1],'edgecolor','w');
        set(gca,'xtick',[],'ytick',[],'clim',[-1 1],'xcolor','none','ycolor','none','xlim',[0 1],'ylim',[0 1]);
        h=text(0.5, 0.5,'The experiment will start','fontsize',20,'fontweight','bold','horizontalalignment','center'); axis square
        pause(2)
        delete(h)
        h=text(0.5, 0.5,'3','fontsize',100,'fontweight','bold','horizontalalignment','center'); axis square
        pause(1)
        delete(h)
        h=text(0.5, 0.5,'2','fontsize',100,'fontweight','bold','horizontalalignment','center'); axis square
        pause(1)
        delete(h)
        h=text(0.5, 0.5,'1','fontsize',100,'fontweight','bold','horizontalalignment','center'); axis square
        pause(1)
        delete(h)
    elseif Bias_condition==2
        colormap(gray)
        fill([0 0 1 1 0],[0 1 1 0 0],[1 1 1],'edgecolor','w');
        set(gca,'xtick',[],'ytick',[],'clim',[-1 1],'xcolor','none','ycolor','none','xlim',[0 1],'ylim',[0 1]);
        h=text(0.5, 0.5,'The experiment will start','fontsize',20,'fontweight','bold','horizontalalignment','center'); axis square
        pause(2)
        delete(h)
        h=text(0.5, 0.5,'Do','fontsize',100,'fontweight','bold','horizontalalignment','center'); axis square
        pause(1)
        delete(h)
        h=text(0.5, 0.5,'Not','fontsize',100,'fontweight','bold','horizontalalignment','center'); axis square
        pause(1)
        delete(h)
        h=text(0.5, 0.5,'Miss','fontsize',100,'fontweight','bold','horizontalalignment','center'); axis square
        pause(1)
        delete(h)
    elseif Bias_condition==3
        colormap(gray)
        fill([0 0 1 1 0],[0 1 1 0 0],[1 1 1],'edgecolor','w');
        set(gca,'xtick',[],'ytick',[],'clim',[-1 1],'xcolor','none','ycolor','none','xlim',[0 1],'ylim',[0 1]);
        h=text(0.5, 0.5,'The experiment will start','fontsize',20,'fontweight','bold','horizontalalignment','center'); axis square
        pause(2)
        delete(h)
        h=text(0.5, 0.5,'Do Not','fontsize',100,'fontweight','bold','horizontalalignment','center'); axis square
        pause(1)
        delete(h)
        h=text(0.5, 0.5,'Cry','fontsize',100,'fontweight','bold','horizontalalignment','center'); axis square
        pause(1)
        delete(h)
        h=text(0.5, 0.5,'Wolf','fontsize',100,'fontweight','bold','horizontalalignment','center'); axis square
        pause(1)
        delete(h)
    end   

    keepRunning = 'true';
    set(fig1, 'KeyPressFcn', @KeyPressCallback);
    figure(fig1)
    drawnow
    count=0;trial_times=[];
    for trial=randperm(size(cnd_matrix,1))
        trial_start=tic;
        cla
        set(gcf,'color','w')
        
        Z = real(ifft2(H.*fft2(randn(N))));
        
        imagesc([0 1],[0 1],zeros(size(Z)));
        set(gca,'xtick',[],'ytick',[],'clim',[-1 1],'xlim',[0 1],'ylim',[0 1])
        axis square;    colormap(gray(256))
        pause(0.25)
        
        count=count+1;
        if cnd_matrix(trial,3)
            imagesc([0 1],[0 1],(tst.*cnd_matrix(trial,2))+Z);
        else
            imagesc([0 1],[0 1],Z);
        end
        set(gca,'xtick',[],'ytick',[],'clim',[-1 1],'xlim',[0 1],'ylim',[0 1])
        axis square
        stim_start=tic;
        pause(0.05)
        
        imagesc([0 1],[0 1],zeros(size(Z)));
        set(gca,'xtick',[],'ytick',[],'clim',[-1 1],'xlim',[0 1],'ylim',[0 1])
        axis square;    colormap(gray(256))
        drawnow
        
        wait_response=1;keepRunning='0';
        while  wait_response
            if strcmp('x', keepRunning)
                response=1;
                wait_response=0;
            elseif strcmp('X', keepRunning)
                response(trial)=1;
                wait_response=0;
            elseif strcmp('space', keepRunning)
                response=0;
                wait_response=0;
            elseif strcmp('escape', keepRunning)
                commandwindow;
                close all;
                error('Task stopped prematurely by responding Esc, no data saved.');
                %return
            end
             if ~ishghandle(fig1)
                return
            end
            drawnow
        end
        pause(0.1)

        %%%%%%%% Give feedback depending on the bias conditions %%%%%%
        if Bias_condition==1
            if response==1 & cnd_matrix(trial,3)==0 %if response X but stimulus absent
               set(gcf,'color','r')
                pause(0.1)
                set(gcf,'color','w')
            end
            if response==0 & cnd_matrix(trial,3)==1 % if response no but stimulus present
               set(gcf,'color','r')
                pause(0.1)
                set(gcf,'color','w')
            end
        elseif Bias_condition==2
            if response==0 & cnd_matrix(trial,3)==1
                set(gcf,'color','r')
                pause(0.1)
                set(gcf,'color','w')
            end
        elseif Bias_condition==3
            if response==1 & cnd_matrix(trial,3)==0
                set(gcf,'color','r')
                pause(0.1)
                set(gcf,'color','w')
            end
        end
        pause(0.1)

        cnd_matrix(trial,5)=response;cnd_matrix(trial,1)=count;cnd_matrix(trial,6)=toc(stim_start);
        trial_times(count)=toc(trial_start);
    end
    session_time=toc(session_start);
    save(data_filename,'cnd_matrix','staircase_threshold','trial_times','session_time');
    close all
end
if ispc
    winopen(data_directory);
else %is a mac
    macopen(data_directory);
end
load(data_filename);
figure,
count=0;X=[];
CNDS=unique(cnd_matrix(:,2))';
n_rep=size(cnd_matrix,1)/length(CNDS)/2;
for CND=CNDS
    count=count+1;
    X(count)=CND;
    HIT(count)=length(find(cnd_matrix(:,2)==CND & cnd_matrix(:,3)==1 & cnd_matrix(:,5)==1))/n_rep;
    MISS(count)=length(find(cnd_matrix(:,2)==CND & cnd_matrix(:,3)==1 & cnd_matrix(:,5)==0))/n_rep;
    
     HIT_RT(count)=median(cnd_matrix(find(cnd_matrix(:,2)==CND & cnd_matrix(:,3)==1 & cnd_matrix(:,5)==1),6));
     MISS_RT(count)=median(cnd_matrix(find(cnd_matrix(:,2)==CND & cnd_matrix(:,3)==1 & cnd_matrix(:,5)==0),6));
end
FA=length(find(cnd_matrix(:,3)==0 & cnd_matrix(:,5)==1))/length(cnd_matrix(:,3)==0);
CR=length(find(cnd_matrix(:,3)==0 & cnd_matrix(:,5)==0))/length(cnd_matrix(:,3)==0);

FA_RT=median(cnd_matrix(find(cnd_matrix(:,3)==0 & cnd_matrix(:,5)==1),6));
CR_RT=median(cnd_matrix(find(cnd_matrix(:,3)==0 & cnd_matrix(:,5)==0),6));

P_correct=[HIT FA];
X=[X 0];
plot(X,P_correct,'ko','markersiz',10,'linewidth',2); hold on
[pars,err]=fminsearch(@Weibull_fit,[mean(X) 1  FA],[],X,P_correct);
interesting_numbers=round(pars,2)

x=min(X):0.01:max(X);
t=pars(1); %% threshold
b=pars(2); %% slope
g=pars(3); %% false alarm rate
e = 0.75;

k = (-log( (1-e)/(1-g)))^(1/b);
y = 1- (1-g)*exp(- (k*x/t).^b);
plot(x,y,'b-','linewidth',2);

plot([min(x) max(x)],[0.5 0.5],'k:'); hold on
set(gca,'ylim',[0 1])

% title('interesting stuff','fontsize',14)
% xlabel('numbers that mean something','fontsize',14)
% ylabel('numbers that mean something','fontsize',14)
% legend([{'somthing round'},{'somthing blue'},{'what does this mean?'}],'Location','SouthEast')
% 
% text(min(x),0.9,['  an interesting number = ' num2str(pars(2),2)],'horizontalalignment','left')
% text(t,e,['  an interesting number = ' num2str(pars(1),2)],'horizontalalignment','left')
% plot([min(get(gca,'xlim')) t t],[e e min(get(gca,'ylim'))],'k-')
% set(gca,'linewidth',2,'tickdir','out','fontsize',14); box off;
% set(gcf,'color','w')
% box off;

title('interesting stuff','fontsize',14)
xlabel('numbers','fontsize',14)
ylabel('numbers','fontsize',14)

text(min(x),0.9,['an interesting number = ' num2str(pars(2),2)],'horizontalalignment','left')
text(t,e,['an important number = ' num2str(pars(1),2)],'horizontalalignment','left')
plot([min(get(gca,'xlim')) t t],[e e min(get(gca,'ylim'))],'k-')
set(gca,'linewidth',2,'tickdir','out','fontsize',14); box off;
set(gcf,'color','w')
legend([{'somthing round'},{'something blue'},{'lower dashed line'}, {'another line'}],'Location','SouthEast')
box off;

figure,set(gcf,'position',[560 0 560 420],'color','w');set(gca,'xcolor','w','ycolor','w')
colormap(gray)
fill([0 0 1 1 0],[0 1 1 0 0],[1 1 1]);
text(0.5, 0.5,'X','fontsize',100,'fontweight','bold','horizontalalignment','center'); axis square
I=getframe;
tst=mean(I.cdata,3)./255;
tst=tst-mean(tst(:)');
tst=tst./4;

N = [size(I.cdata,1) size(I.cdata,2)]; % size in pixels of image
F = 20;        % frequency-filter width
[X,Y] = ndgrid(1:N(1),1:N(2));
i = min(X-1,N(1)-X+1);
j = min(Y-1,N(2)-Y+1);
H = exp(-.5*(i.^2+j.^2)/F^2);
Z = real(ifft2(H.*fft2(randn(N))));

count=0;
for CND=(CNDS)
    count=count+1;
    subplot(1,length(CNDS),count)
    Z = real(ifft2(H.*fft2(randn(N))));
    
    imagesc((tst.*CND)+Z);
    set(gca,'xtick',[],'ytick',[],'clim',[-1 1])
    axis square; colormap(gray(256))
    set(gcf,'color','w')
    title(num2str(CND,2))
end


    function KeyPressCallback(sourceHandle, event) %#ok<INUSL>
        keepRunning = event.Key;
    end
end

