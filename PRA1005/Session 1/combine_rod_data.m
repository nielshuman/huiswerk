close all, clear all, clc,
filename=['C:\Users\mark\OneDrive\teaching\PRA1005\Rod data setup\Copy of full_data'];
out=[];id=[];pause on
for Year=[6 7]
    [NUM,TXT,RAW]=xlsread(filename,Year);
    for P=1:2:size(NUM,1)
        Cidx=[8:23];
        if Year>5
            Cidx=[8:31];
        end
        [tmp,idx]=sort(NUM(P,Cidx));%condition order
        clc
        tmp=NUM(P+1,Cidx);% data
        if ~isempty(find(isnan(tmp)))
            P
            tmp
            
            tmp=tmp(idx);tmp=tmp(1:16);
            tmp=[tmp mean(tmp(1:4))];
            tmp=[tmp mean(tmp(5:8))];
            tmp=[tmp mean(tmp(9:12))];
            tmp=[tmp mean(tmp(13:16))];

            tmp=[tmp mean(tmp(1:5))];
            tmp=[tmp mean(tmp(6:10))];
            tmp=[tmp mean(tmp(11:15))];
            tmp=[tmp mean(tmp(16:20))];
            ix=1:24;
        end
        out(size(out,1)+1,:)=[tmp(idx) 2019+Year P]
        
        Nidx=Cidx(find(isnan(tmp)));
        RAW(P+1,Nidx);
        
        if RAW{P+1,2}(1)=='R' | RAW{P+1,2}(1)=='r'
            id(size(out,1),2)=1;
        elseif RAW{P+1,2}(1)=='L' | RAW{P+1,2}(1)=='l'
            id(size(out,1),2)=2;
        else
            RAW{P+1,2}
            %pause
        end
        
        if RAW{P+1,3}(1)=='M' | RAW{P+1,3}(1)=='m'
            id(size(out,1),1)=1;
        elseif RAW{P+1,3}(1)=='F' | RAW{P+1,3}(1)=='f'
            id(size(out,1),1)=2;
        else
            id(size(out,1),1)=3;
        end
        id(size(out,1),3)=NUM(P,end);
    end
end

size(out)
RM=[];
for J=1:size(out,1)
    for JJ=J+1:size(out,1)
        if sum(out(JJ,1:end-2)-out(J,1:end-2))==0
           RM=[RM JJ]
        end
    end
% %    ix=find(mean(out(:,1:end-2),2)==mean(out(J,1:end-2)));
% %    ix(find(ix==J))=[];
% %    
% %    ix
%    
% %    pause
% %    RM=[RM; ix];
end
ix=1:size(out,1);ix(RM)=[];
out=out(ix,:);id=id(ix,:);
% RM=[];
% for J=1:size(out,1)
%    ix=find(mean(out(:,1:end-2),2)==mean(out(J,1:end-2)));
%    ix(find(ix==J))=[];
%    RM=[RM; ix];
% end
% ix=1:size(out,1);ix(RM)=[];
% out=out(ix,:);id=id(ix,:);
% size(out)


length(unique(sum(out(:,1:end-2),2)))
size(out)

%%
ID=id;
%
filename=['C:\Users\mark\OneDrive\teaching\PRA1005\2026\Course Material\Session 2\group_data_2026'];
%filename=['C:\Users\mark\OneDrive\teaching\PRA1005\2020\Session 2 matlab_practical_1\group_data_2020']
if size(out,2)==26
    HDRS={'Sex','Hand','CND1,1','CND1,2','CND1,3','CND1,4','CND1,5','CND1,6'...
        'CND2,1','CND2,2','CND2,3','CND2,4','CND2,5','CND2,6'...
        'CND3,1','CND3,2','CND3,3','CND3,4','CND3,5','CND3,6'...
        'CND4,1','CND4,2','CND4,3','CND4,4','CND4,5','CND1,6'};%,'Year'};
else
    HDRS={'Sex','Hand','CND1,1','CND1,2','CND1,3','CND1,4','CND2,1','CND2,2','CND2,3','CND2,4','CND3,1','CND3,2','CND3,3','CND3,4','CND4,1','CND4,2','CND4,3','CND4,4'};%,'Year'};
end
%out(14,:)=[];id(14,:)=[];
dat=num2cell([id(:,1:2) out(:,1:end-2)]);

%ix=find(out(:,end)<2023)
ix=1:size(out,1);
dat(ix,:)=dat(ix(randperm(length(ix))),:);

%xlswrite(filename,[HDRS;dat])

id=ID;
is_male=find(id(:,1)==1 );
is_female=find(id(:,1)==2 );

right_handed=find(id(:,2)==1);
left_handed=find(id(:,2)==2);
I=[1:6:24 ; 6:6:24];clear MEANS interference interference_difference
if size(out,2)<24
    I=[1:4:4*4 ; 4:4:4*4];clear MEANS interference interference_difference
end
MEANS(:,1)=mean(out(:,I(1,1):I(2,1)),2);%right silent
MEANS(:,2)=mean(out(:,I(1,2):I(2,2)),2);%right speaking
MEANS(:,3)=mean(out(:,I(1,3):I(2,3)),2);%left silent
MEANS(:,4)=mean(out(:,I(1,4):I(2,4)),2);%left speaking
Overall_times=mean(out(:,1:max(I(:))),2);%all
MEANS=MEANS./Overall_times; %normalize

% speaking - silent
interference(:,1)=(MEANS(:,2)-MEANS(:,1));%./MEANS(:,5);
interference(:,2)=(MEANS(:,4)-MEANS(:,3));%./MEANS(:,5);
interference_difference=interference(:,1)-interference(:,2);
%  [~,ix]=sort(interference_difference);

 [~,ix]=sort(interference_difference,'descend');
 ix=ix(1:3)
 ix2=1:length(interference_difference); ix2(ix)=[];
 
%  mx=102;
%  interference_difference=interference_difference(ix(1:mx));
%  id=id(ix(1:mx,:));interference=interference(ix(1:mx,:));

%[a,ix]=max(interference_difference)
%interference_difference(ix)=[];
close all
subplot(2,2,1)
[n,xout]=hist(interference_difference,[-3:0.1:3]);
bar(xout,n); hold on
[h,p,ci,stats]=ttest(interference_difference,0)
plot([0 0],[0 max(n)],'r')
test=['t= (' num2str(stats.df) ') = ' num2str(stats.tstat) ' p = ' num2str(p)];
text(xout(1),max(n/sum(n)),test)

subplot(2,1,2)
plot(1:size(out,1),interference_difference,'*-'); hold on; plot([1 size(out,1)],[0 0]); axis tight
plot(ix,interference_difference(ix),'o'); hold on; plot([1 size(out,1)],[0 0]); axis tight

subplot(2,2,2)
[n,xout]=hist(interference_difference(ix2),[-3:0.1:3]);
bar(xout,n); hold on
[h,p,ci,stats]=ttest(interference_difference(ix2),0)
plot([0 0],[0 max(n)],'r')
test=['t= (' num2str(stats.df) ') = ' num2str(stats.tstat) ' p = ' num2str(p)];
text(xout(1),max(n/sum(n)),test)


close all
NUM=[id(ix2,1:2) out(ix2,1:end-2)];
dat=num2cell([id(ix2,1:2) out(ix2,1:end-2)]);
filename=['C:\Users\mark\OneDrive\teaching\PRA1005\2026\Course Material\Session 2\group_data_2026'];
xlswrite(filename,[HDRS;dat])

%%
clear all
filename=['C:\Users\mark\OneDrive\teaching\PRA1005\2026\Course Material\Session 2\group_data_2026'];
[NUM,TXT,RAW]=xlsread(filename);



N_participants=size(NUM,1)

is_male=find(NUM(:,1)==1 );
is_female=find(NUM(:,1)==2 );

right_handed=find(NUM(:,2)==1);
left_handed=find(NUM(:,2)==2);

clear Mean_times interference
Mean_times(:,1)=mean(NUM(:,3:8),2); % right silent
Mean_times(:,2)=mean(NUM(:,9:14),2); % right speaking
Mean_times(:,3)=mean(NUM(:,15:20),2); % left silent
Mean_times(:,4)=mean(NUM(:,21:26),2); % left speaking

Overall_times=mean(NUM(:,3:26),2); %the average over all trys
Mean_times=Mean_times./Overall_times; %normalize
%notice that you use ./ for element-wise division

interference(:,1)=(Mean_times(:,2)-Mean_times(:,1));%Right hand %speaking - silent. Effect of speaking should be negative
interference(:,2)=(Mean_times(:,4)-Mean_times(:,3));%Left hand %speaking - silent should be negative
interference_difference=interference(:,1)-interference(:,2);%right-left % should be negative for more interference on rihgt hand


figure
subplot(2,2,1)
[n,xout]=hist(interference_difference,30);
plot(xout,n/sum(n),'linewidth',2,'color',[0 .8 0])
hold all
box off
set(gcf,'color','w')

plot([mean(interference_difference) mean(interference_difference)],[0 max(n/sum(n))],'k-')
title('data')
xlabel('values')
ylabel('proportion')
legend([{'data'},{'mean'}])

[h,p,ci,stats]=ttest(interference_difference,0);
test=['t= (' num2str(stats.df) ') = ' num2str(stats.tstat) ' p = ' num2str(p)];
text(xout(1),max(n/sum(n)),test)

subplot(2,2,2)
bar(mean(interference)); hold on
errorbar([1 2],mean(interference),std(interference)/sqrt(size(interference,1)),'k.')
bar(3,mean(interference(:,1)-interference(:,2)))
errorbar([3],mean(interference(:,1)-interference(:,2)),std(interference(:,1)-interference(:,2))/sqrt(size(interference(:,1)-interference(:,2),1)),'k.')
[H,P,CI,STATS]=ttest(interference(:,1)-interference(:,2),0)
title(['all p' num2str(P,2)])


subplot(2,2,3)
[n,xout]=hist(Overall_times,25);

[n,xout]=hist(Overall_times(is_male),xout);n=n./sum(n);
[n(2,:),xout]=hist(Overall_times(is_female),xout);n(2,:)=n(2,:)./sum(n(2,:));
plot(xout,n)

[h,p,ci,stats]=ttest2(Overall_times(is_male),Overall_times(is_female));
test=['t= (' num2str(stats.df) ') = ' num2str(stats.tstat) ' p = ' num2str(p)];
text(xout(1),max(n(:)),test)


subplot(2,2,4)
[n,xout]=hist(interference_difference,25);

[n,xout]=hist(interference_difference(is_male),xout);n=n./sum(n);
[n(2,:),xout]=hist(interference_difference(is_female),xout);n(2,:)=n(2,:)./sum(n(2,:));
plot(xout,n)

[h,p,ci,stats]=ttest2(interference_difference(is_male),interference_difference(is_female));
test=['t= (' num2str(stats.df) ') = ' num2str(stats.tstat) ' p = ' num2str(p)];
text(xout(1),max(n(:)),test)



% filename=['C:\Users\mark\OneDrive\teaching\PRA1005\2026\Course Material\Session 2\group_data_2026_good'];
% [NUM,TXT,RAW]=xlsread(filename);
%%
% tsts=[];
% for J=1:size(NUM,1)
%     tst=mean(hold_NUM,2)-mean(NUM(J,:));
%     [tsts(J,1), tsts(J,2)]=min(abs(tst));
% end
% J=find(tsts(:,1)==0);
% 
% tsts=[];
% for J=1:size(hold_NUM,1)
%     tst=mean(NUM,2)-mean(hold_NUM(J,:));
%     [tsts(J,1), tsts(J,2)]=min(abs(tst));
% end
% tsts
%%
figure
subplot(2,3,1)
bar(mean(interference)); hold on
errorbar([1 2],mean(interference),std(interference)/sqrt(size(interference,1)),'k.')
bar(3,mean(interference(:,1)-interference(:,2)))
errorbar([3],mean(interference(:,1)-interference(:,2)),std(interference(:,1)-interference(:,2))/sqrt(size(interference(:,1)-interference(:,2),1)),'k.')
[H,P,CI,STATS]=ttest(interference(:,1)-interference(:,2),0)
title(['all p' num2str(P,2)])

subplot(2,3,2)
bar(mean(interference(right_handed,:))); hold on
errorbar([1 2],mean(interference(right_handed,:)),std(interference(right_handed,:))/sqrt(length(right_handed)),'k.')
bar(3,mean(interference(right_handed,1)-interference(right_handed,2)))
errorbar([3],mean(interference(right_handed,1)-interference(right_handed,2)),std(interference(right_handed,1)-interference(right_handed,2))/sqrt(length(right_handed)),'k.')
[H,P,CI,STATS]=ttest(interference(right_handed,1)-interference(right_handed,2),0)
title(['Right handed n=' num2str(length(right_handed)) ' p' num2str(P,2)])


subplot(2,3,3)
bar(mean(interference(left_handed,:))); hold on
errorbar([1 2],mean(interference(left_handed,:)),std(interference(left_handed,:))/sqrt(length(left_handed)),'k.')
bar(3,mean(interference(left_handed,1)-interference(left_handed,2)))
errorbar([3],mean(interference(left_handed,1)-interference(left_handed,2)),std(interference(left_handed,1)-interference(left_handed,2))/sqrt(length(left_handed)),'k.')
[H,P,CI,STATS]=ttest(interference(left_handed,1)-interference(left_handed,2),0)
title(['Left handed n=' num2str(length(left_handed)) ' p' num2str(P,2)])

RH_I=interference(right_handed,1)-interference(right_handed,2);
LH_I=interference(left_handed,1)-interference(left_handed,2);
[H,P,CI,STATS]=ttest2(RH_I,LH_I)



subplot(2,3,5)
bar(mean(interference(is_male,:))); hold on
errorbar([1 2],mean(interference(is_male,:)),std(interference(is_male,:))/sqrt(length(is_male)),'k.')
bar(3,mean(interference(is_male,1)-interference(is_male,2)))
errorbar([3],mean(interference(is_male,1)-interference(is_male,2)),std(interference(is_male,1)-interference(is_male,2))/sqrt(length(is_male)),'k.')
[H,P,CI,STATS]=ttest(interference(is_male,1)-interference(is_male,2),0)
title(['Male n' num2str(length(is_male))  ' p' num2str(P,2)])

subplot(2,3,6)
bar(mean(interference(is_female,:))); hold on
errorbar([1 2],mean(interference(is_female,:)),std(interference(is_female,:))/sqrt(length(is_female)),'k.')
bar(3,mean(interference(is_female,1)-interference(is_female,2)))
errorbar([3],mean(interference(is_female,1)-interference(is_female,2)),std(interference(is_female,1)-interference(is_female,2))/sqrt(length(is_female)),'k.')
[H,P,CI,STATS]=ttest(interference(is_female,1)-interference(is_female,2),0)
title(['Female n' num2str(length(is_female)) ' p' num2str(P,2)])

A=interference(is_male,1)-interference(is_male,2);
B=interference(is_female,1)-interference(is_female,2);
[H,P,CI,STATS]=ttest2(A,B)
%%%%%%%%%%%%
%%

