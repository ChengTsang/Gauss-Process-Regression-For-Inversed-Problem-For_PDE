function fStar=regAndPre(x0,y0,yadta,A,Hyp)
%      tic
%          persistent ydata1;
%          persistent A1;
%          persistent Hyp1;
%      t=toc
    %����������regAndPre�����ϵĸĽ�;
    %�޲���ʱִ�е�һ���֣�Ϊѵ���ṩ���ݣ���Ҫ��ܶ��pde;
    %��һ������ʱִ�еڶ����֣����о���������֮���ת��;
    %��������ִ�е�������,�õ��۲�����;
    
    %��һ����
    if nargin==0
        %gauss�ع�����׼�����Ƚ�pde
        i=1;
        for x1= 0.1:0.1:1
            for x2= 0.1:0.1:1
                udata_2{i}=fun5_1(x1,x2);%��Ԫ��������������,��100��Ԫ������Щ����ÿ��������11*11��
                i=i+1;
            end
        end
       % udata{1003}
       save('udata_2.mat','udata_2');
    end
    
    %�ڶ�����
    if nargin==1
        %���ÿ�������Ļع�
        %whos -file udata.mat;
        load('udata_2.mat');
        udata_2{1};
        for i=1:1:121
            for j=1:1:100
                if mod(i-1,11)==0
                    ydata{i}(j)=udata_2{j}((floor((i-1)/11)+1),1);
                else
                    ydata{i}(j)=udata_2{j}((floor((i-1)/11)+1),mod(i-1,11)+1);%11*11ά�����ÿ��������ɵ�100ά����
            
                end
            end
        end
        save('ydata.mat','ydata')
      %�õ�������  
         for i=1:1:121
             Hyp{i}=exp(getHyp(ydata{i}')) ;%Udata��ѵ���õ�ÿ�����������ݼ���ÿ��Hyp��һ����ά����
         end
         
         
        save('Hyp.mat','Hyp');
      %�õ��м����
      [x1,x2] = meshgrid(linspace(0.1,1,10)); x = [x1(:),x2(:)];
        for k=1:1:121
            for i=1:1:100
                for j=1:1:100
                K{k}(i,j)=(Hyp{k}(2))^2*exp(-0.5*(x(i,:)-x(j,:))*(Hyp{k}(1))^(-2)*(x(i,:)-x(j,:))');
                end
            end
        end
         save('K.mat','K');
       %�õ���Ҫ����ľ���A\y
       for i=1:1:121
           A{i}=(K{i}+(Hyp{i}(3))^2*eye(100))\(ydata{i}');
       end
       save('A.mat','A');
     K{1};
    end
        
    %Ԥ��
    %��������
    if nargin==5
        xStar=[x0,y0];
        xStar;
        [x1,x2] = meshgrid(linspace(0.1,1,10)); x = [x1(:),x2(:)];
        for i=1:1:121 
            for j=1:1:100
            k{i}(1,j)=(Hyp{i}(2))^2*exp(-0.5*(xStar-x(j,:))*(Hyp{i}(1))^(-2)*(xStar-x(j,:))');
            end
        end
       for i=1:1:121
            if mod(i-1,11)==0
                 fStar((floor((i-1)/11)+1),1)=k{i}*A{i};
            else
             fStar((floor((i-1)/11)+1),mod(i-1,11)+1)=k{i}*A{i};  
            end
       end 
    end
end
    

    
    
