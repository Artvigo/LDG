function [U] = Initializeu(Env,M,N)
%���� Initializeu ���ֵU
%   ���������Env��Ԫ�ڵ�ֵ��NΪ��Ԫ����MΪ���������ڻ����ܸվ���
%   ���������U��ֵ

%Ԥ����
U=zeros(3*N,1);
%�Ҷ���
F=zeros(3*N,1);

% ��Ԫѭ��
for i=1:N
    a=Env(i,1);
    b=Env(i,2);
    mid=(a+b)/2;
    
    % ��������   
    f1=@(x)(0.25*exp(-abs(x)));
    f2=@(x)(0.25*exp(-abs(x)).*(x-mid));
    f3=@(x)(0.25*exp(-abs(x)).*(x-mid).^2);

    %���
    quad1=quadrature(f1,a,b);
    quad2=quadrature(f2,a,b);
    quad3=quadrature(f3,a,b);
    %��װ�Ҷ���
    F(3*i-2:3*i)=[quad1,quad2,quad3]';
end
%[l,u]=lu(M);
%������Է����飬���ֵ
U=M\F;
end


