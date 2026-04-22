function [peaks]=get_peaks(signal, threshold, method)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [peaks]=get_peaks(signal, threshold, method)                          %
%                                                                       %
% Defining peaks of a signal above a certain threshold using two methods%
%                                                                       %
% Method:   - 1 = use 2 neighbouring data points have a lower value     %
%           - 2 = use max in an interval during which the threshold is  %
%           exceeded (last maximal value of the period is used, when    %
%           more than one point in time has the max value)              %
% OUTPUT: - peaks = contains samplenumbers of the peaks                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Defining signal above threshold
signal_threshold=find(signal>=threshold);

% Defining peaks in signal above threshold
if method==1
    
    % Defining peaks using method 1
    j=1;
    for i=2:(length(signal_threshold)-1)
        if signal(signal_threshold(i))>signal(signal_threshold(i-1))&& signal(signal_threshold(i))>signal(signal_threshold(i+1));
            peaks(j)=signal_threshold(i);
            j=j+1;
        end
    end
else
    
    % Defining peaks using method 2
    i=1;
    j=1;
    
    % First: define separate intervals during which the signal exceeded the
    % threshold
    for k=1:length(signal_threshold)-1
        if signal_threshold(k)+1==signal_threshold(k+1)
            int_exc_threshold_time(i,j)=signal_threshold(k);
            int_exc_threshold_amp(i,j)=signal(signal_threshold(k));
            j=j+1;
        else int_exc_threshold_time(i,j)=signal_threshold(k);
            int_exc_threshold_amp(i,j)=signal(signal_threshold(k)); 
            i=i+1;
            j=1;
        end
    end
    
    %Filling in the last sample
    if ~isempty(signal_threshold) && length(signal_threshold)>1
        int_exc_threshold_time(i,j)=signal_threshold(end);
        int_exc_threshold_amp(i,j)=signal(signal_threshold(end));
    end
    
    % Second: define the max during the separate intervals
    if exist('int_exc_threshold_time','var')
        for m=1:size(int_exc_threshold_time,1)
            peak_temp=int_exc_threshold_time(m,find(int_exc_threshold_amp(m,:)==max(int_exc_threshold_amp(m,:)))); %#ok<FNDSB>
            %use last point in time when more than one point in time have
            %max value
            peaks(m)=peak_temp(end);
        end
    end
end

%If output doesn't exist, it is defined zero
if ~exist('peaks','var')
    peaks=[0];
end