function [P] = assemble_P_RH(M,P_BR,P_BL,RU,N)
%���� assemble_P_Elem  ��P����
%   ���������NΪ��Ԫ��,MΪ���������ڻ����ܸվ���
%                    P_BR,P_BL����P���̱߽��Ҷ˵���ܸվ���,��˵���ܸվ���
%   ���������P����
%                   

%Ԥ����
F=zeros(3*N,1);
%�Ҷ���
F=-RU+P_BR-P_BL;
%[l,u]=lu(M);
%������Է���
P=M\F;
end