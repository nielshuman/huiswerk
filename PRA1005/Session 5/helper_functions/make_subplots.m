function [subplot_handles,fighandle]= make_subplots(num_electrodes,num_cond,fig_title,x_title,y_title,size)

% %%%%%%%%%%%%% set up a figure, define subplot boundarys %%%%%%%%%%
 fighandle=  figure('Color',[0 0 0],'Units', 'Normalized', 'Position',[0.001 0.035 0.998/size(1) 0.935/size(end)],'menubar','none','name',fig_title,'InvertHardcopy','off'); %

border=0;
if (num_electrodes*num_cond)>100
    border=-.01;
end
plot_width=(1/(num_electrodes-(num_electrodes*border)))-border;
plot_height=(1/(num_cond-(num_cond*border)))-border;
for e=1:num_electrodes
    for c=1:num_cond;
        left=(plot_width*(e-1))+(border*e)-border;
        bottom=(plot_height*((num_cond-c)))+(border*(num_cond-c))+border;
        width=plot_width;
        height=plot_height;

        subplot_handles(e,c)=axes('outerposition',[left bottom width height]);
        set(subplot_handles(e,c),'color','none','Xcolor',[1 1 1],'Ycolor',[1 1 1],'fontsize',10)
        hold on
        if e>1
            set(subplot_handles(e,c),'yticklabel',[])
        end
        if c<num_cond
            set(subplot_handles(e,c),'xticklabel',[])
        end
        if (num_electrodes*num_cond)>100
            set(subplot_handles(e,c),'xticklabel',[],'yticklabel',[])
        end
        if (num_electrodes*num_cond)<100
            if (c==1) & (~isempty(x_title));
                title([x_title(e)],'color',[1 1 1]);
            end
            if (e==1) & (~isempty(y_title));
                ylabel([y_title(c)],'color',[1 1 1])
            end
        end
    end
end
        drawnow




%fighandle=figure;
% count=0
% for e=1:num_electrodes
%     for c=1:num_cond
%         count=count+1
%         subplot_handles(e,c)=subplot(round(sqrt(num_electrodes*num_cond)),round(sqrt(num_electrodes*num_cond)),count);
%         set(subplot_handles(e,c),'color','none','Xcolor',[1 1 1],'Ycolor',[1 1 1],'fontsize',10)
%         hold on
%         drawnow
%     end
% end