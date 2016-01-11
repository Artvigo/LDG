%%
%��Ԫ��
N=160;
%ʱ��
time=1;
%ʱ�䲽��
NT=400;
% NT=300;
%ʱ�䲽��
dt=time/NT;
%�������Ҷ˵�
a=-25;
b=25;
%��������xΪ�ڵ�ֵ������hΪ��Ԫ������EnvΪ��Ԫ���Ҷ˵��ֵ���󣬴�СΪ(N,2)
[h,Env,x] = MeshGen1D(a,b,N);
%%
%������R,Q����
[r_br,r_bl,q_br,q_bl,M,D,R_BR,R_BL,Q_BR,Q_BL] = assemble_RQ(Env,N,h);
%�����ֵU0
[U] = Initializeu(Env,M,N);
%  ��ֵ�� nu
% for i=1:N
%     nu(i,1)=U(3*i-2,1);
% end
% ��� eu
%     for i= 1:N
%         x(i)=(x(i)+x(i+1))/2;
%         eu(i,1) = 0.25*exp(-abs(x(i)));        
%     end
% % ������
% error=abs(nu-eu)
% Lmax_error=max(abs(nu-eu))

% ��װR�����Ҷ��URΪU���Ҷ�ƽ��һ����Ԫ������
[FR,UR] = assemble_R_RH(U,R_BR,R_BL,D,N);
%��R����
R=M\FR;
%%
%������Q�ķ���
%��װ�Ҷ��RL��R���������ƽ��һ����Ԫ������
[FQ,RL] = assemble_Q_RH(U,R,M,Q_BR,Q_BL,D,N);
%��Q����
Q=M\FQ;
%%
%������P�ķ���
[P_BR,P_BL,RU,FP] = assemble_P(U,R,UR,RL,Env,N,h);
%������Է���
P=M\FP;
%%
%����QT
[QT_BR,QT_BL,RUP,FQT] = assemble_QT(U,R,UR,RL,P,Env,N,h);
%ŷ�������
F_QT=M*Q+dt*FQT;
QT=M\F_QT;
%��ֵ��Q,ѭ������
Q=QT;
%%
%��Ͼ�����װ
[C]=Coupling_matrix(M,r_bl,r_br,q_bl,q_br,D,N);
%%
%ʱ����ɢ
for tstep=1:NT
    %��װ�Ҷ���
    CRH=zeros(6*N,1);
    CRH(1:3*N,1)=M*Q;
    %���U,R
    X=zeros(6*N,1);
    X=C\CRH;
    U=X(1:3*N,1);
    R=X(3*N+1:6*N,1);
    
   %�µ�UR,RL���µĴ���U,R�ֱ����Һ����ƶ�һ����Ԫ
   UR=zeros(3*N,1);
   UR(3*N-2:3*N,1)=U(1:3,1);
    for i=1:N-1
        UR(3*i-2:3*i,1)=U(3*i+1:3*i+3,1);
    end
    
    RL=zeros(3*N,1);
    for i=2:N
    RL(3*i-2:3*i,1)=R(3*i-5:3*i-3,1);
    end
    RL(1:3,1)=R(3*N-2:3*N,1);
   
    %������P
    [P_BR,P_BL,RU,FP] = assemble_P(U,R,UR,RL,Env,N,h);
    P=M\FP;
    
    %������QT
    [QT_BR,QT_BL,RUP,FQT] = assemble_QT(U,R,UR,RL,P,Env,N,h);
    F_QT=M*Q+dt*FQT;
    QT=M\F_QT;
    Q=QT;
end
%%
%���������Q�����U
[U] = Calculate_U(M,Q,D,R,Q_BL,RL,Q_BR,N);
t = linspace (0.0,time,NT+1);
nu=zeros(N,1);
eu=zeros(N,1);

% ��ֵ�� nu
for i=1:N
    nu(i,1)=U(3*i-2,1);
end

% ��� eu
    for i= 1:N
        x(i)=(x(i)+x(i+1))/2;
        eu(i,1) = 0.25*exp(-abs(x(i)-0.25*time));        
    end



% ������
error=abs(nu-eu);
L2_error=norm(eu-nu,2);
Lmax_error=max(abs(nu-eu))

% ��ͼ
plot ( x(1:N),nu,'.b:', x(1:N),eu,'+r:');
legend ( 'numrical solution ', 'exact    solution ') ;
grid on ;
u_min=min(min(nu));
u_max=max(max(nu));
axis([a b u_min-0.2,u_max+0.2]);
title ( sprintf ( ' NStep%d,Time%f \n ', N, 1 ) );
xlabel ( '------X------' ) ;
ylabel ( '------U------' );