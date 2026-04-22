function [idx, spike_waveform real_neurons] = spike_classification(spike_window,n_sorting,row,idx,recording_time_spikes,subplot_handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is created to classify the neurons based on the waveforms %
% of their AP.                                                            %
% First, principal component analysis is performed. Second, the first and %
% second principal components are used for clustering. Two cluster-methods%
% are available, namely K-means and Bayesian clustering, which uses a     %
% probability density function (Gaussian mixture model) and expectation   %
% maximization.                                                           %
%                                                                         %
% Input:                                                                  %
% - spike_window = the waveforms of the detected spikes                   %
%                                                                         %
% Output:                                                                 %
% - idx = a vector with indication of neuron-number per spike-sample      %
%         e.g. [1 1 2 3 1]                                                %
%                                                                         %
% Written by D.G.M. de Klerk 13-01-10 (d.g.m.deklerk@utwente.nl)          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%principal component analysis, with first three components specified
%(comp1, comp2, and comp3)
%%[pc,score,latent,tsquare] = princomp(spike_window);
[pc,score, latent, tsquare] = pca(spike_window);

comp1 = score(:,1);
comp2 = score(:,2);
comp3 = score(:,3);

%define different colors for the plots per neuron
line_types = {'.r', '.g', '.m', '.b', '.c', '.y'};
line_types2 = {'r', 'g', 'm', 'b', 'c', 'y'};
line_colors = {'red', 'green', 'magneta', 'blue', 'cyan', 'yellow'};

subs= [1:5;6:10;11:15;16:20;21:25];
subs2=[16:20;21:25;26:30;31:35];

if size(idx)==1
    %specify the amount of neurons that were measured
    nb_neurons = n_sorting;
    if row==1
        %Kmeans is used to cluster the first two principal components
        idx = kmeans([comp1 comp2],nb_neurons);
    elseif row==2
        X=[comp1 comp2];
        %Gaussian mixture model
        a=0;
        while a==0
            try
                obj = gmdistribution.fit(X,nb_neurons);
                idx = cluster(obj,X);
                a=1;
            end
        end
        %Use the gaussian mixture model and expectation maximization to
        %clusster neurons
    end
else
    nb_neurons=length(unique(idx));
end

%plot waveforms of spikes of different neurons
max_spikes_to_plot=250;
for i=1:nb_neurons
    if row==1
        subplot(subplot_handles(i+1,nb_neurons));%  7,5,subs(nb_neurons,i+1)),
    else
         subplot(subplot_handles(i+1,nb_neurons+3)),
    end
    pl_idx=find(idx==i);
    if length(find(idx==i))>1
        if length(find(idx==i))<max_spikes_to_plot
            plot(1:size(spike_window,2),spike_window(idx==i,:)',line_types2{i} ,1:size(spike_window,2),mean(spike_window(idx==i,:)),'k')
        else
            r_idx=randperm(length(pl_idx));            pl_idx=pl_idx(r_idx(1:max_spikes_to_plot));
            plot(1:size(spike_window,2),spike_window(pl_idx,:)',line_types2{i} ,1:size(spike_window,2),mean(spike_window(idx==i,:)),'k')
        end
    end
    axis tight
    title([num2str(length(find(idx==i))/recording_time_spikes,2) 'spk/s'],'color','w')
    %plot 1st and 2nd component of principal component analysis, with the
    %different neurons indicated
    if row==1
         subplot(subplot_handles(1,nb_neurons));%subplot(7,5,subs(nb_neurons,1))
    else
         subplot(subplot_handles(1,nb_neurons+3));%subplot(7,5,subs2(nb_neurons,1))
    end
        pl_idx=find(idx==i);
    plot(comp1(pl_idx),comp2(pl_idx),line_types{i},'markersize',1)
    hold on,  axis square,    axis tight
end


hold off


[real_neurons] = nb_neurons;% listdlg('PromptString','Select real neurons:',...

for i=1:nb_neurons
    if length(find(idx==1))>10
    spike_waveform(i,:) = mean(spike_window(idx==i,:));
    else
        spike_waveform(i,:)=NaN(1,64);
    end
end




