close all, clear all
p = mfilename('fullpath');
if ispc; DRIVE=p(1:max(find(p=='\'))); else; DRIVE=p(1:max(find(p=='/'))); end
addpath(DRIVE); data_folder = get_drive;

load([data_folder 'In_OR_OUT_data'],'example_data','test_data')
for D=1:2
    example_data{D}.p=audioplayer(example_data{D}.d*100,example_data{1}.fs(D));
end
for D=1:length(test_data)
    test_data{D}.p=audioplayer(test_data{D}.d*100,test_data{1}.fs(D));
end

GAIN=.5;

figure('units','normalized','outerposition',[0 0.05 1 .9])
set(gcf,'color','w','name','Task 1 (press esc to escape)')

P=[0.0663    0.5874    0.3347    0.3412;
    0.4646    0.5885    0.3347    0.3412;
    0.8650    0.8169    0.0593    0.0991;
    0.8632    0.6479    0.0593    0.0991;
    0.2752    0.0575    0.3493    0.3948;
    0.6793    0.2547    0.0593    0.0991;
    0.7592    0.2535    0.0593    0.0991;
    0.1745    0.2289    0.0593    0.0991;
    0.0993    0.2324    0.0593    0.0991];

tittxt=[{'Example Out (press to play sound)'};{'Example In (press to play sound)'}];

for D=1:2
    subplot('position',P(D,:))
    plot(example_data{D}.t,example_data{D}.d.*GAIN,'k'); hold on
    
    set(gca,'ZTickLabel',['Play sound ' num2str(D)],'xcolor','k','ycolor','k','linewidth',3,'fontsize',16,'ylim',prctile(example_data{D}.d,[.25 99.75])), box off;
    xlabel('Time (sec)'); ylabel('Amplitutde (v)')
    title(tittxt{D})
end

subplot('position',P(3,:))
fill([0 0 .4 .4 0],[0 1 1 0 0],[0.3 0.3 1]); hold on,
fill([0.6 0.6 1 1 0.6],[0 1 1 0 0],[0.3 0.3 1]); hold on,
title('pause all')
set(gca,'ZTickLabel',['pause sounds'],'xcolor','w','ycolor','w','linewidth',3), box on;

subplot('position',P(4,:))
fill([0 0 .4 .4 0],[0 1 1 0 0],[1 0.1 0.1]); hold on,
title('stop all')
set(gca,'ZTickLabel',['stop sounds'],'xcolor','w','ycolor','w','linewidth',3), box on;


subplot('position',P(5,:))
plot([0 1],[0 0],'k')
set(gca,'ZTickLabel',['Test yourself'],'xcolor','w','ycolor','w','linewidth',3,'ylim',[-0.01 0.01]), box on;
title('Test yourself'),xlabel('Time (sec)'); ylabel('Amplitutde (v)')


subplot('position',P(6,:))
fill([0 0 .4 .4 0],[0 1 1 0 0],[0.1 0.1 0.1]); hold on,
title('Guess In')
set(gca,'ZTickLabel',['Guess In'],'xcolor','w','ycolor','w','linewidth',3), box on;


subplot('position',P(7,:))
fill([0 0 .4 .4 0],[0 1 1 0 0],[0.1 0.1 0.1]); hold on,
title('Guess Out')
set(gca,'ZTickLabel',['Guess Out'],'xcolor','w','ycolor','w','linewidth',3), box on;


PER=subplot('position',P(8,:));
title('Performance')
text(0, 0,['0 / ' num2str(length(test_data))],'fontsize',16)
set(gca,'xcolor','w','ycolor','w','linewidth',3), box on;


go_on=0;count=1; can_guess=0; can_go_on=1;is_correct=0;
test_order=randperm(length(test_data));
while go_on == 0
    try
        drawnow limitrate
        example_data{1}.p.CurrentSample
        example_data{2}.p.CurrentSample
        
        w = waitforbuttonpress;
        switch w
            case 1 % keyboard
                key = get(gcf,'currentcharacter');
                if key==27 % (the Esc key)
                    stop(example_data{1}.p);   stop(example_data{2}.p)
                    for i=test_order(1:count); stop(test_data{i}.p);end
                    break
                end
            case 0 % mouse click
                H=gca;
                if ~isempty(get(gca,'ZTickLabel'))
                    %%%%%%%%%%%%
                    if strcmp(get(gca,'ZTickLabel'),'stop sounds')
                        stop(example_data{1}.p);   stop(example_data{2}.p);                           for i=test_order(1:count); stop(test_data{i}.p);end
                        can_go_on=1;
                    end
                    if strcmp(get(gca,'ZTickLabel'),'pause sounds')
                        pause(example_data{1}.p);   pause(example_data{2}.p)
                        for i=test_order(1:count); stop(test_data{i}.p);end
                        can_go_on=1;
                    end
                    if strcmp(get(gca,'ZTickLabel'),'Play sound 1')
                        pause(example_data{2}.p)
                        play(example_data{1}.p)
                        for i=test_order(1:count); stop(test_data{i}.p);end
                    end
                    if strcmp(get(gca,'ZTickLabel'),'Play sound 2')
                        pause(example_data{1}.p)
                        play(example_data{2}.p)
                        for i=test_order(1:count); stop(test_data{i}.p);end
                    end
                    
                    %%%%%%%%%%%%
                    if strcmp(get(gca,'ZTickLabel'),'Test yourself') & can_go_on
                        stop(example_data{1}.p);   stop(example_data{2}.p);
                        for i=test_order(1:count); stop(test_data{i}.p);end
                        cla
                        plot(test_data{test_order(count)}.t,test_data{test_order(count)}.d.*GAIN,'k')
                        set(gca,'ZTickLabel',['Test yourself'],'xcolor','w','ycolor','w','linewidth',3,'ylim',prctile(test_data{test_order(count)}.d,[.25 99.75])), box on;
                        title('Test yourself'),xlabel('Time (sec)'); ylabel('Amplitutde (v)')
                        play(test_data{test_order(count)}.p)
                        if exist('h');   delete(h);      end
                        can_guess=1;                        can_go_on=0;
                    end
                    
                    if strcmp(get(gca,'ZTickLabel'),'Guess In') & can_guess
                        for i=test_order(1:count); stop(test_data{i}.p);end
                        
                        if exist('h');   delete(h);      end
                        if test_data{1}.correct(test_order(count))==1
                            h=text(0.5,-1,'correct','horizontalalignment','center','fontsize',16);
                            is_correct=is_correct+1;
                        else
                            h=text(0.5,-1,'error','horizontalalignment','center','fontsize',16);
                        end
                        can_guess=0;can_go_on=1;
                        subplot(PER)
                        cla
                        text(0, 0,[{[num2str(count) ' / ' num2str(length(test_data)) ' trials done']} ;{[num2str(is_correct)  ' correct']}],'fontsize',16)
                        count=count+1;
                    end
                    
                    if strcmp(get(gca,'ZTickLabel'),'Guess Out') & can_guess
                        for i=test_order(1:count); stop(test_data{i}.p);end
                        if exist('h');   delete(h);      end
                        if test_data{1}.correct(test_order(count))==0
                            h=text(0,-1,'correct','horizontalalignment','center','fontsize',16);
                            is_correct=is_correct+1;
                        else
                            h=text(0,-1,'error','horizontalalignment','center','fontsize',16);
                        end
                        can_guess=0; can_go_on=1;
                        subplot(PER)
                        cla
                        text(0, 0,[{[num2str(count) ' / ' num2str(length(test_data)) ' trials done']} ;{[num2str(is_correct)  ' correct']}],'fontsize',16)
                        count=count+1;
                    end
                end
        end
        if count==length(test_data)+1
            
            figure('units','normalized','outerposition',[0 0.05 1 .9])
            set(gcf,'color','w','name','Performance')
            Theta = 0:pi/180:2*pi;
            x = cos(Theta);
            y = sin(Theta);
            plot(x,y,'k-','linewidth',4); hold on
            plot([-1.5 0 1.5],[2 -.5 2],'b','linewidth',10)
            score=is_correct / length(test_data);
            
            if score>=.8
                fill(x,y,[207,181,59]./255);
                txt='Amazing';
            elseif score>=.7 & score<.8
                fill(x,y,[192 192 192]./255);
                txt='Good effort';
            elseif score>=.6 & score<.7
                fill(x,y,[128 74 0]./255);
                txt='Try again';
            else
                fill(x,y,[1 1 1]);
                txt='Try again';
            end
            if score<.5
                txt='Use a dice next time';
            end
            if score==1
                txt='Perfect';
            end
            
            text(0, 0,[num2str( (is_correct / length(test_data))*100,3   ) '% '] ,'fontsize',80,'fontweight','bold','horizontalalignment','center')
            text(0, -1.5,txt ,'fontsize',40,'fontweight','bold','horizontalalignment','center')
            set(gca,'xlim',[-2 2],'ylim',[-2 2],'xcolor','none','ycolor','none','color','w'); axis square
            go_on=1;
        end
    catch
        cla
        close all
        break
    end
end


