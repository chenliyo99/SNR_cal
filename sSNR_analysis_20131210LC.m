avg_number=16;
if(~exist('sSNR_raw','var'))
%
    if(~exist('avg_number','var'))
     load (['sSNR_LC20131210']);avg_number=80;  
else
    load (['sSNR_LC20131210_' int2str(avg_number)]);
end
end

[folder_NO mid_num]=size(sSNR_raw)

%analysis the center slices
%get two NS images
sSNR_raw_NS_odd=cell(folder_NO,mid_num);
sSNR_raw_NS_even=cell(folder_NO,mid_num);
%get two perfusion images
sSNR_raw_perf_odd=cell(folder_NO,mid_num);
sSNR_raw_perf_even=cell(folder_NO,mid_num);

kx=size(sSNR_raw{1,1},1);
ky=size(sSNR_raw{1,1},2);

for ii=1:folder_NO
    for jj=1:mid_num
        center_num=size(sSNR_raw{ii,jj},3)/2;
        avg_num=size(sSNR_raw{ii,jj},4);
        img1=zeros(kx,ky);img2=zeros(kx,ky);%NS
        img3=zeros(kx,ky);img4=zeros(kx,ky);%perf
        for kk=1:avg_num
            mod_id=mod((kk-1),4);
            if(mod_id==0)
                img1=img1+sSNR_raw{ii,jj}(:,:,center_num,kk);
                img3=img3+sSNR_raw{ii,jj}(:,:,center_num,kk);
            elseif(mod_id==1)
                %img2=img2+sSNR_raw{ii,jj}(:,:,center_num,kk);
                img3=img3-sSNR_raw{ii,jj}(:,:,center_num,kk);
            elseif(mod_id==2)
                img2=img2+sSNR_raw{ii,jj}(:,:,center_num,kk);
                img4=img4+sSNR_raw{ii,jj}(:,:,center_num,kk);
            else
                %img2=img2+sSNR_raw{ii,jj}(:,:,center_num,kk);
                img4=img4-sSNR_raw{ii,jj}(:,:,center_num,kk);
            end
        end
        sSNR_raw_NS_odd{ii,jj}=img1;sSNR_raw_NS_even{ii,jj}=img2;
        sSNR_raw_perf_odd{ii,jj}=img3;sSNR_raw_perf_even{ii,jj}=img4;
    end
end

%pick a region of interest,and calculate the sSNR based on the mean/std
sSNR_NS=zeros(folder_NO,mid_num);
%sSNR_NS_even=zeros(folder_NO,mid_num);

sSNR_perf=zeros(folder_NO,mid_num);
%sSNR_perf_even=zeros(folder_NO,mid_num);

BW=cell(1,folder_NO);

% BW{1}=roipoly(abs(sSNR_raw_perf_odd{1,3})*2e5);
% BW{2}=roipoly(abs(sSNR_raw_perf_odd{2,3})*2e5);
% BW{3}=roipoly(abs(sSNR_raw_perf_odd{2,3})*2e5);
% save('BW1210_ns_perf','BW');
load BW1210_ns_perf;%BW1108_ns_perf;
for ii=1:folder_NO
    for jj=1:mid_num
        sg_roi=abs((sSNR_raw_NS_odd{ii,jj}(BW{ii})+sSNR_raw_NS_even{ii,jj}(BW{ii}))/2);
        ns_roi=abs((sSNR_raw_NS_odd{ii,jj}(BW{ii})-sSNR_raw_NS_even{ii,jj}(BW{ii}))/2);
        
        sg_p_roi=abs((sSNR_raw_perf_odd{ii,jj}(BW{ii})+sSNR_raw_perf_even{ii,jj}(BW{ii}))/2);
        ns_p_roi=abs((sSNR_raw_perf_odd{ii,jj}(BW{ii})-sSNR_raw_perf_even{ii,jj}(BW{ii}))/2);
        %mean/std
        sSNR_NS(ii,jj)=mean(sg_roi(:))/std(ns_roi);
        sSNR_perf(ii,jj)=mean(sg_p_roi(:))/std(ns_p_roi);
    end
end


aa=reshape(mean(sSNR_NS,1),[2 4]);
bb=reshape(std(sSNR_NS,1),[2 4]);
figure;
barweb(aa',bb'),
set(gca,'FontSize',24);
title(['spatial SNR of non selective images (mepi avg=' int2str(avg_number/2) ')']);
saveas(gcf,['sSNR_ns2013_1108_avg' int2str(avg_number/2)],'tiff');
aa=reshape(mean(sSNR_perf,1),[2 4]);
bb=reshape(std(sSNR_perf,1),[2 4]);

figure;
barweb(aa',bb'),
set(gca,'FontSize',24);
title(['spatial SNR of perfusion images(mepi avg=' int2str(avg_number/2) ')']);
saveas(gcf,['sSNR_perf2013_1108_avg' int2str(avg_number/2)],'tiff');

%saveas(gcf,'tSNR_ns2013_1108','tiff');
% mean(tt([1:2 4:5],:),1)
% std(tt([1:2 4:5],:),1)



% legend('3D GRASE(w BS)','3D GRASE',...
%       'MB2', 'MB4','MB2(pf)', 'MB4(pf)', 'MB2(25%)', 'MB4(25%)')  
%set(gca,'XTick',[1:8])
%set(gca,'XTickLabel',['3D GRASE(w BS)','3D GRASE','MB2','MB4',...
%    'MB2(pf)','MB4(pf)','MB2(25%)','MB4(25%)']); 
%ylabel('mean')


% slc_num=1;
% BW=cell(1,folder_NO);
% for ii=1:folder_NO
%     center_num=size(tSNR{ii,1},3)/2;
%     BW{ii}=ones(size(tSNR{ii,1}(:,:,center_num)));
% end
% 
% for ii=1:folder_NO
%     for jj=1:mid_num
%         center_num=size(tSNR{ii,jj},3)/2;
%         BW{ii}=BW{ii}&((tSNR{ii,jj}(:,:,center_num))>10.30);
%     end
% end
% 
% for ii=1:folder_NO
%     for jj=1:mid_num
%         ax=(tSNR{ii,jj});
%         center_num=size(tSNR{ii,jj},3)/2;
%         ax=ax(:,:,center_num);
%         
%         %BW=(ax>50)
%         %bx=ax(ax>50);
%         
%         bx=ax(BW{ii});
%         tt(ii,jj)=mean(bx(:));
%         %pause
%     end
% end
