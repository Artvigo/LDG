function [r_br,r_bl,q_br,q_bl,M,D,R_BR,R_BL,Q_BR,Q_BL] = assemble_RQ(Env,N,h)
%���� assemble_RQ_Elem ��װR,Q������ľ���
%   ���������Env��Ԫ�ڵ�ֵ��NΪ��Ԫ����hΪ����
%   ���������MΪ���������ڻ����ܸվ���DΪ�󵼺�Ļ��������ڻ����ܸվ���
%                    R_BR,R_BL,...���ڷ��̱߽��Ҷ˵���ܸվ���,��˵���ܸվ���
%                    r_br,r_bl,...���ڷ��̱߽�˵�ĵ�Ԫ����
%Ԥ����
m = zeros(3,3);
d = zeros(3,3);
r_bl = zeros(3,3);
r_br = zeros(3,3);
q_bl = zeros(3,3);
q_br = zeros(3,3);
%�ܸվ���
M=zeros(3*N,3*N);
D=zeros(3*N,3*N);
R_BR=zeros(3*N,3*N);
R_BL=zeros(3*N,3*N);
Q_BR=zeros(3*N,3*N);
Q_BL=zeros(3*N,3*N);

%�����Ƶ��õ���������������ڵ�Ԫ�ڵ�����˵��ֵ��ֻ��h�йأ����������Ԫ
r_br=[1,-h/2,h^2/4;h/2,-h^2/4,h^3/8;h^2/4,-h^3/8,h^4/16];
r_bl=[1,-h/2,h^2/4;-h/2,h^2/4,-h^3/8;h^2/4,-h^3/8,h^4/16];

q_br=[1,h/2,h^2/4;h/2,h^2/4,h^3/8;h^2/4,h^3/8,h^4/16];
q_bl=[1,h/2,h^2/4;-h/2,-h^2/4,-h^3/8;h^2/4,h^3/8,h^4/16];


%����������ʽ
% phi1=@(x)(1);
% phi2=@(x)(x-mid);
% phi3=@(x)((x-mid)^2);
% �󵼺�Ļ�������ʽ
% Dphi1=@(x)(0);
% Dphi2=@(x)(1);
% Dphi3=@(x)(2*(x-mid));

%������Ԫ����װ���ܸվ���
for i=1:N
    %aΪ��Ԫ��˵�
    a=Env(i,1);
    %bΪ��Ԫ�Ҷ˵�
    b=Env(i,2);
    mid=(a+b)/2;
    %���������ĳ˻�������������ֱ�����
    f1=@(x)(1);
    f2=@(x)(x-mid);
    f3=@(x)((x-mid).^2);
    f4=@(x)((x-mid).^3);
    f5=@(x)((x-mid).^4);

    %�������󵼺�ĳ˻�������������ֱ�����
    y1=@(x)(1);
    y2=@(x)(x-mid);
    y3=@(x)((x-mid).^2);
    y4=@(x)(2*(x-mid));
    y5=@(x)(2*(x-mid).^2);
    y6=@(x)(2*(x-mid).^3);
    %����������������������
    quad1 = quadrature(f1,a,b);
    quad2 = quadrature(f2,a,b);
    quad3 = quadrature(f3,a,b);
    quad4 = quadrature(f4,a,b);
    quad5 = quadrature(f5,a,b);
    %
    dquad1 = quadrature(y1,a,b);
    dquad2 = quadrature(y2,a,b);
    dquad3 = quadrature(y3,a,b);
    dquad4 = quadrature(y4,a,b);
    dquad5 = quadrature(y5,a,b);
    dquad6 = quadrature(y6,a,b);
    % ���վ���m
    m=[quad1,quad2,quad3;quad2,quad3,quad4;quad3,quad4,quad5];
    % ���վ���d
    d=[0,0,0;dquad1,dquad2,dquad3;dquad4,dquad5,dquad6];
    % ��װ
    M(3*i-2:3*i,3*i-2:3*i)=m;
    D(3*i-2:3*i,3*i-2:3*i)=d;
    R_BR(3*i-2:3*i,3*i-2:3*i)=r_br;
    R_BL(3*i-2:3*i,3*i-2:3*i)=r_bl;
    Q_BR(3*i-2:3*i,3*i-2:3*i)=q_br;
    Q_BL(3*i-2:3*i,3*i-2:3*i)=q_bl;
    end
end


