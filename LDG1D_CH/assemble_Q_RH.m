function [FQ,RL] = assemble_Q_RH(U,R,M,Q_BR,Q_BL,D,N)
%���� assemble_Q_RH ��FQ����,RL
%   ���������NΪ��Ԫ��,hΪ����,DΪ�󵼺�Ļ��������ڻ����ܸվ���,MΪ���������ڻ����ܸվ���
%                    R������U������ Q_BR,Q_BL����Q���̱߽��Ҷ˵���ܸվ���,��˵���ܸվ���
%   ���������FQ������RLΪ��R�仯��������ֵ���⴦��
               

%Ԥ����
FQ=zeros(3*N,1);
RL=zeros(3*N,1);

% �߽紦��
for i=2:N
    RL(3*i-2:3*i,1)=R(3*i-5:3*i-3,1);
end
RL(1:3,1)=R(3*N-2:3*N,1);

%�Ҷ���
FQ=M*U+(D-Q_BR)*R+Q_BL*RL;
end