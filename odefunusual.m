function dx=odefunusual(t,x)
%ȫ������
%��������̳е�ȫ�ֱ���
%....x,dx��ά��Ϊ2*Generator_number����������Ĺ��ǡ�ת��
global Total_number;%ϵͳ�ܽڵ���
global Generator_number;%������ڵ���Ŀ
global Y_final;%ԭʼ�γɵĵ��ɾ���
Y_temp=Y_final;%���ڹ���ǰ����ʱ�޸�ԭʼ���ɾ���
%....��ʼ״̬����
global E1;%���������̬����
global Pm;%�����ԭʼ��е���ʣ��б�Ҫ�������޸�
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
global YK;%���ڴ洢����ĵ�ѹyֵ
global I_show;%���ڴ洢�����ע�����ֵ
global P;%������й��������
global Q;%������޹��������
global T_rec;%���ڼ�¼�ں����ļ���ʱ��t�ı仯���
T_rec(1,m)=t;
%event�ļ��ж����ȫ�ֱ���
global Y_fault;%���ڹ��Ϻ��ɾ�����޸�
global Fault_bus;%���ڹ��Ϻ�����Ͻڵ�


%�����ļ��е���ʱ����
for i=1:Generator_number %���㷢����ڵ�ĵ��ɲ���
    Gx(i)=(Ra(i)-(Xd1(i)-Xq(i))*sind(x(2*i-1))*cosd(x(2*i-1)))/(Ra(i)^2+Xd1(i)*Xq(i));
    Gy(i)=(Ra(i)+(Xd1(i)-Xq(i))*sind(x(2*i-1))*cosd(x(2*i-1)))/(Ra(i)^2+Xd1(i)*Xq(i));
    Bx(i)=(Xd1(i)*cosd(x(2*i-1))^2+Xq(i)*sind(x(2*i-1))^2)/(Ra(i)^2+Xd1(i)*Xq(i));
    By(i)=(-Xd1(i)*sind(x(2*i-1))^2-Xq(i)*cosd(x(2*i-1))^2)/(Ra(i)^2+Xd1(i)*Xq(i));
end


%�м������y������������̣���������ڵ��x,y���ѹ��ά��Ϊ2*Total_number,д��y=inv(Y_final)*I_inj��ʽ
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
%��Թ��Ͻڵ�����޸ģ�����ʱ���Զ���Ϊ�����G��B��

Y_temp(2*Fault_bus-1,2*Fault_bus)=Y_temp(2*Fault_bus-1,2*Fault_bus)+Y_fault;
Y_temp(2*Fault_bus,2*Fault_bus-1)=Y_temp(2*Fault_bus,2*Fault_bus-1)+Y_fault;

y=Y_temp\I_inj;%�����������̵Ķ���ʽ

YK(1:2*Total_number,m)=y;%���������ѹ������
I_show(1:2*Total_number,m)=I_inj;%����ע�����������


%�г�΢�ַ��̣�д��dx=COE*x+RES����ʽ
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
     
P(m,1:3)=Pe(1:3);%���巢����й����ʽ�����
Q(m,1:3)=Qe(1:3);%���巢����޹����ʽ�����
m=m+1;%�仯��

dx=COE*x+RES;




























