%% Simulating voltage clamp of Na currents
%close all
%clear all
tic

%% Set parameters
% Set global variables
global mt ht mp mpinf hp br hr alphab kb gNaT gNaR gNaP ENa dt

gNaT = 20;      
gNaR = 0;       % 5-20% of gNaT (based on my estimations and Meredith and Rennie (2020) https://doi.org/10.1152/jn.00124.2020) 
gNaP = 0;       % 1-4% of gNaT 
ENa = 80;       % reversal potential

%blocking constants
alphab = 0.08;   % rate of unblocking, 0.08-0.1, from Venugopal, S, et al.(2019) https://doi.org/10.1371/journal.pcbi.1007154
kb = 0.9;       %0.8 - 1.2


%initialization 
mt(1) = 0; %INaT activation, 
ht(1) = 0; %INaT inactivation, 
mp(1) = 0; %INaP activation
hp(1) = 0; %INaP inactivation
br(1) = 0; %INaR activation
hr(1) = 0; %INaR inactivation

%% Pick your game

Protocol = 2;   % 1 = VC200 (transient)
                    % or 7 = VC200 for export
                % 2 = Voltage ramp (persistent)
                % 3 = Repolarizing steps after depolarization (resurgent)
                    % or 8 = Repol for export
                % 4 = Double short pulse, inactivation recovery
                    % 6 = Double short pulse, for export
                % 5 = Long pulse short pulse, entry into slow inactivation
method = 2;     % 1 = Solve using forward Euler
                % 2 = Solve using backward Euler (preferred)
Plot = 2;       % 1 = Single plot of total macro-current 
                % 2 = (1)Plot all current components individually, (2)IV, and (3)GV

%%
if Protocol == 1
    
    dt = 0.01;          %time step
    T = 7001;           %duration
    step = -150:5:60;   %voltage steps
    
    %preallocation
    [V, t, INa, INaT, INaP, INaR, mt, mtinf, ht, htinf, mpinf, mp, hp, br, hr]...
        = deal(zeros(1, T));    
    [MaxAct, MaxInact, GVAct, GVInact] = deal(zeros(1, length(step)));
    
    for j = 1:43    % length(step)
        for i = 1:7000
            t(i+1) = i*dt;
            
            V(i) = -70*(t(i)>=0)*(t(i)<=5)+...
                -80*(t(i)>5)*(t(i)<=10)+...
                -70*(t(i)>10)*(t(i)<=15)+...
                -150*(t(i)>15)*(t(i)<=22) +...
                step(j)*(t(i)>22)*(t(i)<=42) +...
                -10*(t(i)>42)*(t(i)<=62)+...
                -70*(t(i)>62)*(t(i)<70);
            if method == 1
                [INa(i), INaT(i), INaP(i), INaR(i)] = INa_rm(V(i));
            else
                [INa(i), INaT(i), INaP(i), INaR(i)] = INa_rm_BE(V(i));
            end
            
        end
        
        %find peak current for IV plots
        MaxAct(j) = min(INa(2000:3000));
        MaxInact(j) = min(INa(4000:5000));
        
        %calculate conductance for GV plots
        GVAct(j) = MaxAct(j)/(step(j)-ENa);
        GVInact(j) = MaxInact(j)/(-10-ENa);
        
        if Plot == 1
            figure(1)
            subplot(2,1,1)
            hold on
            plot(t,INa)
            ylabel('INaV (pA)','fontsize',11)
            xlim([0,70])
            subplot(2,1,2)
            hold on
            plot(t,V)
            ylabel('V (mv)','fontsize',11)
            xlim([0,70])
        
        else
            figure(1)
            subplot(5,1,1); hold on
            plot(t,INa); ylabel('INaV (pA)','fontsize',11); xlim([0,70])
            subplot(5,1,2); hold on
            plot(t,V); ylabel('V (mv)','fontsize',11); xlim([0,70])
            subplot(5,1,3); hold on
            plot(t,INaT); ylabel('INaT','fontsize',11); xlim([0,70])
            subplot(5,1,4); hold on
            plot(t,INaP); ylabel('INaP','fontsize',11); xlim([0,70])
            subplot(5,1,5); hold on
            plot(t,INaR);xlabel('t   (ms)','fontsize',11); ylabel('INaR','fontsize',11); xlim([0,70])
        end
    end 
    figure(2)
    hold on
    plot(step,MaxAct,step,MaxInact)
    figure(3)
    hold on
    plot(step, GVAct, step, GVInact)
end
%%
if Protocol == 7
    
    dt = 0.01;          %time step
    T = 7001;           %duration
    step = -150:5:60;   %voltage steps
    
    %preallocation
    [V, t, INa, INaT, INaP, INaR, mt, mtinf, ht, htinf, mp, mpinf, hp, br, hr]...
        = deal(zeros(1, T));
    
    for j = 1:43
        for i = 1:7000
            t(j,i+1) = i*dt;
            
            V(j,i) = -70*(t(j,i)>=0)*(t(j,i)<=5)+...
                -80*(t(j,i)>5)*(t(j,i)<=10)+...
                -70*(t(j,i)>10)*(t(j,i)<=15)+...
                -150*(t(j,i)>15)*(t(j,i)<=22) +...
                step(j)*(t(j,i)>22)*(t(j,i)<=42) +...
                -10*(t(j,i)>42)*(t(j,i)<=62)+...
                -70*(t(j,i)>62)*(t(j,i)<=70);
            
            if method == 1
                [INa(j,i), INaT(j,i), INaP(j,i), INaR(j,i)] = INa_rm(V(j,i));
            else
                [INa(j,i), INaT(j,i), INaP(j,i), INaR(j,i)] = INa_rm_BE(V(j,i));
            end
            
        end
    end
end
%% Protocol : Persistent (voltage ramp, 0.1mV/ms)

if Protocol == 2
    
    load('Vramp.mat');
    dt = 1;
    T = 159999;
    
    [INa, INaT, INaP, INaR, t, mt, ht, mp, hp, br, hr]...
        = deal(zeros(1, T));
    
    for i = 1:159999
        t(i) = i*dt;
        if method == 1
            [INa(i), INaT(i), INaP(i), INaR(i)] = INa_rm(Vramp(i));
        else
            [INa(i), INaT(i), INaP(i), INaR(i)] = INa_rm_BE(Vramp(i));
        end
    end
    figure(1)
    subplot(2,1,1)
    hold on
    plot(t,INaP)
    ylabel('INaV (pA)','fontsize',11)
    xlim([0,16*10^4])
    ylim([-100,0])
    subplot(2,1,2)
    hold on
    plot(t,Vramp)
    ylabel('V (mv)','fontsize',11)
    xlim([0,16*10^4])
end

%% Protocol : Resurgent (repolarizatizing steps after initial depolarization)

if Protocol == 3
    
    dt = 0.01;          %time step
    T = 24501;          %duration
    step = -80:10:-10;  %voltage steps
    
    %preallocation
    [V, t, INa, INaT, INaP, INaR, mt, mtinf, ht, htinf, mpinf, mp, hp, br, hr]...
        = deal(zeros(1, T));
    [MaxNaVR] = deal(zeros(1, length(step)));
    
    for j = 1:8    % length(step)
        for i = 1:24500
            t(i+1) = i*dt;
            
            V(i) = -70*(t(i)>=0)*(t(i)<=15)+...
            -130*(t(i)>15)*(t(i)<=25) +...
            30*(t(i)>25)*(t(i)<=30)+...
            step(j)*(t(i)>30)*(t(i)<=230) +...
            -70*(t(i)>230)*(t(i)<=245);
            
            if method == 1
                [INa(i), INaT(i), INaP(i), INaR(i)] = INa_rm(V(i));
            else
                [INa(i), INaT(i), INaP(i), INaR(i)] = INa_rm_BE(V(i));
            end
        end
       
        %find peak current for IV plots
        MaxNaVR(j) = min(INaR(3000:7000));
        
            figure(1)
            subplot(2,1,1)
            hold on
            plot(t,INa)
            ylabel('INaV (pA)','fontsize',11)
            xlim([0,245])
            subplot(2,1,2)
            hold on
            plot(t,V)
            ylabel('V (mv)','fontsize',11)
            xlim([0,245])
        %     subplot(5,1,3)
        %     hold on
        %     plot(t,INaT)
        %     ylabel('INaT','fontsize',11)
        %     xlim([0,245])
        %     subplot(5,1,4)
        %     hold on
        %     plot(t,INaP)
        %     ylabel('INaP','fontsize',11)
        %     xlim([0,245])
        %     subplot(5,1,5)
        %     hold on
        %     plot(t,INaR)
        %     xlabel('t   (ms)','fontsize',11); ylabel('INaR','fontsize',11)
        %     xlim([0,245])
    end
figure(2)
hold on
plot(step,MaxNaVR)
    
end
%% Protocol : Resurgent (repolarizatizing steps after initial depolarization)for EXPORT

if Protocol == 8
    
    dt = 0.01;          %time step
    T = 24501;          %duration
    step = -80:10:-10;  %voltage steps
    
    %preallocation
    [V, t, INa, INaT, INaP, INaR, mt, mtinf, ht, htinf, mpinf, mp, hp, br, hr]...
        = deal(zeros(1, T));
    
    for j = 1:8    % length(step)
        for i = 1:24500
            t(j,i+1) = i*dt;
            
            V(j,i) = -70*(t(j,i)>=0)*(t(j,i)<=15)+...
                -130*(t(j,i)>15)*(t(j,i)<=25) +...
                30*(t(j,i)>25)*(t(j,i)<=30)+...
                step(j)*(t(j,i)>30)*(t(j,i)<=230) +...
                -70*(t(j,i)>230)*(t(j,i)<=245);
            
            if method == 1
                [INa(j,i), INaT(j,i), INaP(j,i), INaR(j,i)] = INa_rm(V(j,i));
            else
                [INa(j,i), INaT(j,i), INaP(j,i), INaR(j,i)] = INa_rm_BE(V(j,i));
            end
        end
    end
end
%% Protocol : Double short pulse, recovery from inactivation
if Protocol == 4
    
    dt = 0.01;          %time step
    T = 10001;           %duration
    deltat = 16:2:68;   %voltage steps
    
    %preallocation
    [V, t, INa, INaT, INaP, INaR, mt, mtinf, ht, htinf, mpinf, mp, hp, br, hr]...
        = deal(zeros(1, T));    
    [Peak1, Peak2, availability] = deal(zeros(1, length(deltat)));
    
    for j = 1:27   % length(step)
        for i = 1:10000
            t(i+1) = i*dt;
            V(i) = -80*(t(i)>=0)*(t(i)<=10)+...
                0*(t(i)>10)*(t(i)<=15)+...
                -80*(t(i)>15)*(t(i)<= deltat(j))+...
                0*(t(i)>deltat(j))*(t(i)<=(deltat(j)+5)) +...
                -80*(t(i)>(deltat(j)+5))*(t(i)<=100);
            if method == 1
                [INa(i), INaT(i), INaP(i), INaR(i)] = INa_rm(V(i));
            else
                [INa(i), INaT(i), INaP(i), INaR(i)] = INa_rm_BE(V(i));
            end
            
        end
        
        %find peak current for IV plots
        Peak1(j) = min(INa(1000:1500));
        Peak2(j) = min(INa(1600:7000));
        availability(j) = Peak2/Peak1;
       
        figure(1)
        subplot(2,1,1)
        hold on
        plot(t,INa)
        ylabel('INaV (pA)','fontsize',11)
        % xlim([0,70])
        subplot(2,1,2)
        hold on
        plot(t,V)
        ylabel('V (mv)','fontsize',11)
        % xlim([0,70])

    end 
    
    figure(2)
    hold on
    plot(deltat,availability,'o')
end
%% Protocol : Double short pulse, for export
if Protocol == 6
    
    dt = 0.01;          %time step
    T = 10001;           %duration
    deltat = 16:1:45;   %voltage steps
    
    %preallocation
    
    [V, t, INa, INaT, INaP, INaR, mt, ht, mpinf, mp, hp, br, hr]...
    = deal(zeros(length(deltat), T));

    mt(1,:) = 0; ht(1,:) = 0; mpinf(1,:) = 0; hp(1,:) = 0; br(1,:) = 0; hr(1,:) = 0; 
%     [Peak1, Peak2, availability] = deal(zeros(1, length(deltat)));
    
    for j = 1:30   % length(step)
        for i = 1:10000
            t(j,i+1) = i*dt;
            V(j,i) = -80*(t(j,i)>=0)*(t(j,i)<=10)+...
                0*(t(j,i)>10)*(t(j,i)<=15)+...
                -80*(t(j,i)>15)*(t(j,i)<= deltat(j))+...
                0*(t(j,i)>deltat(j))*(t(j,i)<=(deltat(j)+5)) +...
                -80*(t(j,i)>(deltat(j)+5))*(t(j,i)<=100);
            if method == 1
                [INa(j,i), INaT(j,i), INaP(j,i), INaR(j,i)] = INa_rm(V(j,i));
            else
                [INa(j,i), INaT(j,i), INaP(j,i), INaR(j,i)] = INa_rm_BE(V(j,i));
            end 
        end
    end 
end
%% Protocol: Double pulse long - entry into slow inactivation
if Protocol == 5
    
    dt = 0.01;          %time step
    T = 100001;           %duration
    deltat = 15:40:800;   %voltage steps
    
    %preallocation
    [V, t, INa, INaT, INaP, INaR, mt, mtinf, ht, htinf, mpinf, mp, hp, br, hr]...
        = deal(zeros(1, T));    
    [Peak1, Peak2, availability] = deal(zeros(1, length(deltat)));
    
    for j = 1:20   % length(step)
        for i = 1:100000
            t(i+1) = i*dt;
            V(i) = -80*(t(i)>=0)*(t(i)<=10)+...
                0*(t(i)>10)*(t(i)<= deltat(j))+...
                -80*(t(i)> deltat(j))*(t(i)<= (deltat(j)+75) )+...
                0*(t(i)>(deltat(j)+75) )*(t(i)<= (deltat(j)+80) ) +...
                -80*(t(i)> (deltat(j)+80))*(t(i)<= 1000);
            
            if method == 1
                [INa(i), INaT(i), INaP(i), INaR(i)] = INa_rm(V(i));
            else
                [INa(i), INaT(i), INaP(i), INaR(i)] = INa_rm_BE(V(i));
            end
            
        end
        
        %find peak current for IV plots
        Peak1(j) = min(INa(500:1500));
        Peak2(j) = min(INa(8500:100000));
        availability(j) = Peak2/Peak1;
       
figure(1)
subplot(2,1,1)
hold on
plot(t,INa)
ylabel('INaV (pA)','fontsize',11)
% xlim([0,70])
subplot(2,1,2)
hold on
plot(t,V)
ylabel('V (mv)','fontsize',11)
% xlim([0,70])

    end 
    
    figure(2)
    hold on
    plot(deltat,availability)
end

toc