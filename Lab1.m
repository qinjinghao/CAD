 function [] = Lab1()%���庯��
clear 
clc
disp('If you want to run this by a file remember to rename the file as myfile.txt and store it in the right folder')
w=input('Press 1 for entry through keyboard or 2 for txtfile repectively-->');%�ɵ�������ģʽ
if w==1
    m=input('Enter no. of curves  ');
    fid=fopen('test.txt','w');
    fprintf(fid,'%d\n',m);
    for j=1:m
        n(j,1)=input('Enter no. of points  ');
        fprintf(fid,'%d\n',n(j,1));
        cop(j,1)=input('close or open 0/1 ');
        fprintf(fid,'%d\n',cop(j,1));
        for i=1:n
        p(i,:)=input('Enter co-odinates of points  ->[x y z] ');
        end
        data{j}=p;
        fprintf(fid,'%.2f %.2f %.2f\n',p');
    end
    fclose(fid);
end
if w==2
    filename = '.\myfile.txt';
    a=textread(filename);
    m=a(1,1);n(1,1)=a(2,1);cop(1,1)=a(3,1);%ǰ����
    s=n(1,1)+3;%��ni�����������
    [p1]=a(4:s,1:3);%ni������
    data{1}=[p1];%������㼯�ϴ����ڡ�data��cell��
    for i=2:m
        n(i,1)=a((s+1),1);%��һ�����꼯�ϵ����һ�����������+1
        cop(i,1)=a((s+2),1);%��ni������+2
        [p]=a((s+3):(s+2+n(i,1)),1:3);%���ڻ�ͼ�����꼯��
        data{i}=[p];%������㼯�ϴ����ڡ�data��cell�ĵ�i��������
        s=s+n(i,1)+2;%�������һ�����������
    end
end
div = 50; %���߷ֶ����� (Increase this value to obtain a smoother curve��
for j=1:m
    %_______open ����
    if cop(j,1)==1
    n1=n(j,1)-1;
    for    i=0:n1
    sigma(i+1)=factorial(n1)/(factorial(i)*factorial(n1-i));  % for calculating (x!/(y!(x-y)!)) values
    end
    l=[];
    UB=[];
    for u=0:1/div:1
        for d=1:n(j,1)
        UB(d)=sigma(d)*((1-u)^(n(j,1)-d))*(u^(d-1));
        end
        l=cat(1,l,UB);                                      %catenation
    end
    p=data{j};
    P=l*p;
    end
    %_______close ����
    if cop(j,1)==0
    for    i=0:n(j,1)
    sigma(i+1)=factorial(n(j,1))/(factorial(i)*factorial(n(j,1)-i));  % for calculating (x!/(y!(x-y)!)) values
    end
    l=[];
    UB=[];
    for u=0:1/div:1
        for d=1:n(j,1)+1
        UB(d)=sigma(d)*((1-u)^(n(j,1)+1-d))*(u^(d-1));
        end
        l=cat(1,l,UB);                                      %catenation
    end
    p=data{j};p=cat(1,p,p(1,:));
    P=l*p;
    end
    plot3(P(:,1),P(:,2),P(:,3))
    hold on;grid on;
    plot3(p(:,1),p(:,2),p(:,3),'--r')
    
end
disp('If you use keyboard to run remember to save "text.txt" to another file or it will be rewrite')
end