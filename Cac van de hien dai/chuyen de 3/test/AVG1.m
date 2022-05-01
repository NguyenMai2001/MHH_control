clc
clear
%% Parameters
[L1,L2,L3,R]=bien();
%% Vi tri ban dau cua diem thao tac E
xx_0=0.3;yy_0=0.9;
X_0=[xx_0;yy_0];% Vec to vi tri E
% Gia tri gan dung cua goc khop ban dau, su dung auto cad de xac dinh
q1_0=0.44;q2_0=2;q3_0=0;
%% Tinh chinh xac gia tri goc khop ban dau q_0
for n=1:1:10^10
    Jnd_0=Jacobian(q1_0,q2_0,q3_0); % Tinh ma tran Jacobian theo q_0
    [xE_0,yE_0]=donghocthuan(q1_0,q2_0,q3_0);% tinh lai xx_0, yy_0 theo q_0
    XX_0=[xE_0;yE_0];
    delta_q_0 = Jnd_0'*(X_0 - XX_0);% Tinh gia tri hieu chinh delta_q_0
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
[Xd,dXd]=quy_dao(t); % Vi tri va van toc diem E cho truoc theo thoi gian t
Jnd=Jacobian(q1,q2,q3); % Tinh ma tran Jacobian theo q
dX=[dXd(1);dXd(2)]; % Vec to van toc diem thao tac E cho truoc
q=[q1;q2;q3];
dq=Jnd'*dX; % Van toc goc khop
for k=1:1:10^5
    q_k=q + dq*dt; % Tinh gia tri goc khop trong vong lap bien k
    q1=q_k(1,1);
    q2=q_k(2,1);
    q3=q_k(3,1);

    Jnd_real=Jacobian(q1,q2,q3); % Tinh lai gia tri ma tran Jacobian
    [xE,yE]=donghocthuan(q1,q2,q3); % Tinh lai quy dao diem E tu q tim duoc
    Xq=[xE;yE];
    [Xd,dXd]=quy_dao(t);% Goi quy dao mong muon
    Xm=[Xd(1);Xd(2)];
    Delta_q = Jnd_real'*(Xm - Xq);% Tinh sai lech goc khop
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
  [xE_tinhlai,yE_tinhlai]=donghocthuan(q1,q2,q3);
  
  % Thiet lap vecto sai so quy dao
eX=xE-xE_tinhlai;
eY=yE-yE_tinhlai;
%% Ve do thi
% Do thi cac bien khop - ket qua bai toan dong hoc nguoc
figure(1)
    plot(t,q1,'r.',t,q2,'g.',t,q3,'b.')
    %ax1 = subplot(2,1,1);
    %plot(ax1,t,q1,'r.',t,q4,'y.',t,q5,'m.')
    %ax2 = subplot(2,1,2);
    %plot(ax2,t,q2,'g.',t,q3,'b.')
    xlabel('time (sec)')
    ylabel('Bien khop q1, q2, q3')
    hold on
    grid on
 % Do thi quy dao thao tac
 figure(2)
    plot(t,xE_tinhlai,'r.',t,yE_tinhlai,'g.')
    xlabel('time (sec)')
    ylabel('Do thi quy dao thao tac tinh lai (m)')
    hold on
    grid on
 % Do thi sai so quy dao thao tac
 figure(3)
    plot(t,eX,'r.',t,eY,'g.')
    xlabel('time (sec)')
    ylabel('Do thi sai so quy dao thao tac (m)')
    hold on
    grid on
%% Bieu dien co cau chuyen dong de kiem tra tinh chinh xac tu q1, q2, q3 tim duoc
 figure(4)
  P1=[0 0 0];
  viscircles([P1(3) P1(2)],0.005,'Color','r');
% Mo phong quy dao
%%%%%%%%%%%% den doan nay mk cha hieu j nua roi
curve=animatedline('Linewidth',1.5);
set(gca,'xlim',[-2 2],'Ylim',[-1 3],'Zlim',[-2 2]);
view(43,24);
xlabel('X(m)');
ylabel('Y(m)');
zlabel('Z(m)'); 
for t_q1=0:0.01:1
    x_khau_1=L1*cos(q1)*t_q1;
    y_khau_1=L1*sin(q1)*t_q1;
    z_khau_1=0;
    plot3(x_khau_1,y_khau_1,z_khau_1,'b.',L1*cos(q1),L1*sin(q1),0,'r.')
    grid on
    hold on
end
for t_q2=0:0.08:1
    x_khau_2=L2*cos(q1+q2)*t_q2+L1*cos(q1);
    y_khau_2=L2*sin(q1+q2)*t_q2+L1*sin(q1);
    z_khau_2=0;
    plot3(x_khau_2,y_khau_2,z_khau_2,'y.',L2*cos(q1+q2)+L1*cos(q1),L2*sin(q1+q2)+L1*sin(q1),0,'g.')
    hold on
    grid on
end
for t_q3=0:0.08:1
    x_khau_3=sin(q1+q2)*q3*t_q3+L2*cos(q1+q2)+L1*cos(q1);
    y_khau_3=-cos(q1+q2)*q3*t_q3+L2*sin(q1+q2)+L1*sin(q1);
    z_khau_3=0;
    plot3(x_khau_3,y_khau_3,z_khau_3,'r.',sin(q1+q2)*q3+L2*cos(q1+q2)+L1*cos(q1),-cos(q1+q2)*q3+L2*sin(q1+q2)+L1*sin(q1),0,'b.')
    hold on
    grid on
end

M(:,:) = getframe;
pause(0.05) 
hold on
grid on
end





































