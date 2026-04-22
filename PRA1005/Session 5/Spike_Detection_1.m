clear all; close all
p = mfilename('fullpath');
if ispc; DRIVE=p(1:max(find(p=='\'))); else; DRIVE=p(1:max(find(p=='/'))); end
addpath(DRIVE); data_folder = get_drive;

P2=[ 112  1    18;
    106   2    15;
    13    1    25;
    160   1    20;
    158   3    11];

plot_autocorrelation=0;
do_PCA=0;

for P=1:size(P2,1)
    preprocessed_filename=[data_folder 'Patient_' num2str(P2(P,1)) '_preprocessed_data_site' num2str(P2(P,3)) '_CH' num2str(P2(P,2))   '.mat'];
    if exist(preprocessed_filename)==2
        load(preprocessed_filename)
        [sorted_data{P}]=manual_set_threshold_from_data(preprocessed_data,do_PCA,plot_autocorrelation);%manual_set_threshold_2021
    end
end

figure; set(gcf,'color','w')
for P=1:size(P2,1)
    subplot(3,size(P2,1),P)
    if ~isempty(sorted_data{P}.good_sorts{1})
        plot( [1:length(sorted_data{P}.waveforms)].*sorted_data{P}.t(2)*1000 ,sorted_data{P}.spike_window','color',[0.4 0.4 .4]); hold on;
        plot([1:length(sorted_data{P}.waveforms)].*sorted_data{P}.t(2)*1000 ,sorted_data{P}.waveforms','color','k','linewidth',2); hold on;
        axis tight; box off; xlabel('mSec')
        title([num2str(size(sorted_data{P}.spike_window,1)) ' spikes ' num2str(sorted_data{P}.spikes_per_sec',2) ' spikes/sec'])
        
        if plot_autocorrelation
            subplot(3,size(P2,1),P+size(P2,1))
            plot(sorted_data{P}.auto_bins.*1000,sorted_data{P}.auto_corr,'k','linewidth',2); hold on;axis tight;
            
            plot([.003 0.003].*1000,get(gca,'ylim'),'r:','linewidth',2);
            plot(-[.003 0.003].*1000,get(gca,'ylim'),'r:','linewidth',2);
            
            axis tight; box off; xlabel('mSec')
        end
        
        if do_PCA
            subplot(3,size(P2,1),P),cla
            plot( [1:length(sorted_data{P}.waveforms)].*sorted_data{P}.t(2)*1000 ,sorted_data{P}.spike_window','color',[0.9 0.9 .9]); hold on;
            idx1=find(sorted_data{P}.idx(:,sorted_data{P}.good_sorts{1})==sorted_data{P}.good_sorts{2}(1))';
            plot( [1:length(sorted_data{P}.waveforms)].*sorted_data{P}.t(2)*1000 ,sorted_data{P}.spike_window(idx1,:)','color',[.4 0.4 .4]); hold on;
            plot([1:length(sorted_data{P}.waveforms)].*sorted_data{P}.t(2)*1000 ,sorted_data{P}.waveforms','color','k','linewidth',2); hold on;
            axis tight; box off; xlabel('mSec')
            title([num2str(length(idx1)) ' spikes ' num2str(sorted_data{P}.spikes_per_sec',2) ' spikes/sec'])
            
            subplot(3,size(P2,1),P+size(P2,1)+size(P2,1))
            [pc,score, latent, tsquare] = stats_pca(sorted_data{P}.spike_window);
            plot(score(:,1),score(:,2),'.','color',[0.4 0.4 .4],'markersize',1); hold on
            
            idx=find(sorted_data{P}.idx(:,sorted_data{P}.good_sorts{1})==sorted_data{P}.good_sorts{2})';
            plot(score(idx,1),score(idx,2),'.','color','k','markersize',2); hold on
            axis tight; box off; xlabel('PCA1'); ylabel('PCA2');
            axis square
        end
    end
end

p = mfilename('fullpath');
mkdir([DRIVE 'results'])
screen_size = get(0, 'ScreenSize');screen_size(2)=screen_size(2)/2;
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [0 0 screen_size(3) screen_size(4) ] ); %set to scren size
set(gcf,'PaperPositionMode','auto') %set paper pos for printing
saveas(gcf,[DRIVE 'results' DRIVE(end) 'Results_part1.png'])
