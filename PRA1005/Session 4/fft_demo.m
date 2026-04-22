%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all, clear all
%%%%%%%%%%%%%%%%%%%% make a signal that you will analysis with FFT
Fs = 1000;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = 1000;             % Length of signal
t = (0:L-1)*T;        % Time vector
number_of_components=3  %choose something interesting

frequencies=sort(round(rand(1,number_of_components).*100)); %choose some random numbers between 0 and 100Hz
phases=rand(1,number_of_components).*180; %% choose some random starting phases
phases=(phases*(pi/180)); %% convert the starting phases into radiens

powers=rand(1,number_of_components); %% choose some random amplitudes

%%%%%%% start with a signal of zeros
X=zeros(size(t));
%%% then add the sine waves with each power and frequency
subplot(1,2,1),%set(gca,'position',[ 0.5703    0.5838    0.3347    0.3412])
for S=1:number_of_components
    Sine_wave = powers(S)*sin(2*pi*frequencies(S)*t+phases(S));

    plot(t*Fs,Sine_wave+(S*2)); hold on; %% plot the sine waves with an offset so you can see them
    X = X+Sine_wave;
    text(t(end)*Fs,S*2,[num2str(frequencies(S)) 'Hz pow=' num2str(powers(S),2) ' ph='  num2str(phases(S),2) 'rad']) 
end
set(gca,'tickdir','out','ytick',[],'ycolor','w'); box off, set(gcf,'color','w','name','some sine waves')
xlabel('time (milliseconds)');title('components')

subplot(2,2,2); set(gca,'position',[0.6388    0.3309    0.3347    0.3412])
plot(Fs*t,X)
ylabel('amplitude');xlabel('time (milliseconds)')
title('a noisy signal')
set(gca,'tickdir','out'); box off, set(gcf,'color','w')



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure
Y = fft(X); % do a fast fourier transform of the signal that you made
plot([-L/2 +L/2],[0 0],'k-'); hold on; plot([0 0],[-L/2 +L/2],'k-'); hold on %% make some dark grid lines
plot(Y); hold on%% plot the result
set(gca,'xlim',[-L/2 L/2],'ylim',[-L/2 +L/2]);
grid on
xlabel('real part'); ylabel('imaginary part');title('complex plane');
set(gcf,'color','w','name','this plot does not realy tell you anything')

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%% make sense of the FFT result
figure
subplot(2,1,1)
P2 = abs(Y/L); %%power is the absalute of the complex numbers
plot(P2)
title('abs of FFT output')
xlabel(['there are as many numbers here as samples'])
P1 = P2(1:L/2+1); %% you only want the first half of the result from FFT
P1(2:end-1) = 2*P1(2:end-1); %% because you have thrown away half the result, double the power in the remaining part expect for the power in the 0Hz component.

%%%%%%%%%%%% work out the numbers for the frequency axis
%%% this bit you need to solve for yourself! (remember the nyquist frequency is the highest frequency you can measure)
nyquist_frequency=[ ]

%%% this is the lowest frequency you can measure, and also the smallest frequency difference you can measure. you need one cycle in your compleat data set
%%% if you think that having the length of your signal in seconds would be helpful you can calculate it as the length of the signal (L) divided by the sample frequency (FS)
%%% if you think you might like to know what the biggest number that would fit once into that time would be you can calculate 1/ that time
frequency_resolution=[ ] %% 

if isempty(nyquist_frequency)
    subplot(2,1,2)
    title('fill in the missing numbers','fontsize',20,'color','r')
end
if ~isempty(nyquist_frequency)
subplot(2,1,2)
frequency_axis=[0:frequency_resolution:nyquist_frequency];
plot(frequency_axis,P1);
title('Power Spectrum')
xlabel('frequency (Hz)')
ylabel('Power')
set(gca,'tickdir','out','fontsize',16); box off, set(gcf,'color','w')



%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%find out where the peaks in the power spectrum are
FFT_frequencies=frequency_axis(find(P1>0.0001))
frequencies

FFT_power=P1(find(P1>0.0001))
powers

fft_phases=(angle(Y(find(P1>0.00001)))+(pi/2));
fft_phases(find(fft_phases<0))=fft_phases(find(fft_phases<0))+pi
(phases)
end


%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%get the original signal back from the FFT
figure
subplot(2,2,1)
new_X=ifft(Y); %% use the inverse FFT function
plot(t,new_X);

count=0;
subplot(1,2,2)
for JJ=find(P1>0.0001)
    count=count+1;
    Y_cut=Y;
    Y_cut([1:JJ-1 JJ+1:end])=Y_cut([1:JJ-1 JJ+1:end]).*0;%% set the power of all other frequencies to 0
    new_X=ifft(Y_cut); %% now do the inverse FFT
    plot(t,new_X+(count*2)); hold on
end
set(gca,'tickdir','out','ytick',[],'ycolor','w'); box off, set(gcf,'color','w','name','some sine waves')
xlabel('time (milliseconds)');title('components')

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PART 6 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all,
clear all
%%%%%%%%%%%%%%%%%%%% make a signal that you will analysis with FFT
Fs = 1000;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = 1500;             % Length of signal
t = (0:L-1)*T;        % Time vector
X=zeros(size(t));
X(500:1000)=1;X=X-mean(X);
subplot(2,2,1)
plot(Fs*t,X);
ylabel('amplitude');xlabel('time (milliseconds)')
title('a square signal')
set(gca,'tickdir','out'); box off, set(gcf,'color','w')

Y=fft(X);
P2 = abs(Y/L); %%power is the absalute of the complex numbers
P1 = P2(1:L/2+1); %% you only want the first half of the result from FFT
P1(2:end-1) = 2*P1(2:end-1); %% because you have thrown away half the result, double the power in the remaining part expect for the power in the 0Hz component.
subplot(2,2,3)
frequency_axis=[0:1/(L/Fs):Fs/2];
plot(frequency_axis,P1);
title('Power Spectrum')
xlabel('frequency (Hz)')
ylabel('Power')
set(gca,'tickdir','out','xlim',[0 100]); box off, 

number_of_components_to_plot=[];

count=0;
subplot(2,2,2);
X_new=zeros(size(X));
[~,idx]=sort(P1,'descend')
for JJ=idx(1:number_of_components_to_plot)
    count=count+1;
    Y_cut=Y;
    Y_cut([1:JJ-1 JJ+1:end])=Y_cut([1:JJ-1 JJ+1:end]).*0;%% set the power of all other frequencies to 0
    new_X=ifft(Y_cut); %% now do the inverse FFT
    plot(t,new_X); hold on
    X_new=X_new+new_X;
end
set(gca,'tickdir','out','ytick',[],'ycolor','w'); box off, set(gcf,'color','w','name','some sine waves')
xlabel('time (milliseconds)');title(['top ' num2str(number_of_components_to_plot) ' components'])
subplot(2,2,4)
plot(t,X_new)
set(gca,'tickdir','out','ytick',[],'ycolor','w'); box off, set(gcf,'color','w','name','some sine waves')
xlabel('time (milliseconds)');title(['sum of top ' num2str(number_of_components_to_plot) ' components'])
set(gcf,'color','w')

%%




































































































































%%
close all, clear all, clc

figure
plot(1,1,'w.')
title('run each section of this script individually','color','r','fontsize',16)
set(gca,'xcolor','w','ycolor','w'); set(gcf,'color','w')






