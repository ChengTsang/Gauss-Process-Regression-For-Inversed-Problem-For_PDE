function fStar=regAndPre(x0,y0,yadta,A,Hyp)
%      tic
%          persistent ydata1;
%          persistent A1;
%          persistent Hyp1;
%      t=toc
    %本程序是在regAndPre基础上的改进;
    %无参数时执行第一部分，为训练提供数据，需要解很多次pde;
    %有一个参数时执行第二部分，进行矩阵与向量之间的转化;
    %两个参数执行第三部分,得到观察向量;
    
    %第一部分
    if nargin==0
        %gauss回归做的准备，先解pde
        i=1;
        for x1= 0.1:0.1:1
            for x2= 0.1:0.1:1
                udata_2{i}=fun5_1(x1,x2);%开元胞数组来存数据,有100个元胞放这些矩阵，每个矩阵是11*11的
                i=i+1;
            end
        end
       % udata{1003}
       save('udata_2.mat','udata_2');
    end
    
    %第二部分
    if nargin==1
        %针对每个分量的回归
        %whos -file udata.mat;
        load('udata_2.mat');
        udata_2{1};
        for i=1:1:121
            for j=1:1:100
                if mod(i-1,11)==0
                    ydata{i}(j)=udata_2{j}((floor((i-1)/11)+1),1);
                else
                    ydata{i}(j)=udata_2{j}((floor((i-1)/11)+1),mod(i-1,11)+1);%11*11维矩阵的每个分量组成的100维向量
            
                end
            end
        end
        save('ydata.mat','ydata')
      %得到超参数  
         for i=1:1:121
             Hyp{i}=exp(getHyp(ydata{i}')) ;%Udata是训练用的每个分量上数据集，每个Hyp是一个三维向量
         end
         
         
        save('Hyp.mat','Hyp');
      %得到中间矩阵
      [x1,x2] = meshgrid(linspace(0.1,1,10)); x = [x1(:),x2(:)];
        for k=1:1:121
            for i=1:1:100
                for j=1:1:100
                K{k}(i,j)=(Hyp{k}(2))^2*exp(-0.5*(x(i,:)-x(j,:))*(Hyp{k}(1))^(-2)*(x(i,:)-x(j,:))');
                end
            end
        end
         save('K.mat','K');
       %得到需要保存的矩阵A\y
       for i=1:1:121
           A{i}=(K{i}+(Hyp{i}(3))^2*eye(100))\(ydata{i}');
       end
       save('A.mat','A');
     K{1};
    end
        
    %预测
    %第三部分
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
    

    
    
