%select the folders
addpath /home/liyong/mat/matlab/
addpath /storage2/dataHost3T2/processed/process_fact/common/

%calcualte the representive images
tSNR=1;%mean/std

%mean value

% folder_name={'20131108DF'};
% 
% sub_mid_name={{14 15 23 21 29 27 33 31 }};
folder_name={'20131107AB','20131108DF','20131210LC'};

sub_mid_name={{69 70 73 75 77 79 81 83},{14 15 23 21 29 27 33 31 },...%};
     {184 185 196 188 200 198 204 202 }};

tSNR=cell(length(folder_name),8);
start_num=0;
avg_number=18;

tagn=[43.6842   43.6111   44.5833   47.5000   49.1667];%
%TI1=700;%duration between the inversion and saturation pulses
%TI2=1700;%TI1+w;%1774~1937 for mb2slc10



for ii=1:length(folder_name)%2:2%
    for jj=1:8
        p=dir((['/storage2/dataHost3T2/processed/' folder_name{ii} '/MID' sprintf('%03u',sub_mid_name{ii}{jj}) '/']));
        working_dir=['/storage2/dataHost3T2/processed/' folder_name{ii}...
            '/MID' sprintf('%03u',sub_mid_name{ii}{jj}) '/' p(3).name '/']
        %                 if(jj==1)
        %             TI2=[1800:tagn(1):(1800+tagn(1)*19)];
        %         elseif(jj==2)
        %             TI2=[1800:tagn(2):(1800+tagn(2)*9) 1800:tagn(2):(1800+tagn(2)*9)];
        %         elseif(jj==3)
        %             TI2=[1800:tagn(3):(1800+tagn(3)*6) 1800:tagn(3):(1800+tagn(3)*6)...
        %                 1800:tagn(3):(1800+tagn(3)*6) ];
        %         elseif(jj==4)
        %             TI2=[1800:tagn(4):(1800+tagn(4)*4) 1800:tagn(4):(1800+tagn(4)*4) ...
        %                 1800:tagn(4):(1800+tagn(4)*4) 1800:tagn(4):(1800+tagn(4)*4)];
        %         else
        %             TI2=[1800:tagn(5):(1800+tagn(5)*3) 1800:tagn(5):(1800+tagn(5)*3) ...
        %          1800:tagn(5):(1800+tagn(5)*3) ...
        %          1800:tagn(5):(1800+tagn(5)*3) 1800:tagn(5):(1800+tagn(5)*3) ];
        %                 end
        fid=fopen([working_dir 'params.bin']);
        b=fread(fid,inf,'int64');
        fclose(fid);
        
        
        TI2=1650;
        T1a=1650;
        kx=64;
        ky=64;
        knum=b(4);%
        %figure(ii)
        if(jj<3)
            knum=b(3);avg_number=18;
        else
            avg_number=80;
        end
        img_tmp=cell(1,length(start_num+1:2:start_num+avg_number));
        
        
        nTR=start_num+1;
        if(jj<3)
            fileName=[working_dir,'img_sos.bin',...
                sprintf('%04u',nTR)];%
            tmpk=sqrt(readrxytFromFile(fileName,kx,ky,knum)).*permute(repmat(exp(TI2/T1a),[ 64 knum 64]),[1 3 2]);
        else
            fileName=[working_dir,'grappa_c_prog_output_inX.bin',...
                sprintf('%04u',nTR)];
            tmpk=sqrt(readrxytFromCmpxFile(fileName,kx,ky,knum)).*permute(repmat(exp(TI2/T1a),[ 64 knum 64]),[1 3 2]);
        end
        
        %nTR=start_num+1;
        
        if(jj<3)
            fileName=[working_dir,'img_sos.bin',...
                sprintf('%04u',nTR+1)];
            tmpk2=sqrt(readrxytFromFile(fileName,kx,ky,knum)).*permute(repmat(exp(TI2/T1a),[ 64 knum 64]),[1 3 2]);
        else
            fileName=[working_dir,'grappa_c_prog_output_inX.bin',...
                sprintf('%04u',nTR+1)];
            tmpk2=sqrt(readrxytFromCmpxFile(fileName,kx,ky,knum)).*permute(repmat(exp(TI2/T1a),[ 64 knum 64]),[1 3 2]);
            
        end
        
        
        if(size(tmpk,3)>20)
            img_tmp{1}=tmpk(:,:,:)-tmpk2(:,:,:);
        else
            img_tmp{1}=tmpk-tmpk2;
        end
        
        
        for iTR=(start_num+3):2:(start_num+avg_number)%68%1:2%
            if(jj<3)
                tmpk=sqrt((readrxytFromFile(...
                    strcat(working_dir,...
                    'img_sos.bin',...
                    sprintf('%04u',iTR)),kx,ky,knum))).*permute(repmat(exp(TI2/T1a),[ 64 knum 64]),[1 3 2]);
                tmpk2=sqrt((readrxytFromFile(...
                    strcat(working_dir,...
                    'img_sos.bin',...
                    sprintf('%04u',iTR+1)),kx,ky,knum))).*permute(repmat(exp(TI2/T1a),[ 64 knum 64]),[1 3 2]);
            else
                tmpk=sqrt((readrxytFromCmpxFile(...
                    strcat(working_dir,...
                    'grappa_c_prog_output_inX.bin',...
                    sprintf('%04u',iTR)),kx,ky,knum))).*permute(repmat(exp(TI2/T1a),[ 64 knum 64]),[1 3 2]);
                tmpk2=sqrt((readrxytFromCmpxFile(...
                    strcat(working_dir,...
                    'grappa_c_prog_output_inX.bin',...
                    sprintf('%04u',iTR+1)),kx,ky,knum))).*permute(repmat(exp(TI2/T1a),[ 64 knum 64]),[1 3 2]);
            end
            
            %             tmpk2=sqrt((readrxytFromCmpxFile(...
            %                 strcat(working_dir,...
            %                 'grappa_c_prog_output_inX.bin',...
            %                 sprintf('%04u',iTR+1)),kx,ky,knum))).*permute(repmat(exp(TI2/T1a),[ 64 1 64]),[1 3 2]);
            
            if(size(tmpk,3)>20)
                img_tmp{(iTR-start_num+1)/2}=tmpk(:,:,:)-tmpk2(:,:,:);
            else
                img_tmp{(iTR-start_num+1)/2}=tmpk-tmpk2;
            end
            
        end
        
        tSNR{ii,jj}=meanCell(img_tmp);%/stdCell(img_tmp);
        a=1;
    end
end

save('tSNR_perf_DF20131108','tSNR');

