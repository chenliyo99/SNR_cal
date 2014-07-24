addpath(genpath('/home/anvu/Documents/MATLAB/kendrick'))
addpath('/home/anvu/Documents/MATLAB/')
addpath('/home/anvu/Documents/MATLAB/code')
addpath(genpath('/home/anvu/Documents/MATLAB/dustin'))
addpath(genpath('/home/anvu/Documents/MATLAB/spm8'))
addpath('/home/anvu/Documents/MATLAB/code/vein_code/')
addpath('/home/anvu/Documents/MATLAB/code/3T')
addpath('/home/anvu/Documents/MATLAB/code/retAng_code/')
addpath('/home/anvu/Documents/MATLAB/kathleen/anatomicals/code/')
addpath('/home/anvu/Documents/MATLAB/code/fMRI_regress/')


load tSNR_DF20131210.mat;

[folder_NO mid_num]=size(tSNR)

% if(size(tSNR{1,3},1)>55)
% tSNR{1,3}=tSNR{1,3}(27:78,:,:);
% end
%BW=roipoly((tSNR{1,1})/200);
slc_num=1;
BW=cell(1,folder_NO);
for ii=1:folder_NO
    center_num=size(tSNR{ii,1},3)/2;
    BW{ii}=ones(size(tSNR{ii,1}(:,:,center_num)));
end

for ii=1:folder_NO
    for jj=1:mid_num
        center_num=size(tSNR{ii,jj},3)/2;
        BW{ii}=BW{ii}&((tSNR{ii,jj}(:,:,center_num))>10.30);
    end
end

for ii=1:folder_NO
    for jj=1:mid_num
        ax=(tSNR{ii,jj});
        center_num=size(tSNR{ii,jj},3)/2;
        ax=ax(:,:,center_num);
        
        %BW=(ax>50)
        %bx=ax(ax>50);
        
        bx=ax(BW{ii});
        tt(ii,jj)=mean(bx(:));
        %pause
    end
end

aa=reshape(mean(tt,1),[2 4]);
bb=reshape(std(tt,1),[2 4]);


figure;
barweb(aa',bb'),
% legend('3D GRASE(w BS)','3D GRASE',...
%       'MB2', 'MB4','MB2(pf)', 'MB4(pf)', 'MB2(25%)', 'MB4(25%)')  
%set(gca,'XTick',[1:8])
%set(gca,'XTickLabel',['3D GRASE(w BS)','3D GRASE','MB2','MB4',...
%    'MB2(pf)','MB4(pf)','MB2(25%)','MB4(25%)']); 
ylabel('mean')
title('tSNR of non-selective images');
saveas(gcf,'tSNR_ns2013_1108','tiff');
% mean(tt([1:2 4:5],:),1)
% std(tt([1:2 4:5],:),1)