clear;
clear global;
clc;
%�������ж���ı���
%....��������
global Total_number;%ϵͳ�ܽڵ���
global Generator_number;%������ڵ���Ŀ
global Y_final;%ԭʼ�γɵĵ��ɾ���
%....��ʼ״̬����
global E1;
global Pm;
global Qm;%�����ԭʼ�޹��������
global Pl;%�����й�����
global Ql;%�����޹�����
global V0;%�����ڵ��ѹ���������Ӧ���˵�ѹ,�ڵ������ǰ��
global Ang;%�����ڵ�Ƕȣ��Ƕ�ֵ��
%....���������
global TJ;%���������ʱ�䳣��
global Ra;%���ӵ���
global Xd;%d����̬�翹
global Xd1;%d�����̬�翹
global Xq;%q����̬�翹
global Xq1;%q�����̬�翹
global Td01;%d�����̬ʱ�䳣��
global Tq01;%q�����̬ʱ�䳣��
global D;%����ϵ��
%�����ļ��ж����ȫ�ֱ���
global y;%�������̵ĵ�ѹ����
global m;%���ڸ��������ѹ�����ʡ�ע������Ȳ���
m=1;%m��ʼ��Ϊ1
global YK;%���ڴ洢����ĵ�ѹyֵ
global I_show;%���ڴ洢�����ע�����ֵ
global P;%������й��������
global Q;%������޹��������
global T_rec;%���ڼ�¼�ں����ļ���ʱ��t�ı仯���
%event�ļ��ж����ȫ�ֱ���
global Y_fault;%���ڹ��Ϻ��ɾ�����޸�
Y_fault=0;
global Fault_bus;%���ڹ��Ϻ�����Ͻڵ�
Fault_bus=1;
global YM;
%����������ʼ��������Ҫ�ֶ�����
Total_number=9;%ϵͳ�ܽڵ���
Generator_number=3;%������ڵ���Ŀ
%��1���������������
TJ=[47.28 12.80 6.02];%���������ʱ�䳣��
%TJ=[19.10 6.67 4.70];%����BPA�����趨ֵ
Ra=[0 0 0];%���ӵ���
Xd=[0.146 0.8958 1.3125];%d����̬�翹
Xd1=[0.0608 0.1198 0.1813];%d�����̬�翹
Xq=[0.0969 0.8645 1.2578];%q����̬�翹
Xq1=[0.0969 0.1969 0.25];%q�����̬�翹
Td01=[8.96 6.00 5.89];%d�����̬ʱ�䳣��
Tq01=[0 0.535 0.600];%q�����̬ʱ�䳣��
D=[0 0 0];%����ϵ��
%��2�����ɻ�������(��̬����+��︺�ɣ�������)

%��3����·����[�׶�ĸ���� ĩ��ĸ���� ���裨����ֵ�� �翹������ֵ�� ����֮�루����ֵ�� ��ѹ���Ǳ�׼���]
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
%�γɵ��ɾ���
Y_line=1./(line_transformer_data(:,3)+j*line_transformer_data(:,4));
Y_1=zeros(Total_number,Total_number);%��ʼ���ɾ���
%�Խ��߳�ʼ��
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
%��·�迹����
for Y_i=1:ltd_m
    Y_1(line_transformer_data(Y_i,1),line_transformer_data(Y_i,2))=-1*Y_line(Y_i);
    Y_1(line_transformer_data(Y_i,2),line_transformer_data(Y_i,1))=-1*Y_line(Y_i);
end
%��4���������ݳ�ʼ����Y�����޸ļ���
Pm=[0.7164 1.63 0.85];%�������ʼ��е���ʣ���ʼ���繦�ʣ�����ֵ��
Qm=[0.2705 0.0665 -0.1086];%������޹�����
Pl=[0 0 0 0 1.25 0.90 0 1.0 0];%�����й�����
Ql=[0 0 0 0 0.5 0.3 0 0.35 0];%�����޹�����
V0=[1.040 1.025 1.025 1.0258 0.9956 1.0127 1.0258 1.0159 1.0324];%�����ڵ��ѹ���������Ӧ���˵�ѹ,�ڵ������ǰ��
Ang=[0 9.28 4.6648 -2.2168 -3.9888 -3.6874 3.7197 0.7275 1.9667];%�����ڵ�Ƕȣ��Ƕ�ֵ��

Im=conj(Pm+j*Qm)./conj(V0(1:Generator_number).*cosd(Ang(1:Generator_number))+j*V0(1:Generator_number).*sind(Ang(1:Generator_number)));%�������ʼע��������ô���ʼ�Ĳ�������̬����
E_r=V0(1:Generator_number).*cosd(Ang(1:Generator_number))+j*V0(1:Generator_number).*sind(Ang(1:Generator_number))+(Ra+j*Xq).*Im;%����綯�ƣ�����ȷ����ʼdelta�Ƕ�
del=phase(E_r);%���ǽǶ�Ҳ�Ѿ����
delta_0=rad2deg(del);%תΪ�Ƕ�ֵ
V_dq=(V0(1:Generator_number).*cosd(Ang(1:Generator_number))+j*V0(1:Generator_number).*sind(Ang(1:Generator_number))).*(sind(delta_0)+j*cosd(delta_0));
I_dq=Im.*(sind(delta_0)+j*cosd(delta_0));
E1=imag(V_dq)+Ra.*imag(I_dq)+Xd1.*real(I_dq);%���ˣ������̬����

Yload=conj(Pl+j*Ql)./(V0.^2);%������ɵ��迹
Y_regulated=Y_1;%���ø����迹��ԭ�迹�����������
for i=1:Total_number
    Y_regulated(i,i)=Y_regulated(i,i)+Yload(i);
end
for i=1:Total_number
    Y_te(2*i-1,:)=conj(Y_regulated(i,:));
    Y_te(2*i,:)=imag(Y_regulated(i,:))+j*real(Y_regulated(i,:));
end
for i=1:Total_number%�õ��迹��������ʽ��2*Total_number,2*Total_number��
    Y_final(:,2*i-1)=real(Y_te(:,i));
    Y_final(:,2*i)=imag(Y_te(:,i));
end

%��������׼��
%��1���γɳ�ֵ
x0=zeros(2*Generator_number,1);
for i=1:Generator_number
    x0(2*i)=1;
    x0(2*i-1)=delta_0(i);
end
YM=Y_final;
%...������event�¼���ʱ����������Ѳ�����ȷ
%[t,x]=ode15s('odefunusual',[0 100],x0);

%...����event�¼���ʱ�����ڲ�����
options=odeset('events',@eventfun);
[t,x,TE,XE,IE]=ode15s(@odefunusual,[0:1e-3:2],x0,options);

%����ת�������������ļ��е�ʱ����ʵ��ʱ��ƥ�䣬������ͼ
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









