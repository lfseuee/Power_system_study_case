function dx=odefunusual(t,x)
%全局数据
%从主程序继承的全局变量
%....x,dx的维数为2*Generator_number，代表发电机的功角、转速
global Total_number;%系统总节点数
global Generator_number;%发电机节点数目
global Y_final;%原始形成的导纳矩阵
Y_temp=Y_final;%用于故障前后临时修改原始导纳矩阵
%....初始状态数据
global E1;%发电机的暂态电势
global Pm;%发电机原始机械功率，有必要，可以修改
global Qm;%发电机原始无功输出功率
global Pl;%负荷有功功率
global Ql;%负荷无功功率
global V0;%电网节点电压（发电机对应机端电压,节点序号在前）
global Ang;%电网节点角度（角度值）
%....发电机参数
global TJ;%发电机惯性时间常数
global Ra;%定子电阻
global Xd;%d轴暂态电抗
global Xd1;%d轴次暂态电抗
global Xq;%q轴暂态电抗
global Xq1;%q轴次暂态电抗
global Td01;%d轴次暂态时间常数
global Tq01;%q轴次暂态时间常数
global D;%阻尼系数
%函数文件中定义的全局变量
global y;%代数方程的电压变量
global m;%用于辅助输出电压、功率、注入电流等参量
global YK;%用于存储计算的电压y值
global I_show;%用于存储计算的注入电流值
global P;%发电机有功功率输出
global Q;%发电机无功功率输出
global T_rec;%用于记录在函数文件中时间t的变化情况
T_rec(1,m)=t;
%event文件中定义的全局变量
global Y_fault;%用于故障后导纳矩阵的修改
global Fault_bus;%用于故障后定义故障节点


%函数文件中的临时参数
for i=1:Generator_number %计算发电机节点的导纳参数
    Gx(i)=(Ra(i)-(Xd1(i)-Xq(i))*sind(x(2*i-1))*cosd(x(2*i-1)))/(Ra(i)^2+Xd1(i)*Xq(i));
    Gy(i)=(Ra(i)+(Xd1(i)-Xq(i))*sind(x(2*i-1))*cosd(x(2*i-1)))/(Ra(i)^2+Xd1(i)*Xq(i));
    Bx(i)=(Xd1(i)*cosd(x(2*i-1))^2+Xq(i)*sind(x(2*i-1))^2)/(Ra(i)^2+Xd1(i)*Xq(i));
    By(i)=(-Xd1(i)*sind(x(2*i-1))^2-Xq(i)*cosd(x(2*i-1))^2)/(Ra(i)^2+Xd1(i)*Xq(i));
end


%中间参数，y，代表代数方程，代表网络节点的x,y轴电压，维数为2*Total_number,写成y=inv(Y_final)*I_inj形式
I_inj=zeros(2*Total_number,1);

for i=1:Generator_number
    I_inj(2*i-1,1)=Gx(i)*E1(i)*cosd(x(2*i-1))+Bx(i)*E1(i)*sind(x(2*i-1));
    I_inj(2*i,1)=By(i)*E1(i)*cosd(x(2*i-1))+Gy(i)*E1(i)*sind(x(2*i-1));           
end
for i=1:Generator_number
    Y_temp(2*i-1,2*i-1)=Y_temp(2*i-1,2*i-1)+Gx(i);
    Y_temp(2*i-1,2*i)=Y_temp(2*i-1,2*i)+Bx(i);
    Y_temp(2*i,2*i-1)=Y_temp(2*i,2*i-1)+By(i);
    Y_temp(2*i,2*i)=Y_temp(2*i,2*i)+Gy(i);
end
%针对故障节点进行修改（测试时候尝试都变为无穷大G，B）

Y_temp(2*Fault_bus-1,2*Fault_bus)=Y_temp(2*Fault_bus-1,2*Fault_bus)+Y_fault;
Y_temp(2*Fault_bus,2*Fault_bus-1)=Y_temp(2*Fault_bus,2*Fault_bus-1)+Y_fault;

y=Y_temp\I_inj;%给出代数方程的定义式

YK(1:2*Total_number,m)=y;%定义输出电压结果输出
I_show(1:2*Total_number,m)=I_inj;%定义注入电流结果输出


%列出微分方程，写成dx=COE*x+RES的形式
COE=zeros(2*Generator_number,2*Generator_number);
RES=zeros(2*Generator_number,1);
for i=1:Generator_number
    COE(2*i-1,2*i)=360*50;
end
for i=1:Generator_number
    RES(2*i-1,1)=-360*50;
end
for i=1:Generator_number
    Ix=Gx(i)*(E1(i)*cosd(x(2*i-1))-y(2*i-1))+Bx(i)*(E1(i)*sind(x(2*i-1))-y(2*i));
    Iy=By(i)*(E1(i)*cosd(x(2*i-1))-y(2*i-1))+Gy(i)*(E1(i)*sind(x(2*i-1))-y(2*i));
    Pe(i)=y(2*i-1)*Ix+y(2*i)*Iy;
    Qe(i)=-1*y(2*i-1)*Iy+y(2*i)*Ix;
    RES(2*i,1)=(Pm(i)-Pe(i))/TJ(i);
end
     
P(m,1:3)=Pe(1:3);%定义发电机有功功率结果输出
Q(m,1:3)=Qe(1:3);%定义发电机无功功率结果输出
m=m+1;%变化量

dx=COE*x+RES;




























