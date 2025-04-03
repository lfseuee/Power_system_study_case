clear;
clear global;
clc;
%主程序中定义的变量
%....基本参数
global Total_number;%系统总节点数
global Generator_number;%发电机节点数目
global Y_final;%原始形成的导纳矩阵
%....初始状态数据
global E1;
global Pm;
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
m=1;%m初始化为1
global YK;%用于存储计算的电压y值
global I_show;%用于存储计算的注入电流值
global P;%发电机有功功率输出
global Q;%发电机无功功率输出
global T_rec;%用于记录在函数文件中时间t的变化情况
%event文件中定义的全局变量
global Y_fault;%用于故障后导纳矩阵的修改
Y_fault=0;
global Fault_bus;%用于故障后定义故障节点
Fault_bus=1;
global YM;
%基本参数初始化区域，需要手动输入
Total_number=9;%系统总节点数
Generator_number=3;%发电机节点数目
%（1）发电机基本参数
TJ=[47.28 12.80 6.02];%发电机惯性时间常数
%TJ=[19.10 6.67 4.70];%仿照BPA参数设定值
Ra=[0 0 0];%定子电阻
Xd=[0.146 0.8958 1.3125];%d轴暂态电抗
Xd1=[0.0608 0.1198 0.1813];%d轴次暂态电抗
Xq=[0.0969 0.8645 1.2578];%q轴暂态电抗
Xq1=[0.0969 0.1969 0.25];%q轴次暂态电抗
Td01=[8.96 6.00 5.89];%d轴次暂态时间常数
Tq01=[0 0.535 0.600];%q轴次暂态时间常数
D=[0 0 0];%阻尼系数
%（2）负荷基本参数(静态负荷+马达负荷，待补充)

%（3）线路数据[首端母线名 末端母线名 电阻（标幺值） 电抗（标幺值） 容纳之半（标幺值） 变压器非标准变比]
line_transformer_data=[4 5 0.010 0.085 0.088 0;
    4 6 0.017 0.092 0.079 0;
    5 7 0.032 0.161 0.153 0;
    6 9 0.039 0.170 0.179 0;
    7 8 0.0085 0.072 0.0745 0;
    8 9 0.0119 0.1008 0.1045 0;
    1 4 0.0 0.0576 0 1.0;
    2 7 0.0 0.0625 0 1.0;
    3 9 0.0 0.0586 0 1.0;];
[ltd_m ltd_n]=size(line_transformer_data);
%形成导纳矩阵
Y_line=1./(line_transformer_data(:,3)+j*line_transformer_data(:,4));
Y_1=zeros(Total_number,Total_number);%初始导纳矩阵
%对角线初始化
for Y_i=1:Total_number
    m_1=find(line_transformer_data(:,1)==Y_i);
    m_2=find(line_transformer_data(:,2)==Y_i);
    for Y_m_1=1:length(m_1)
        Y_1(Y_i,Y_i)=Y_1(Y_i,Y_i)+Y_line(m_1(Y_m_1))+j*line_transformer_data(m_1(Y_m_1),5);
    end
    for Y_m_2=1:length(m_2)
        Y_1(Y_i,Y_i)=Y_1(Y_i,Y_i)+Y_line(m_2(Y_m_2))+j*line_transformer_data(m_2(Y_m_2),5);
    end
    m_1=0;
    n_1=0;
end
%线路阻抗代入
for Y_i=1:ltd_m
    Y_1(line_transformer_data(Y_i,1),line_transformer_data(Y_i,2))=-1*Y_line(Y_i);
    Y_1(line_transformer_data(Y_i,2),line_transformer_data(Y_i,1))=-1*Y_line(Y_i);
end
%（4）计算数据初始化，Y矩阵修改计算
Pm=[0.7164 1.63 0.85];%发电机初始机械功率，初始发电功率（标幺值）
Qm=[0.2705 0.0665 -0.1086];%发电机无功功率
Pl=[0 0 0 0 1.25 0.90 0 1.0 0];%负荷有功功率
Ql=[0 0 0 0 0.5 0.3 0 0.35 0];%负荷无功功率
V0=[1.040 1.025 1.025 1.0258 0.9956 1.0127 1.0258 1.0159 1.0324];%电网节点电压（发电机对应机端电压,节点序号在前）
Ang=[0 9.28 4.6648 -2.2168 -3.9888 -3.6874 3.7197 0.7275 1.9667];%电网节点角度（角度值）

Im=conj(Pm+j*Qm)./conj(V0(1:Generator_number).*cosd(Ang(1:Generator_number))+j*V0(1:Generator_number).*sind(Ang(1:Generator_number)));%发电机初始注入电流，该处开始的部分求暂态电势
E_r=V0(1:Generator_number).*cosd(Ang(1:Generator_number))+j*V0(1:Generator_number).*sind(Ang(1:Generator_number))+(Ra+j*Xq).*Im;%虚拟电动势，用于确定初始delta角度
del=phase(E_r);%功角角度也已经求出
delta_0=rad2deg(del);%转为角度值
V_dq=(V0(1:Generator_number).*cosd(Ang(1:Generator_number))+j*V0(1:Generator_number).*sind(Ang(1:Generator_number))).*(sind(delta_0)+j*cosd(delta_0));
I_dq=Im.*(sind(delta_0)+j*cosd(delta_0));
E1=imag(V_dq)+Ra.*imag(I_dq)+Xd1.*real(I_dq);%至此，求出暂态电势

Yload=conj(Pl+j*Ql)./(V0.^2);%求出负荷的阻抗
Y_regulated=Y_1;%利用负荷阻抗对原阻抗矩阵进行修正
for i=1:Total_number
    Y_regulated(i,i)=Y_regulated(i,i)+Yload(i);
end
for i=1:Total_number
    Y_te(2*i-1,:)=conj(Y_regulated(i,:));
    Y_te(2*i,:)=imag(Y_regulated(i,:))+j*real(Y_regulated(i,:));
end
for i=1:Total_number%得到阻抗的最终形式（2*Total_number,2*Total_number）
    Y_final(:,2*i-1)=real(Y_te(:,i));
    Y_final(:,2*i)=imag(Y_te(:,i));
end

%计算数据准备
%（1）形成初值
x0=zeros(2*Generator_number,1);
for i=1:Generator_number
    x0(2*i)=1;
    x0(2*i-1)=delta_0(i);
end
YM=Y_final;
%...不引用event事件的时候，正常情况已测试正确
%[t,x]=ode15s('odefunusual',[0 100],x0);

%...引用event事件的时候，正在测试中
options=odeset('events',@eventfun);
[t,x,TE,XE,IE]=ode15s(@odefunusual,[0:1e-3:2],x0,options);

%数据转化处理，将函数文件中的时间与实际时间匹配，方便作图
 for i=1:Total_number
     U(i,:)=sqrt(YK(2*i-1,:).^2+YK(2*i,:).^2);
 end
%{
 for i=1:length(t)
     Match=find(T_rec(1,:)==t(i));
     if isempty(Match)
         continue;
     else YK_new(:,i)=YK(:,Match(1));
         I_show_new(:,i)=I_show(:,Match(1));
         P_new(i,:)=P(Match(1),:);
         Q_new(i,:)=Q(Match(1),:);
         U_new(:,i)=U(:,Match(1));
     end
 end
 U_new=U_new';
 %}
 for i=1:length(T_rec)
    if i==1
        YK_new(:,i)=YK(:,i);
        I_show_new(:,i)=I_show(:,i);
        P_new(i,:)=P(i,:);
        Q_new(i,:)=Q(i,:);
        U_new(:,i)=U(:,i);
    end
    if i~=1&&T_rec(i-1)~=T_rec(i)
        YK_new(:,i)=YK(:,i);
        I_show_new(:,i)=I_show(:,i);
        P_new(i,:)=P(i,:);
        Q_new(i,:)=Q(i,:);
        U_new(:,i)=U(:,i);
    end
 end
delta_diff(:,1)=x(:,3)-x(:,1);
delta_diff(:,2)=x(:,5)-x(:,1);









