%%
N=10;
a=-25;
b=25;
%��������
[h,Env] = MeshGen1D(a,b,N);
%%
%������R�ķ���
[M,D,R_BR,R_BL] = assemble_R_Elem(Env,N,h);
%�����ֵU0
[U] = Initializeu(Env,M,N);
[R,UL] = assemble_R_RH(U,M,R_BR,R_BL,D,N);
%%
%������Q�ķ���
 [Q_BR,Q_BL] = assemble_Q_Elem(N,h);
 [Q,RR] = assemble_Q_RH(U,R,M,Q_BR,Q_BL,D,N);
%%
%������P�ķ���
 [P_BR,P_BL,RU] = assemble_P_Elem(U,R,UL,RR,Env,N,h);
[P] = assemble_P_RH(M,P_BR,P_BL,RU,N);
%%
%ʱ�䲽��
time=1;
dt=time/N;
%����QT
[QT_BR,QT_BL,RUP] = assemble_QT_Elem(U,R,UL,RR,P,Env,N,h);
[QT] = assemble_QT_RH(M,Q,QT_BR,QT_BL,RUP,N,dt);
%��ֵ��Qѭ��
Q=QT;
%%
%ʱ����ɢ
for tstep=1:10
    %��Ͼ������U,R����
    [U,R]=Coupling_matrix(Q,M,Q_BL,Q_BR,R_BL,R_BR,D,N);
    
    %�µ�U,R���µı߽紦��
    UL=zeros(3*N,1);
    UL(1:3,1)=U(3*N-2:3*N,1);
    for i=2:N
        UL(3*i-2:3*i,1)=U(3*i-5:3*i-3,1);
    end
    RR=zeros(3*N,1);
    for i=1:N-1
        RR(3*i-2:3*i,1)=R(3*i+1:3*i+3,1);
    end
    RR(3*N-2:3*N,1)=R(1:3,1);
   
    %������P
    [P_BR,P_BL,RU] = assemble_P_Elem(U,R,UL,RR,Env,N,h);
    [P] = assemble_P_RH(M,P_BR,P_BL,RU,N);
    
    %������QT
    [QT_BR,QT_BL,RUP] = assemble_QT_Elem(U,R,UL,RR,P,Env,N,h);
    [QT] = assemble_QT_RH(M,Q,QT_BR,QT_BL,RUP,N,dt);
    %��ֵ��Qѭ��
    Q=QT;
end
%���������Q�����U
[U] = Calculate_U(M,Q,D,R,Q_BL,RR,Q_BR,N,h);
%%
x = linspace (-25, 25, N+1);
t = linspace (0.0,1.0,N+1) ;

nu=zeros(N,1);
eu=zeros(N,1);

% ��ֵ�� nu
for i=1:N
    nu(i,1)=U(3*i-2);
end

% ��� eu
    for i= 1:N
        x(i)=(x(i)+x(i+1))/2;
        eu(i,1) = 0.25*exp(-abs(x(i)-0.25*time));        
    end
% eu


% ������
error=abs(nu-eu)


% L1_error=sum(abs(nu-eu))/N sqrt(sum((nu-eu).^2)/N);
L2_error=norm(eu-nu,2)
Lmax_error=max(abs(nu-eu))

% ��ͼ
plot ( x(1:N),nu,'.b:', x(1:N),eu,'+r:');
legend ( 'numrical solution ', 'exact    solution ') ;
grid on ;
u_min=min(min(nu));
u_max=max(max(nu));
axis([-25 25 u_min-0.2,u_max+1]);
title ( sprintf ( ' NStep%d,Time%f \n ', N, 1 ) );
xlabel ( '------X------' ) ;
ylabel ( '------U------' );

