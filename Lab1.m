 function [] = Lab1()%mybez�����
clear 
clc
w=input('Press 1 for entry through keyboard or 2 for txtfile repectively-->');%�ɵ�������ģʽ
if w==1
    [p]=input('Enter co-odinates of points within brackets ->[x1 y1 z1;...;xn yn zn] ');
    m=input('Enter no. of curves  ');
    n=input('Enter no. of points  ');
    cop=input('close or open 0/1 ');
    n1=n-1;
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
%     if cop(j,1)==1%open ����
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
    plot3(P(:,1),P(:,2),P(:,3))
    hold on;grid on;
    plot3(p(:,1),p(:,2),p(:,3),'--r')
    end

 end