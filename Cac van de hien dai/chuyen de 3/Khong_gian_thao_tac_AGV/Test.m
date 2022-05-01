clc
clear
%% Parameters
[L1,L2,L3,R,h]=bien();
%% Vi tri ban dau cua diem thao tac E
xx_0=0.7;yy_0=1.67;zz_0=0;
X_0=[xx_0;yy_0;zz_0];% Vec to vi tri E
% Gia tri gan dung cua goc khop ban dau, su dung auto cad de xac dinh
% q1_0=pi/3;q2_0=pi/6;q3_0=0.2;
q1_0=1.0532;q2_0=0.5224;q3_0=0.2090;
%% Tinh chinh xac gia tri goc khop ban dau q_0
for n=1:1:10^10
    Jnd_0=Jacobian(q1_0,q2_0,q3_0); % Tinh ma tran Jacobian theo q_0
    [xE_0,yE_0,zE_0]=donghocthuan(q1_0,q2_0,q3_0);% tinh lai xx_0, yy_0 theo q_0
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
q1=q1_0
q2=q2_0
q3=q3_0