function [value,isternimal,direction]=eventfun(t,x)
value=t;%����ʱ�䣬����ֵΪ0��ʱ��ʱ��ᴥ��,�Ӷ����뺯�������ļ����¼���
%{
%event��������Ҫ��ȫ����
global Y_final;
%��������һ������5-7�޹��϶��߹��ϣ����Ϸ���ʱ��Ϊ0.6s�����Ϸ�������·��ʧȥ

if t==0.6
    Y_final(9:10,13:14)=[0 0;0 0];
    Y_final(13:14,9:10)=[0 0;0 0];
    Y_final(9:10,9:10)=[1.3652 11.5161;-11.5161 1.3652];
    Y_final(13:14,13:14)=[1.6171 29.6235;-29.6235 1.6171]; 
    t
end
%}
%{    

    Y_final(3:4,3:4)=[0 0;0 0];
    Y_final(3:4,13:14)=[0 0;0 0];
    Y_final(13:14,3:4)=[0 0;0 0];
    Y_final(13:14,3:4)=YM(13:14,3:4)-[0 16;-16 0];
    %}
%{
%...��·���ϣ�7���·��5-7��·�Ͽ�������ԣ��ɹ������ں����ļ�������Y_temp,�������������YM

global Y_final
global Y_fault
global Fault_bus
global YM

if t<=0.07
    Y_fault=1e8;
    Fault_bus=7;
end

if t>0.07
    Y_fault=0;
    Fault_bus=7;
    Y_ch1=1/(0.032+j*0.161)+j*0.153;
    Y_ch2=-1/(0.032+j*0.161);
    Y_final(9:10,9:10)=YM(9:10,9:10)-[real(Y_ch1) -imag(Y_ch1);
        imag(Y_ch1) real(Y_ch1)];
    Y_final(9:10,13:14)=YM(9:10,13:14)-[real(Y_ch2) -imag(Y_ch2);
        imag(Y_ch2) real(Y_ch2)];
    Y_final(13:14,9:10)= YM(13:14,9:10)-[real(Y_ch2) -imag(Y_ch2);
        imag(Y_ch2) real(Y_ch2)];
    Y_final(13:14,13:14)=YM(13:14,13:14)-[real(Y_ch1) -imag(Y_ch1);
        imag(Y_ch1) real(Y_ch1)];
end
%}
isternimal=0;%��Ϊ1ʱ�ᣬ����ʱ���ֹͣ���������0ʱ������Ӱ�칤��
direction=1; %����������1ʱ��������������-1���½���������0��˫�򴥷�
end
