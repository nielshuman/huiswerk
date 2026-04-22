close all, clear all,clc
%%%%%%%%%%%% load the data and make the analysis figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%% set the directory to save the data to %%%
p = mfilename('fullpath');
if ispc
    data_directory=p(1:max(find(p=='\')));
    winopen(data_directory);
else %is a mac
    data_directory=p(1:max(find(p=='/')));
    macopen(data_directory);
end


clc
group_number=2;
Participant_ID=8;
Repetition=1;

dtmp=date;year=dtmp(end-3:end);

data_filename=[data_directory 'constant_stimuli_neutral_Y_' year '_G_' num2str(group_number) '_Participant_' num2str(Participant_ID) '_repetition_' num2str(Repetition) '.mat'];
load(data_filename);

%%%%%%%%%%%%%%%%%%%% a figure showing the stimuli

figure,set(gcf,'position',[560 0 560 420],'color','w');set(gca,'xcolor','w','ycolor','w')
colormap(gray)
fill([0 0 1 1 0],[0 1 1 0 0],[1 1 1]);
text(0.5, 0.5,'X','fontsize',100,'fontweight','bold','horizontalalignment','center'); axis square
I=getframe;
tst=mean(I.cdata,3)./255;
tst=tst-mean(tst(:)');
tst=tst./4;

N = [size(I.cdata,1) size(I.cdata,2)]; % size in pixels of image
F = 20;        % frequency-filter width
[X,Y] = ndgrid(1:N(1),1:N(2));
i = min(X-1,N(1)-X+1);
j = min(Y-1,N(2)-Y+1);
H = exp(-.5*(i.^2+j.^2)/F^2);
Z = real(ifft2(H.*fft2(randn(N))));
CNDS=unique(cnd_matrix(:,2))';

count=0;
for CND=(CNDS)
    count=count+1;
    subplot(1,length(CNDS),count)
    Z = real(ifft2(H.*fft2(randn(N))));
    
    imagesc([0 1],[0 1],(tst.*CND)+Z);
    set(gca,'xtick',[],'ytick',[],'clim',[-1 1],'xlim',[0 1],'ylim',[0 1])
    axis square; colormap(gray(256))
    title(num2str(CND,2))
end
    set(gcf,'color','w')

screen_size = get(0, 'ScreenSize');screen_size(2)=screen_size(2)/2;
origSize = get(gcf, 'Position'); % grab original on screen size
set(gcf, 'Position', [10 20 screen_size(3)*0.90 screen_size(4)*0.90 ] ); %set to scren size
set(gcf,'PaperPositionMode','auto') %set paper pos for printing
saveas(gcf,[data_directory 'stimuli.png'])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure,
count=0;X=[];
CNDS=unique(cnd_matrix(:,2))';
n_rep=size(cnd_matrix,1)/length(CNDS)/2;
for CND=CNDS
    count=count+1;
    X(count)=CND;
    HIT(count)=length(find(cnd_matrix(:,2)==CND & cnd_matrix(:,3)==1 & cnd_matrix(:,5)==1))/n_rep;
    MISS(count)=length(find(cnd_matrix(:,2)==CND & cnd_matrix(:,3)==1 & cnd_matrix(:,5)==0))/n_rep;
end
FA=length(find(cnd_matrix(:,3)==0 & cnd_matrix(:,5)==1))/length(cnd_matrix(:,3)==0);
CR=length(find(cnd_matrix(:,3)==0 & cnd_matrix(:,5)==0))/length(cnd_matrix(:,3)==0);

P_correct=[HIT FA];
X=[X 0];
plot(X,P_correct,'ks','markersiz',10,'linewidth',2); hold on
[pars,err]=fminsearch(@Weibull_fit,[mean(X) 1  FA],[],X,P_correct);
interesting_numbers=round(pars,2);

x=min(X):0.01:max(X);
t=pars(1); %% threshold
b=pars(2); %% slope
g=pars(3); %% false alarm rate
e = 0.75;

k = (-log( (1-e)/(1-g)))^(1/b);
y = 1- (1-g)*exp(- (k*x/t).^b);
plot(x,y,'b-','linewidth',2);

plot([min(x) max(x)],[0.5 0.5],'k:'); hold on
set(gca,'ylim',[0 1])


text(min(x),0.9,['Threshold (' num2str(e*100) '% correct) = ' num2str(pars(1),2)],'horizontalalignment','left')
text(t,e,['Slope = ' num2str(pars(2),2)],'horizontalalignment','left')
plot([min(get(gca,'xlim')) t t],[e e min(get(gca,'ylim'))],'k-')
set(gca,'linewidth',2,'tickdir','out','fontsize',14); box off;
set(gcf,'color','w')
box off;

title('Individual fit of psychometric function','fontsize',14)
xlabel('Stimulus intensity (opacity of X)','fontsize',14)
ylabel('Proportion of times stimulus is observed (X is seen)','fontsize',14)
legend([{'Run at intensity'},{'Fit of psychometric function'},{'Proportion = 50%'}, {"Proportion = " + num2str(e*100) + "%"}],'Location','SouthEast')


screen_size = get(0, 'ScreenSize');
set(gcf, 'Position', [100 100 screen_size(3)-200 screen_size(4)-200 ] ); %set to scren size
saveas(gcf,[data_directory 'individual_MCS.png'])

