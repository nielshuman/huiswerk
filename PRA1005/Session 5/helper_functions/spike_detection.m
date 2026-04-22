function [spike_sample spike_window threshold threshold_artefact] = spike_detection(signal,factormin,factormax,fr_spike1,detect_method,pos_neg)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [spike_sample spike_window] = spike_detection(signal,factormin,factormax%
% ,fr_spike1,detect_method,pos_neg)                                       `%
%                                                                         %
% This function can be used to perform spike detection using either       %
% the median thresholds or the envelope threshold approach.               %
%                                                                         %
% INPUT:                                                                  %
% signal = the signal to be analyzed for spike detection                  %
% factormin = the factor with which the median or envelope needs to be    %
%             multiplied in order to obtain the threshold for spike       %
%             detection                                                   %
% factormax = the factor with which the median or envelope needs to be    %
%             multiplied in order to obtain the threshold for artifact    %
%             rejection                                                   %
% fr_spike1 = samplerate of the spike signal                              %
% detect_method = method used for spike detection, either envelope or     %
%                 median                                                  %
% pos_neg = a negative or positive or a positive threshold can be used for%
%           spike detection: pos/neg                                      %
%                                                                         %
% OUTPUT:                                                                 %
% spikes_sample = a vector with the sampletimes at which the spikes were  %
%                 detected                                                %
% spike_window = a matrix with the waveforms of the detected spikes       %
%                                                                         %
% written by D.G.M. de Klerk 22-02-2010 (d.g.m.deklerk@utwente.nl)        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Retrieving samples at which spikes occur

%threshold
if strcmp(detect_method,'median')
    noise_std_detect = median(abs(signal))/0.6745;
    threshold = factormin * noise_std_detect;
    threshold_artefact = factormax * noise_std_detect;
elseif strcmp(detect_method,'envelope')
    signal_complex = hilbert(signal);  % Constructed a complex signal
    A_signal = abs(signal_complex);    % Instantaneous amplitude. Optimal estimate
                                       % of the envelope of the signal
	max_hist = (1.5*max(abs(A_signal)));
    binsize  = max_hist/1e5;                                         
    edges    = binsize:binsize:max_hist;
    N        = hist(A_signal,edges);   % Generate histogram
    N        = N(1:end-1);             % Skipping last bin which contain data higher than 100 uV
    edges    = edges(1:end-1);
    Nn       = N/(sum(N)*binsize);     % Normalize histogram
    p_max    = max(Nn);
    aux      = find(Nn>=0.9*p_max);

    mode_rayleigh = sum(Nn(aux).*edges(aux))/sum(Nn(aux));
    clear aux
    threshold = factormin * mode_rayleigh;
    threshold_artefact = factormax * mode_rayleigh;
elseif strcmp(detect_method,'exact')
    threshold=factormin;
    threshold_artefact=factormax;
else disp('error: detection method does not exist')
end

%get peak above threshold
length(find(signal>threshold))./length(signal);
if strcmp(pos_neg,'neg')
    [spike_sample_with_artefact]=get_peaks(-signal, -threshold, 2);
else
    [spike_sample_with_artefact]=get_peaks(signal, threshold, 2);
end

spike_sample =[];
if spike_sample_with_artefact~=0
    count = 0;
    %checking remaining checking for being lower than the artefact
    %threshold and being more than 8 samples apart
    for i = 1 : length(spike_sample_with_artefact)-1
        if abs(signal(spike_sample_with_artefact(i)))<abs(threshold_artefact)
            if (spike_sample_with_artefact(i+1)-spike_sample_with_artefact(i))>round(8e-4*fr_spike1)
                count=count+1;
                spike_sample(count) = spike_sample_with_artefact(i);
            end
        end
    end
    %checking last sample for being lower than the artefact threshold
    if abs(signal(spike_sample_with_artefact(end)))<threshold_artefact
       count=count+1;
       spike_sample(count) = spike_sample_with_artefact(end);
    end
end

%% Signal around spikes
%Put 1 ms before and 2 ms after entire signal. When extracting signal
%before and after peak, it might go wrong when the peak is right at the
%beginning or end
signal_incl_zeros = [zeros(1,round(0.001*fr_spike1)) signal zeros(1,round(0.002*fr_spike1))];

%analyse per spike
spike_window = [];

if ~isempty(spike_sample)
     progressbar(0, 0, 'get spike windows');
    for i=1:length(spike_sample)
        [d,h,m,s]=progressbar(i/length(spike_sample), 0, 'get spike windows');
        % if d>1 | h>1 | m>1 | s>60
        %     % Create time string
        %     if d > 0
        %         if d > 9
        %             timestr = sprintf('%d day',d);
        %         else
        %             timestr = sprintf('%d day, %d hr',d,h);
        %         end
        %     elseif h > 0
        %         if h > 9
        %             timestr = sprintf('%d hr',h);
        %         else
        %             timestr = sprintf('%d hr, %d min',h,m);
        %         end
        %     elseif m > 0
        %         if m > 9
        %             timestr = sprintf('%d min',m);
        %         else
        %             timestr = sprintf('%d min, %d sec',m,s);
        %         end
        %     else
        %         timestr = sprintf('%d sec',s);
        %     end
        %     timestr
        %     break
        % end
                
        %the piece of signal around the spike is 1ms before and 2ms after
        %peak
        spike_window = [spike_window ; signal_incl_zeros(spike_sample(i):spike_sample(i)+round(0.003*fr_spike1))];
    end
    progressbar(1, 0, 'finished')
end