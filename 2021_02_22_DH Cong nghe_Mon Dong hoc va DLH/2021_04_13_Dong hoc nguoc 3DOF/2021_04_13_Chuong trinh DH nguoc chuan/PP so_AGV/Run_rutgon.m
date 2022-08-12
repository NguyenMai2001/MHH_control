clc
clear
%% Parameters
[d1,a2,a3,R,h]=parameter();
%% Vi tri ban dau cua diem thao tac E
xx_0=0.5;yy_0=0;zz_0=0.5;
X_0=[xx_0;yy_0;zz_0];% Vec to vi tri E
% Gia tri gan dung cua goc khop ban dau, su dung auto cad de xac dinh
q1_0=0;q2_0=1.3826;q3_0=-2.0042;
%% Tinh chinh xac gia tri goc khop ban dau q_0
for n=1:1:10^10
    Jnd_0=TinhJnd(q1_0,q2_0,q3_0); % Tinh ma tran Jacobian theo q_0
    [xE_0,yE_0,zE_0]=Donghocthuan(q1_0,q2_0,q3_0);% tinh lai xx_0, yy_0 theo q_0
    XX_0=[xE_0;yE_0;zE_0];
    delta_q_0 = Jnd_0*(X_0 - XX_0);% Tinh gia tri hieu chinh delta_q_0
    % Tinh lai cac gia tri q_0 hieu chinh
    q1_0 = q1_0 + delta_q_0(1,1);
    q2_0 = q2_0 + delta_q_0(2,1);
    q3_0 = q3_0 + delta_q_0(3,1);
    % khai bao do chinh xac can thiet va tao vong lap tinh toan
    ss=10^(-10);
    if abs(delta_q_0(1,1)) < ss 
        if abs(delta_q_0(2,1)) < ss
            if abs(delta_q_0(3,1)) < ss            
            break
            end
        end
    end
    n;
end
% Xac nhan cac gia tri q_0 chinh xac sau khi hieu chinh
q1=q1_0;
q2=q2_0;
q3=q3_0;

%% Thuat toan ap dung cho toan bo quy dao x, y, z cho truoc
% bien thoi gian
dt=0.1; % Khai bao buoc thoi gian chay
t_max=10; % Khai bao thoi gian
%syms tt
for t=0:dt:t_max
[Xd,dXd]=Quydao(t); % Vi tri va van toc diem E cho truoc theo thoi gian t
Jnd=TinhJnd(q1,q2,q3); % Tinh ma tran Jacobian theo q
dX=[dXd(1);dXd(2);dXd(3)]; % Vec to van toc diem thao tac E cho truoc
q=[q1;q2;q3];
dq=Jnd*dX; % Van toc goc khop
for k=1:1:10^5
    q_k=q + dq*dt; % Tinh gia tri goc khop trong vong lap bien k
    q1=q_k(1,1);
    q2=q_k(2,1);
    q3=q_k(3,1);
    Jnd_real=TinhJnd(q1,q2,q3); % Tinh lai gia tri ma tran Jacobian
    [xE,yE,zE]=Donghocthuan(q1,q2,q3); % Tinh lai quy dao diem E tu q tim duoc
    Xq=[xE;yE;zE];
    [Xd,dXd]=Quydao(t);% Goi quy dao mong muon
    Xm=[Xd(1);Xd(2);Xd(3)];
    Delta_q = Jnd_real*(Xm - Xq);% Tinh sai lech goc khop
    % khai bao do chinh xac can thiet
    ss1=10^(-5);
    if abs(Delta_q(1,1)) < ss1 
        if abs(Delta_q(2,1)) < ss1
            if abs(Delta_q(3,1)) < ss1           
            break
            end
        end
    end     
end
    k;
    % Tinh lai gia tri goc khop chinh xac
    q1 = q1 + Delta_q(1,1);
    q2 = q2 + Delta_q(2,1);
    q3 = q3 + Delta_q(3,1);
% Tinh lai quy dao lan nua
  [xE_tinhlai,yE_tinhlai,zE_tinhlai]=Donghocthuan(q1,q2,q3);
%% Bieu dien co cau chuyen dong de kiem tra tinh chinh xac tu q1, q2, q3 tim duoc
 figure(1)
  P1=[0 0 0];
  viscircles([P1(3) P1(2)],0.005,'Color','r');
% Mo phong quy dao
curve=animatedline('Linewidth',1.5);
set(gca,'xlim',[-0.1 0.7],'Ylim',[-0.4 0.4],'Zlim',[0 0.9]);
view(43,24);
xlabel('X(m)');
ylabel('Y(m)');
zlabel('Z(m)'); 
for t_q1=0:0.01:1
    x_khau_1=0;
    y_khau_1=0;
    z_khau_1=d1*t_q1;
    plot3(x_khau_1,y_khau_1,z_khau_1,'b.',0,0,d1,'r.')
    grid on
    hold on
end
for t_q2=0:0.08:1
    x_khau_2=a2*cos(q1)*cos(q2)*t_q2;
    y_khau_2=a2*sin(q1)*cos(q2)*t_q2;
    z_khau_2=d1+a2*sin(q2)*t_q2;
    plot3(x_khau_2,y_khau_2,z_khau_2,'y.',a2*cos(q1)*cos(q2),a2*sin(q1)*cos(q2),d1+a2*sin(q2),'g.')
    hold on
    grid on
end
for t_q3=0:0.08:1
    x_khau_3=a2*cos(q1)*cos(q2)+a3*cos(q1)*cos(q2)*cos(q3)*t_q3-a3*cos(q1)*sin(q2)*sin(q3)*t_q3;
    y_khau_3=a2*sin(q1)*cos(q2)+a3*sin(q1)*cos(q2)*cos(q3)*t_q3-a3*sin(q1)*sin(q2)*sin(q3)*t_q3;
    z_khau_3=d1+a2*sin(q2)+a3*sin(q2+q3)*t_q3;
    plot3(x_khau_3,y_khau_3,z_khau_3,'r.',xE_tinhlai,yE_tinhlai,zE_tinhlai,'bo')
    hold on
    grid on
end
M(:,:) = getframe;
pause(0.05) 
hold on
grid on
end





































