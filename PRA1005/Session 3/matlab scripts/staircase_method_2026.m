function []=staircase_method_2025()
close all; clear variables; clc
%%% set the directory to save the data to %%%
p = mfilename('fullpath');
if ispc
    data_directory=p(1:max(find(p=='\')));
else %is a mac
    data_directory=p(1:max(find(p=='/')));
end
cd(data_directory)

data_filename=[data_directory 'test_file.mat']
save(data_filename,'data_directory'); %test that saving is alowed
delete(data_filename)

%%%%%%%%%%%% you can change the start level here
Start_level=1;
%%%%%%%%%%%% if you repeat a staircase with the same noise level
Repetition=2;
%%%%%%%%%%%%% Your data will be saved in this filename
data_filename=[data_directory 'staircase_start_level_' num2str(Start_level) '_repetition' num2str(Repetition) '.mat']

s = settings; if isfield(s.matlab.desktop,'CopilotEnabled'),s.matlab.desktop.copilot.CopilotEnabled.PersonalValue = false;end

if exist(data_filename)==2 % if the datafile already exists it will be loaded
    load(data_filename)
else %otherwise the file does not exist the experiment starts
    pause on
    colormap(gray)
    fill([0 0 1 1 0],[0 1 1 0 0],[1 1 1]);
    set(gca,'xlim',[0 1],'ylim',[0 1]);
    text(0.5, 0.5,'X','fontsize',100,'fontweight','bold','horizontalalignment','center'); axis square
    I=getframe; close all; % make the target stimulus
    tst=mean(I.cdata,3)./255;
    tst=tst-mean(tst(:)');
    tst=tst./4;
    cla
    
    N = [size(tst,1) size(tst,2)]; % size in pixels of image
    F = 20;        % frequency-filter width
    [X,Y] = ndgrid(1:N(1),1:N(2));
    i = min(X-1,N(1)-X+1);
    j = min(Y-1,N(2)-Y+1);
    H = exp(-.5*(i.^2+j.^2)/F^2);
    Z = real(ifft2(H.*fft2(randn(N))));
    
    figure('Color','w','Menubar','none','ToolBar','none','DockControls','off','Resize','off','units','normalized','position',[0.025 0.025 .95 .95]);      %'WindowState','fullscreen');
    S1=subplot('position',[0.3 0.3 0.4 0.4],'color','none','xlim',[0 1],'ylim',[0 1]); axis square
    fill([0 0 1 1 0],[0 1 1 0 0],[1 1 1],'edgecolor','w');    set(gca,'xlim',[0 1],'ylim',[0 1],'xtick',[],'ytick',[],'xcolor','none','ycolor','none');
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
    
    
    S2=subplot('position',[0.05 0.05 0.25 0.25],'color','none','tickdir','out');box off%axis square

    fig1=gcf;
    keepRunning = 'true';
    set(fig1, 'KeyPressFcn', @KeyPressCallback);
    
    stimulus_level=Start_level;
    count=0;up_flag=0; down_flag=0; same_flag=0;
    reversal=[]; trial=0;response=[];reversal_trial=[];trial_times=[];
    
    while length(reversal)<20
        Z = real(ifft2(H.*fft2(randn(N))));
        trial=trial+1;
        tic
        subplot(S1)
        imagesc([0 1],[0 1],zeros(size(Z)));
        set(gca,'xtick',[],'ytick',[],'clim',[-1 1])
        axis square;    colormap(gray(256))
        pause(0.25)%%%%%%% 250ms pre-stimulus time
        
        r(trial)=randn>0;
        if r(trial)>0
            imagesc([0 1],[0 1],(tst.*stimulus_level(trial))+Z);
        else
            imagesc([0 1],[0 1],Z);
        end
        set(gca,'xtick',[],'ytick',[],'clim',[-1 1])
        axis square
        pause(0.05)%%%%%%% 50ms stimulus time
        
        imagesc([0 1],[0 1],zeros(size(Z)));%%%%%%% response window untill a response is made
        set(gca,'xtick',[],'ytick',[],'clim',[-1 1])
        axis square
        drawnow
        wait_response=1;keepRunning='0';
        while  wait_response
            if ~strcmp('0', keepRunning)
            keepRunning
            end
            if strcmp('x', keepRunning)
                response(trial)=1;
                wait_response=0;
            elseif strcmp('X', keepRunning)
                response(trial)=1;
                wait_response=0;
            elseif strcmp('space', keepRunning)
                response(trial)=0;
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

        if response(trial)==r(trial)
            correct(trial)=1;
        else
            correct(trial)=0;
        end
        
        drawnow
        subplot(S2)
        stimulus_level(trial+1)=stimulus_level(trial);
        if correct(trial)>0
            plot(trial, stimulus_level(trial),'g*');hold on
            count=count+1;
            if count==3
                count=0; stimulus_level(trial+1)=stimulus_level(trial)/1.1;
                up_flag=1;
                if down_flag==1
                    reversal=[reversal stimulus_level(trial)];
                    reversal_trial=[reversal_trial trial];
                    plot(trial, stimulus_level(trial),'ko');hold on
                end
                down_flag=0;
                same_flag=0;
            end
        else
            plot(trial, stimulus_level(trial),'r*');hold on
            count=0; stimulus_level(trial+1)=stimulus_level(trial)*1.1;
            down_flag=1;
            if up_flag==1
                reversal=[reversal stimulus_level(trial)];
                reversal_trial=[reversal_trial trial];
                plot(trial, stimulus_level(trial),'ko');hold on
            end
            up_flag=0;
            same_flag=0;
        end
        pause(0.2)

        set(gca,'color',get(fig1,'color'));box off
        drawnow
        trial_times(end+1)=toc;
    end
    threshold=(exp(mean(log(reversal(5:end)))))
    plot([1 trial], [threshold threshold],'r-'); hold on;
    save(data_filename,'stimulus_level','correct','reversal','reversal_trial','trial_times');
end
if ispc
    winopen(data_directory);
elseif ismac %is a mac
    macopen(data_directory);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Here you can edit the figure

close all,  clc
idx=find(correct==1);
plot(idx,stimulus_level(idx),'g*','markersize',10); hold on
idx=find(correct==0);
plot(idx,stimulus_level(idx),'r*','markersize',10); hold on
plot(reversal_trial,reversal,'ko','markersize',10); hold on

threshold=(exp(mean(log(reversal(5:end)))));
plot([1 length(correct)], [threshold threshold],'r-'); hold on;

title('interesting stuff','fontsize',14)
xlabel('big numbers that mean something','fontsize',14)
ylabel('small numbers that mean something','fontsize',14)
legend([{'somthing green'},{'somthing red'},{'something round'},{'something red'}])
text(0,threshold*0.9,['  an interesting number = ' num2str(threshold,2)],'horizontalalignment','left','fontsize',14)
text(0,threshold*0.8,['  median time per trial = ' num2str(median(trial_times),2) 'sec'],'horizontalalignment','left','fontsize',14)

set(gca,'linewidth',2,'tickdir','out','fontsize',14); box off;
set(gcf,'color','w')
box off;
if max(stimulus_level>1)
    set(gca,'ylim',[0 max(stimulus_level)]);
else
        set(gca,'ylim',[0 1]);
end
    
% the figure gets saved
screen_size = get(0, 'ScreenSize');
set(gcf, 'Position', [100 100 screen_size(3)-200 screen_size(4)-200 ] ); %set to scren size
saveas(gcf,[data_directory 'Staircase_start_level_' num2str(Start_level) '_repetition' num2str(Repetition) '.png'])

    function KeyPressCallback(sourceHandle, event) %#ok<INUSL>
        keepRunning = event.Key;
    end
end

