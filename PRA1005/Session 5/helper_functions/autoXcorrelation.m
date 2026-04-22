function [curr_corr,bins,N_spikes] = autoXcorrelation(ref_spikes,sig_spikes,corr_distance,fsample)
%%% input is normally in spike times %%%

tst=unique(ref_spikes(:));
if length(unique(ref_spikes(:)))==2 & tst(1)==0;%% this is for data which is 0s and 1s
%     out=[];
%     for trl=1:size(ref_spikes,1)
%         out(trl,:)=xcorr(ref_spikes(trl,:));
%     end
%     subplot(2,2,3)
%     curr_corr=mean(out);
%     curr=find(curr_corr==max(curr_corr));
%     curr_corr(curr)=mean([curr_corr(curr-1) curr_corr(curr+1)]);
%     plot(curr_corr)
    
    hold_ref=ref_spikes;hold_sig=sig_spikes;
    ref_spikes=NaN(size(ref_spikes));
    sig_spikes=NaN(size(sig_spikes));
    for trl=1:size(hold_ref,1)
        curr=find(hold_ref==1)./1000;
        ref_spikes(trl,1:length(curr))=curr;
          curr=find(hold_sig==1)./1000;
        sig_spikes(trl,1:length(curr))=curr;
    end
end



% corr_distance=0.01; %width of the correlation is seconds
% fsample=0.0005;
bins=[-corr_distance: fsample:corr_distance];
[X,Y]=find(~isnan(ref_spikes));
trl_count=0;
master_N=zeros(length(unique(X)),length(bins));
num_trls=length(unique(X));
for trl=unique(X)';
    trl_count=trl_count+1;
    trl_sig_spikes=sig_spikes(trl,:);
    trl_sig_spikes=trl_sig_spikes(~isnan(trl_sig_spikes));
    
    trl_ref_spikes=ref_spikes(trl,:);
    trl_ref_spikes=trl_ref_spikes(~isnan(trl_ref_spikes));
    count=0;
    for ref_spk=trl_ref_spikes
        count=count+1;
        curr_sig_spikes=trl_sig_spikes(find(trl_sig_spikes>(ref_spk-corr_distance) & trl_sig_spikes<(ref_spk+corr_distance)));
        if ~isempty(curr_sig_spikes)
            curr_sig_spikes=curr_sig_spikes-ref_spk;
            [n,xout]=hist(curr_sig_spikes,bins);
            for B=1:length(bins)
                master_N(trl_count,B)=master_N(trl_count,B)+n(B);
            end
        end
    end
end
if trl_count>1
    curr_corr=squeeze(mean(master_N(1:trl_count,1:length(bins), 'omitnan'),1 ));
else
    curr_corr=squeeze(master_N(:,1:length(bins)));
end
N_spikes=length(ref_spikes);
curr_corr=curr_corr/N_spikes;

%curr=find(curr_corr==max(curr_corr));
%curr_corr(curr)=mean([curr_corr(curr-1) curr_corr(curr+1)]);
% subplot(2,2,1)
% plot(bins,curr_corr,'r')

% data=[];
% data.label={'test'};
% data.time={bins};
% data.trial={curr_corr};
% data.fsample=length(0:fsample:1)
% 
% cfg=[]; cfg.method='mtmfft';
% cfg.keeptrials= 'no';
% cfg.keeptapers    = 'no';  cfg.channel= 'all'; cfg.pad = 'maxperlen';
% cfg.output = 'pow';
% cfg.precision ='single';
% %cfg.taper='hanning';
%  cfg.taper='dpss';
%  cfg.tapsmofrq=2;
% % cfg.foilim=[2,120]; %top was 24 14Hz
% ft=ft_freqanalysis(cfg,data);
% subplot(2,2,2)
% plot(ft.freq,ft.powspctrm)
