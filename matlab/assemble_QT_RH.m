function [QT] = assemble_QT_RH(M,Q,QT_BR,QT_BL,RUP,N,dt)
%���� assemble_QT_Elem ��QT
%   ���������Q_BR,Q_BL����Q���̱߽��Ҷ˵���ܸվ���,��˵���ܸվ���RUP
%   ���������QT����
%   ŷ������                 

%Ԥ����
F=zeros(3*N,1);
%�Ҷ���
F=M*Q+dt*(RUP+QT_BL-QT_BR);
%[l,u]=lu(M);
%���
QT=M\F;
end