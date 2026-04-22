function  [good_sorts, new_threshold]=clicksubplot_2001(subplot_handles,preprocessed_data,sorter_identifier,plot_autocorrelation)

new_threshold=0;

subplot(subplot_handles(3,1))
title('new threshold','fontsize',14,'fontweight','bold','color','w')
set(gca,'color','y')

subplot(subplot_handles(4,1))
title('accept selection','fontsize',14,'fontweight','bold','color','w')
set(gca,'color','g')

if size(preprocessed_data.sorted_data{sorter_identifier}.idx,2)>1
    subplot(subplot_handles(5,1))
    title('cancel selection','fontsize',14,'fontweight','bold','color','w')
    set(gca,'color','r')
end

line_types = {'.r', '.g', '.m', '.b', '.c', '.y'};
line_types2 = {'r', 'g', 'm', 'b', 'c', 'y'};

Xs=[];Ys=[]; all_tim=[];
good_sorts{1}=[];good_sorts{2}=[];sp_h=[];

if size(preprocessed_data.sorted_data{sorter_identifier}.idx,2)==1
    plot_spikes=1;
    good_sorts{1}=1;
    good_sorts{2}=1;
    
    X=2; Y=1; Xs=1; Ys=1;
    subplot(subplot_handles(4,5))
    sp_idx=find(preprocessed_data.sorted_data{sorter_identifier}.idx==1);
    tim=(preprocessed_data.sorted_data{sorter_identifier}.spike_sample(sp_idx).*preprocessed_data.t(2))+preprocessed_data.t(1);
    binwidth=0.05;
    [n,xout]=hist(tim,preprocessed_data.t(1):binwidth:preprocessed_data.t(3));
    n=fastsmooth(n./binwidth,5,3,1);
    sp_h(length(Xs))=plot(xout,n,'r','linewidth',2);
    title('Firing rate over time','color','r')
    
    if plot_autocorrelation
        subplot(subplot_handles(5,6))
        [auto_corr,bins2,N_spikes] = autoXcorrelation(tim,tim,.025,0.00025);%0.00025);
        bins2=bins2*1000;
        auto_corr(round(size(auto_corr,2)/2))=NaN;
        auto_h(length(Xs))=plot(bins2,auto_corr,line_types2{X-1},'linewidth',2);
        set(gca,'xlim',[bins2(1) bins2(end)],'xticklabelmode','auto')
        all_tim{length(all_tim)+1}=tim;
        plot([.003 0.003]*1000,get(gca,'ylim'),'r:');
        plot(-[.003 0.003]*1000,get(gca,'ylim'),'r:');
        
        title('autocorrelation','color','r')
        
        
        
        if length(all_tim)==3
            subplot(subplot_handles(5,3))
            [auto_corr,bins2,N_spikes] = autoXcorrelation(all_tim{1},all_tim{2},.025,0.00025);
            cross_h(1)=plot(bins2,auto_corr,'r','linewidth',2);
            [auto_corr,bins2,N_spikes] = autoXcorrelation(all_tim{1},all_tim{3},.025,0.00025);
            cross_h(2)=plot(bins2,auto_corr,'g','linewidth',2);
            [auto_corr,bins2,N_spikes] = autoXcorrelation(all_tim{2},all_tim{3},.025,0.00025);
            cross_h(3)=plot(bins2,auto_corr,'b','linewidth',2);
            plot([0 0],get(gca,'ylim'),'w:');
            set(gca,'xlim',[bins2(1) bins2(end)])
        end
    end
end


while 1 == 1
    w = waitforbuttonpress;
    switch w
        case 1 % keyboard
            key = get(gcf,'currentcharacter');
            if key==27 % (the Esc key)
                try; delete(h); end
                break
            end
        case 0 % mouse click
            mousept = get(gca,'currentPoint');
            x = mousept(1,1);
            y = mousept(1,2);
            try; delete(h); end
            h = text(x,y,get(gca,'tag'),'vert','middle','horiz','center');
            
            H=gca;
            if ~isempty(H.Title.String)
            [X,Y]=find(subplot_handles==H);
            plot_spikes=0;
            
            if X>1
                set(gca,'xcolor','r','ycolor','r','linewidth',3), box on
                Xs=[Xs X];  Ys=[Ys Y];
                
                %%%%%%%%%%%%%%%
                if Y>1 & X>1
                    plot_spikes=1;
                elseif Y==1 & X>1
                    if X<3
                        plot_spikes=1;
                    end
                end
            end
            
            
            if plot_spikes
                subplot(subplot_handles(4,5))
                sp_idx=find(preprocessed_data.sorted_data{sorter_identifier}.idx(:,Y)==(X-1));
                tim=(preprocessed_data.sorted_data{sorter_identifier}.spike_sample(sp_idx).*preprocessed_data.t(2))+preprocessed_data.t(1);
                binwidth=0.05;
                [n,xout]=hist(tim,preprocessed_data.t(1):binwidth:preprocessed_data.t(3));
                n=fastsmooth(n./binwidth,5,3,1);
                sp_h(length(Xs))=plot(xout,n,line_types2{X-1},'linewidth',2);
                
                if plot_autocorrelation
                    subplot(subplot_handles(5,6))
                    [auto_corr,bins2,N_spikes] = autoXcorrelation(tim,tim,.025,0.00025);%0.00025);
                    bins2=bins2*1000;
                    auto_corr(round(size(auto_corr,2)/2))=NaN;
                    auto_h(length(Xs))=plot(bins2,auto_corr,line_types2{X-1},'linewidth',2);
                    set(gca,'xlim',[bins2(1) bins2(end)],'xticklabelmode','auto')
                    all_tim{length(all_tim)+1}=tim;
                    plot([.003 0.003],get(gca,'ylim'),'r:');
                    plot(-[.003 0.003],get(gca,'ylim'),'r:');
                    
                    
                    if length(all_tim)==2
                        subplot(subplot_handles(5,3))
                        [auto_corr,bins2,N_spikes] = autoXcorrelation(all_tim{1},all_tim{2},.025,0.00025);
                        cross_h(1)=plot(bins2,auto_corr,'w','linewidth',2);
                        plot([0 0],get(gca,'ylim'),'w:');
                        set(gca,'xlim',[bins2(1) bins2(end)])
                    end
                    
                    if length(all_tim)==3
                        subplot(subplot_handles(5,3))
                        [auto_corr,bins2,N_spikes] = autoXcorrelation(all_tim{1},all_tim{2},.025,0.00025);
                        cross_h(1)=plot(bins2,auto_corr,'r','linewidth',2);
                        [auto_corr,bins2,N_spikes] = autoXcorrelation(all_tim{1},all_tim{3},.025,0.00025);
                        cross_h(2)=plot(bins2,auto_corr,'g','linewidth',2);
                        [auto_corr,bins2,N_spikes] = autoXcorrelation(all_tim{2},all_tim{3},.025,0.00025);
                        cross_h(3)=plot(bins2,auto_corr,'b','linewidth',2);
                        plot([0 0],get(gca,'ylim'),'w:');
                        set(gca,'xlim',[bins2(1) bins2(end)])
                    end
                end
            end
            end
            if Y==1 & X==5
                good_sorts{1}=[];good_sorts{2}=[];
                for i=1:length(Ys)
                    subplot(subplot_handles(Xs(i),Ys(i)))
                    set(gca,'xcolor','w','ycolor','w','linewidth',1,'ytick',[],'xtick',[]), box off
                end
                subplot(subplot_handles(4,5)); cla
                subplot(subplot_handles(5,6)); cla
                subplot(subplot_handles(5,3)); cla
                all_tim=[];
                
                Xs=[];  Ys=[];
            end
            
            if Y==1 & X==3
                new_threshold=1;
                break
            end
            
            if Y==1 & X==4
                break
            end
            
            if length(unique(Ys))>1
                delete(sp_h)
                clear sp_h
                
                delete(auto_h)
                clear auto_h
                
                delete(cross_h)
                clear cross_h
                
                for i=1:length(Ys)
                    subplot(subplot_handles(Xs(i),Ys(i)))
                    set(gca,'xcolor','w','ycolor','w','linewidth',1,'ytick',[],'xtick',[]), box off
                end
                Xs=[X];  Ys=[Y];
                set(gca,'xcolor','r','ycolor','r','linewidth',3)
                hld=gca;
                
                subplot(subplot_handles(4,5))
                sp_idx=find(preprocessed_data.sorted_data{sorter_identifier}.idx(:,Y)==(X-1));
                tim=(preprocessed_data.sorted_data{sorter_identifier}.spike_sample(sp_idx).*preprocessed_data.t(2))+preprocessed_data.t(1);
                [n,xout]=hist(tim,preprocessed_data.t(1):0.05:preprocessed_data.t(3));
                n=fastsmooth(n./binwidth,5,3,1);
                sp_h(length(Xs))=plot(xout,n,line_types2{X-1},'linewidth',2);
                
                if plot_autocorrelation
                    subplot(subplot_handles(5,6))
                    [auto_corr,bins2,N_spikes] = autoXcorrelation(tim,tim,.025,0.00025);
                    auto_corr(round(size(auto_corr,2)/2))=NaN;
                    auto_h(length(Xs))=plot(bins2,auto_corr,line_types2{X-1},'linewidth',2);
                    set(gca,'xlim',[bins2(1) bins2(end)])
                end
                subplot(subplot_handles(5,3))
                cla
                
                all_tim=[];
                all_tim{1}=tim;
                subplot(hld)
            end
            good_sorts{1}=unique(Ys);
            good_sorts{2}=Xs-1;
    end
end

