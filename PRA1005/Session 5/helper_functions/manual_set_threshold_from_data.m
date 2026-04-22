function  [sorted_data]=manual_set_threshold_from_data(preprocessed_data,full_sorting,plot_autocorrelation)

hold_data=preprocessed_data;
triggers=[];
if size(preprocessed_data.Data,2)>1
    triggers=preprocessed_data.Data(:,2)-mean(unique(preprocessed_data.Data(:,2)));
    preprocessed_data.Data=preprocessed_data.Data(:,1);
end

p=audioplayer(preprocessed_data.Data*100,preprocessed_data.SampFreq);
new_threshold=1;
sorted_data=[];      sorted_data.good_sorts{1}=[];
thrmin=0;
global play_sound;     play_sound=0;

while new_threshold==1;
    sorted_data=[];
    sorted_data.good_sorts{1}=[];
    
    figure('units','normalized','outerposition',[0 0.05 1 .9],'name',[' '],'menubar','none','color','w')
    %subplot('position',[0.0156    0.5569    0.9766    0.3681])
    H=subplot('position',[ 0.0156    0.0847    0.9766    0.8950],'ytick',[]); 
    
    t=preprocessed_data.t(1):preprocessed_data.t(2):preprocessed_data.t(3);
    if ~isempty(triggers)
       plot(t(1:end), triggers(1:length(t)),'color',[0.6 0.6 0.6]); hold on
    end
    plot(t(1:end), preprocessed_data.Data(1:length(t)),'k');set(gca,'ytick',[])
    hold on
    axis tight
    AUDIO_INDICATOR=plot([t(p.CurrentSample) t(p.CurrentSample)], get(gca,'ylim'),'m-','LineWidth',2 );
    set(gca,'xlim',[t(1) t(end)])
    thrmax=max(get(gca,'ylim'));
   % set(gca,'ylim',[-0.15 0.15]);
    global go_on;     go_on=0;
    pushbuttonPlot
    

    while go_on==0
        AUDIO_INDICATOR.XData=[t(p.CurrentSample) t(p.CurrentSample)];
        drawnow limitrate
        if play_sound==1
            play(p,p.CurrentSample);
            msg='play'
           % play_sound=0;
        elseif play_sound==-1
            stop(p)
            msg='stop'
           % set(gca,'xlim',[t(1) t(end)])
            play_sound=0;
        elseif  play_sound==2
            pause(p)
            msg='pause'
            play_sound=0;
        elseif play_sound==3
            msg='pointer'
            H=gca;
            for J=1:size(H.Children,1)
                if sum(H.Children(J).Color==[1 0 1])==3 && H.Children(J).LineWidth==0.5
                    pointer_time=(H.Children(J).XData(1));
                    [~,pix]=min(abs(t-pointer_time))
                    %delete p
                    %p=audioplayer(preprocessed_data.Data*100,preprocessed_data.SampFreq,'CurrentSample',pix);
                    stop(p);
                    play(p,pix);
                    delete(H.Children(J))
                    break
                end
            end
        elseif play_sound==4
            play(p,p.CurrentSample);
            msg='scope'
            set(gca,'xlim',[t(p.CurrentSample)-0.5  t(p.CurrentSample)+0.5])
        end
        LIM=get(gca,'ylim');
    end
    stop(p)
    
    start_time=t(1); stop_time=t(end);
    axis tight; drawnow; H=get(gca);
    for J=1:size(H.Children,1)
        if sum(H.Children(J).Color==[0 1 0])==3
            thrmin=(H.Children(J).YData(1))
        end
        
        if sum(H.Children(J).Color==[1 0 0])==3
            thrmax=(H.Children(J).YData(1))
        end
        
        if sum(H.Children(J).Color==[0 0 1])==3
            start_time=(H.Children(J).XData(1));
        end
        
        if sum(H.Children(J).Color==[0 0 .95])==3
            stop_time=(H.Children(J).XData(1));
        end
    end
    
    if thrmin~=0
        t_idx=find(t>=start_time & t<=stop_time);
        preprocessed_data.Data=preprocessed_data.Data(t_idx);
        t=t(t_idx);
        sorted_data.t=[t(1) median(diff(t)) t(end)];
         if ~isempty(triggers)
             triggers=triggers(t_idx);
             sorted_data.triggers=t(find(triggers>0.5));
         end
        size(preprocessed_data.Data)
        thrmin
        thrmax
        %if thrmin>0
            [sorted_data.spike_sample sorted_data.spike_window sorted_data.threshold sorted_data.threshold_artefact] = spike_detection(preprocessed_data.Data',thrmin,thrmax,preprocessed_data.SampFreq,'exact','pos');
        %else
         %    thrmax=min(get(gca,'ylim'));
          %  [sorted_data.spike_sample sorted_data.spike_window sorted_data.threshold sorted_data.threshold_artefact] = spike_detection(preprocessed_data.Data',thrmin,thrmax,preprocessed_data.SampFreq,'exact','neg');
        %end
        size(sorted_data.spike_window)
       % pause

        if  size(sorted_data.spike_window,1)>100 %%%~isfield(sorted_data,'idx') &
            pause(0.1)
            close gcf
            
            recording_time_spikes=size(preprocessed_data.Data,1)/preprocessed_data.SampFreq;
            count=0;
            [subplot_handles,a]=make_subplots(5,7,['1'],[],[],1);
            sorted_data.idx=[];
            if full_sorting==0
                
                tst=get(subplot_handles(1,2),'position'); P(1)=tst(1);
                tst=get(subplot_handles(1,6),'position');P(2)=tst(2);
                tst=get(subplot_handles(3,2),'position'); P(3)=tst(3);
                
                for jj=1:7 delete(subplot_handles(1,jj));end
                for jj=2:7 delete(subplot_handles(2,jj));end
                for jj=2:7 delete(subplot_handles(3,jj));end
                
                subplot(subplot_handles(2,1))
                set(gca,'position',[P(1) P(2) tst(3)*3.5 tst(4)*5])
                
                plot(1:size(sorted_data.spike_window,2),sorted_data.spike_window,'r-'); hold on
                sorted_data.idx(:,1)=ones(1,size(sorted_data.spike_window,1));
            else
                for row=1:2
                    for n_sorting=row:4
                        count=count+1;
                        [sorted_data.idx(:,count), spike_waveform, real_neurons] = spike_classification_auto(sorted_data.spike_window,n_sorting,row,1,recording_time_spikes,subplot_handles);
                        drawnow
                    end
                end
            end
            tst=get(subplot_handles(4,2),'position');
            tst2=get(subplot_handles(5,2),'position'); delete(subplot_handles(5,2))
            subplot(subplot_handles(4,2)), set(gca,'position',[tst(1) tst2(2) tst(3)*2.3 tst(4)])
            plot(t,preprocessed_data.Data(1:length(t)),'color','w'); hold all; set(gca,'xlim',[min(t) max(t)],'ylim',LIM)
            plot([min(t) max(t)], [sorted_data.threshold sorted_data.threshold],'g')
            plot([min(t) max(t)], [sorted_data.threshold_artefact sorted_data.threshold_artefact],'r')
            
            tst=get(subplot_handles(4,5),'position');
            tst2=get(subplot_handles(5,5),'position'); delete(subplot_handles(5,5))
            subplot(subplot_handles(4,5)), set(gca,'position',[tst(1) tst2(2) tst(3)*2.3 tst(4)])
            
            preprocessed_data.sorted_data{1}=sorted_data;
            [sorted_data.good_sorts,new_threshold]=clicksubplot_2001(subplot_handles,preprocessed_data,1,plot_autocorrelation);
            pause(0.1)
            close gcf
            
            if new_threshold==1
                clear  sorted_data
                preprocessed_data=hold_data;
            end
        else
            close gcf
            thrmin=0;
            preprocessed_data=hold_data;
            triggers=[];
            if size(preprocessed_data.Data,2)>1
                triggers=preprocessed_data.Data(:,2)-mean(unique(preprocessed_data.Data(:,2)));
                preprocessed_data.Data=preprocessed_data.Data(:,1);
            end
            new_threshold=1;
        end
    else
        close gcf
        new_threshold=0;
    end
end




if isfield(sorted_data,'good_sorts') & ~isempty(sorted_data.good_sorts{1})
    %%%%%%%%%%%5 now we do the analysis
    sorted_data.real_neurons=size(sorted_data.good_sorts{2},2);
    spike_time_axis=(1:length(preprocessed_data.Data))./preprocessed_data.SampFreq;
    t=sorted_data.t(1):sorted_data.t(2):sorted_data.t(end);
    bins=preprocessed_data.t(1):1:preprocessed_data.t(end);
    
    spike_waveform=[];
    for SPIKE=1:size(sorted_data.good_sorts{2},2)
        spike_idx{SPIKE}=find(sorted_data.idx(:,sorted_data.good_sorts{1})==sorted_data.good_sorts{2}(SPIKE));
        spike_waveform(SPIKE,:)=mean(sorted_data.spike_window(spike_idx{SPIKE},:));
    end
    sorted_data.waveforms=spike_waveform;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % figure, set(gcf,'name', ['channel ' num2str(K) ' depth ' num2str(save_data.depths(D)) ])
    for SPIKE=1:sorted_data.real_neurons
        %subplot(2,2,1)
        %plot([1:size(spike_waveform,2)].*preprocessed_data.SampFreq,spike_waveform(SPIKE,:)); hold all
        %title('spike waveform');
        
        recording_time_spikes=size(preprocessed_data.Data,1)/preprocessed_data.SampFreq;
        sorted_data.spikes_per_sec(SPIKE,1)=length(spike_idx{SPIKE})/recording_time_spikes;
        inter_spike_interval=diff(  spike_time_axis(sorted_data.spike_sample(spike_idx{SPIKE})));
        sorted_data.cooeficient_variation(SPIKE)=(std(inter_spike_interval))/mean(inter_spike_interval);
        sps=[];
        for b=1:length(bins)-1
            sps(b)=length(find(spike_time_axis(sorted_data.spike_sample(spike_idx{SPIKE}))>bins(b) & spike_time_axis(sorted_data.spike_sample(spike_idx{SPIKE}))<bins(b+1)));
        end
        sps=sps./(mean(diff(bins))*10);
        sps(find(sps==0))=[];
        sorted_data.fano_factor(SPIKE) =var(sps)/mean(sps);
        
        Spike.T = spike_time_axis(sorted_data.spike_sample(spike_idx{SPIKE})); % Load spike times here.
        Spike.C = ones(1,length(Spike.T));  % Load spike channels here.
        Nspk = 10; % Set N
        ISI_N = 0.10; % Set ISI_N threshold [sec]
        % Run the detector
        %[Spike.Burst Spike.N] = BurstDetectISIn( Spike, Nspk, ISI_N );
        %subplot(2,2,4)
        %plot([0 mean(Spike.Burst.T_end-Spike.Burst.T_start)],[0 0],'r-'); hold on
        
        [sorted_data.auto_corr(SPIKE,:),bins2,sorted_data.N_spikes(SPIKE)] = autoXcorrelation( Spike.T,Spike.T,.025,0.0005);
        sorted_data.auto_corr(SPIKE,round(size(sorted_data.auto_corr,2)/2))=NaN;
        sorted_data.auto_bins=bins2;
        %subplot(2,2,2)
        %plot(bins2,sorted_data.auto_corr(SPIKE,:)); hold all
        %plot([0.002 0.002],get(gca,'ylim'),'k:'); hold on
        sorted_data.spike_objects(SPIKE)=Spike;
        
        if length(sorted_data.real_neurons>1)
            %   subplot(2,2,3)
            for SPIKE2=sorted_data.real_neurons
                if SPIKE<SPIKE2
                    time1= spike_time_axis(sorted_data.spike_sample(spike_idx{SPIKE}));
                    time2= spike_time_axis(sorted_data.spike_sample(spike_idx{SPIKE2}));
                    [sorted_data.cross_corr(SPIKE,SPIKE2,:),bins2,N_spikes] = autoXcorrelation( time1,time2,.025,0.0005);%0.00025);
                    sorted_data.cross_corr(SPIKE,SPIKE2,round(size(sorted_data.cross_corr,3)/2))=NaN;
                    %          plot(bins2,squeeze(sorted_data.cross_corr(SPIKE,SPIKE2,:))); hold all
                    %         title('cross correlation')
                end
            end
        else
            sorted_data.cross_corr2=[];
        end
        
        if ~isempty(triggers)
            n=[];bin_width=0.01;
            for trl=1:length(sorted_data.triggers)
                [n(trl,:),xout]=hist(t(sorted_data.spike_sample(spike_idx{SPIKE}))-sorted_data.triggers(trl),[-0.2:0.005:0.5]);
            end
            n(:,[1 end])=NaN;
            sorted_data.trig_resp(SPIKE,:)=mean(n)./bin_width;
            sorted_data.trig_resp_bins=xout;
        end
    end
else
    sorted_data.good_sorts{1}=[];
end


