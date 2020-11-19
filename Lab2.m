%function [] = Lab2()%定义函数
clear
clc
N =50;
alpha_u = []; %shape (N,1)
beta_v = [];
dataP={}; %shape (:,3) all the boundary points
sur = [] ;%shape (:,3) all the surface points

%N是采样点的数量，step是循环步长。f存放着四条边界线上的点，每条线存有N个点的数据。
%surface是Coons Patch曲面上的点的坐标，有N^2个。

%读取curve加show the boundary
disp('If you want to run this by a file remember to rename the file as myfile.txt and store it in the right folder')
w=input('Press 1 for entry through keyboard or 2 for txtfile repectively-->');%可调整输入模式
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
        global data
        data{j}=p;
        fprintf(fid,'%.2f %.2f %.2f\n',p');
    end
    fclose(fid);
end
if w==2
    filename = '.\coonsEdge_.txt';
    a=textread(filename);
    m=a(1,1);n(1,1)=a(2,1);cop(1,1)=a(3,1);%前三行
    s=n(1,1)+3;%第ni个坐标的行数
    [p1]=a(4:s,1:3);%ni个坐标
    data{1}=[p1];%将坐标点集合储存在‘data’cell里
    for i=2:m
        n(i,1)=a((s+1),1);%上一个坐标集合的最后一个坐标的行数+1
        cop(i,1)=a((s+2),1);%第ni个行数+2
        [p]=a((s+3):(s+2+n(i,1)),1:3);%用于绘图的坐标集合
        data{i}=[p];%将坐标点集合储存在‘data’cell的第i个格子里
        s=s+n(i,1)+2;%更新最后一个坐标的行数
    end
end

for j=1:m
    %_______open 曲线
    if cop(j,1)==1
    n1=n(j,1)-1;
    for    i=0:n1
    sigma(i+1)=factorial(n1)/(factorial(i)*factorial(n1-i));  % for calculating (x!/(y!(x-y)!)) values
    end
    l=[];
    UB=[];
    for u=0:1/N:1
        for d=1:n(j,1)
        UB(d)=sigma(d)*((1-u)^(n(j,1)-d))*(u^(d-1));
        end
        l=cat(1,l,UB);                                      %catenation
    end
    p=data{j};
    P=l*p;dataP{j}=P;
    end
    %_______close 曲线
    if cop(j,1)==0
    for    i=0:n(j,1)
    sigma(i+1)=factorial(n(j,1))/(factorial(i)*factorial(n(j,1)-i));  % for calculating (x!/(y!(x-y)!)) values
    end
    l=[];
    UB=[];
    for u=0:1/N:1
        for d=1:n(j,1)+1
        UB(d)=sigma(d)*((1-u)^(n(j,1)+1-d))*(u^(d-1));
        end
        l=cat(1,l,UB);                                      %catenation
    end
    p=data{j};p=cat(1,p,p(1,:));
    P=l*p;dataP{j}=P;
    end
    h(j)=plot3(P(:,1),P(:,2),P(:,3),'linewidth',3);
    hold on;grid on;
    plot3(p(:,1),p(:,2),p(:,3),'--r*')
end
%control point for blending function alpha(u) and beta(v)
control_point1=[3 5;6 3];%input('Enter co-odinates of 2 points  ->[x y] ');
control_point2=[0.4 0.4;0.5 0.5];%input('Enter co-odinates of 2 points  ->[x y] ');
%control point for boundary curves(they should share 4 edge points!)
point_curve1 = data{1};f1=dataP{1};
point_curve2 = data{2};f2=dataP{2};
point_curve3 = data{3};f3=dataP{3};
point_curve4 = data{4};f4=dataP{4};
%获取Blending Function
for u=0:1/N:1
  P=[0,1];
  P1=cat(1,P,control_point1);P1= cat(1,P1,[1,0]);
  P2=cat(1,P,control_point2);P2= cat(1,P2,[1,0]);
  alpha_u_item=((1-u)^3.*P1(1,:)+3*(1-u)^2*u.*P1(2,:)+3*(1-u)*u^2.*P1(3,:)+u^3*P1(4,:));
  alpha_u=cat(1,alpha_u,alpha_u_item);
  beta_v_item=((1-u)^3.*P2(1,:)+3*(1-u)^2*u.*P2(2,:)+3*(1-u)*u^2.*P2(3,:)+u^3*P2(4,:));
  beta_v=cat(1,beta_v,beta_v_item);
% alpha_u_item=u;
% alpha_u=cat(1,alpha_u,alpha_u_item);
% beta_v_item=u;
% beta_v=cat(1,beta_v,beta_v_item);
end
%6.show the surface
surface_item=[];
Q00=point_curve3(1,:);
Q01=point_curve3(end,:);
Q10=point_curve4(1,:);
Q11=point_curve4(end,:);

for i=1:N+1
  for j=1:N+1
    surface_item = alpha_u(i,2)*f1(j,:)+(1-alpha_u(i,2))*f2(j,:)+...
        beta_v(j,2)*f3(i,:)+(1-beta_v(j,2))*f4(i,:)-...
        (beta_v(j,2)*(alpha_u(i,2)*Q00+(1-alpha_u(i,2))*Q01)+...
        (1-beta_v(j,2))*(alpha_u(i,2)*Q10+(1-alpha_u(i,2))*Q11));
    sur=cat(1,sur,surface_item);
  end
end
x=sur(:,1);y=sur(:,2);z=sur(:,3);
[X,Y,Z]=griddata(x,y,z,linspace(min(x),max(x),30)',linspace(min(y),max(y),30),'v4');
surf(X,Y,Z);
title('coons patch');
legend(h,'P0','P1','Q0','Q1');
xlabel('x');
ylabel('y');
zlabel('z');
%plot3(sur(:,1),sur(:,2),sur(:,3));
% view(3)