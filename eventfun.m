function [value,isternimal,direction]=eventfun(t,x)
value=t;%触发时间，当其值为0的时候，时间会触发,从而进入函数定义文件重新计算
%{
%event函数中需要的全局量
global Y_final;
%故障情形一：设置5-7无故障断线故障，故障发生时间为0.6s，故障发生后，线路即失去

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
%...短路故障，7点短路，5-7线路断开仿真测试（成功），在函数文件中引入Y_temp,在主程序中添加YM

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
isternimal=0;%设为1时会，触发时间会停止求解器，设0时触发不影响工作
direction=1; %触发方向设1时是上升触发，设-1是下降触发，设0是双向触发
end
