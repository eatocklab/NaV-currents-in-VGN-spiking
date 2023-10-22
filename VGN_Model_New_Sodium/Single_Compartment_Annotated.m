%%% This script is the top level script for controlling the modeling
%%% environment.  Note that some loops are now no longer working but are
%%% left in place temporarily while the top level code is cleaned up for
%%% public sharing. Original code written by Ariel Hight and edited by RK (7/24/2018)
%%% Code modified for IH conductances by C.M. Ventura (2017-2018)
%%% Code further modified for persistent and resurgent Na currents by S. Baeza-Loya (2020-2023)

clear all
close all
tic


%Set some global variables
global a_k_rm b_k_rm c_k_rm n_k_rm m_na_rm h_na_rm n_htk_rm p_htk_rm w_ltk_rm z_ltk_rm r_h_rm
global gb_k_rm gb_na_rm gb_na_r_rm gb_na_p_rm gb_ltk_rm gb_htk_rm gb_h_rm gl gNa
global Ena El Ek Eh Esyn
global dt dur VV I_print Na_print plot_syn time spike_rate_array spike_count EPSC_shape Ih_shift Isyn plot_EPSC %(added Isyn on 3/9/2016)



%Set the timing variables
%% time and time steps
dur= 1000;                      % time duration (ms)
dt= 0.1; %                      % delta t (ms)
start= 900; %500                % time at onset of current clamp (ms)
c_duration= 500; %1500;         % length of current clamp (ms)
I_print=1;                      % Plot the individual ionic currents, on = 1, off = 0
Na_print = 0;                   % Plot individual Na current components; on = 1, off = 0
nt=1;                           % time step (current t = nt*dt)

% calculate start and stop #'s
start=start/dt;
stop=c_duration/dt+start;

%% Experimental Conditions (e.g. reversal potential, etc.)

% Intristic Membrane Properties
c=0.9;                          % Membrane capacitance (microF/cm^2)

% Ionic Battery Values
Ek= -80;                         %K battery (mV)
Ena=80;                         %Na battery (mV)
El=-65;                         %Leak battery (mV)
Eh=-46;                         %Ionic battery (mV)
Esyn=3;                         %Synaptic battery (mV)


%% Neuron Type
neuron_type= 1;              %1 = Sustained;   2 = Transient

        if neuron_type==1         % Sustained
            V(1) = -61.3; %          % ~Resting Potential (going to be variable, depending on composition of conductances)                  
            gb_k_rm=0;             %gK bar (mS/cm^2) 
            
            gb_na_rm = 20;                  %gNa bar for transient current (mS/cm^2) %used 13 mS/cm2 in Hight and Kalluri and the larger 20 mS/cm2 in Ventura and Kalluri                         
            gb_na_r_rm = gb_na_rm * .1;  %gNa bar for resurgent current 2 mS/cm2 (10%)(.1), set to 0 for no current 
            gb_na_p_rm = gb_na_rm * .02;  %gNa bar for persistent current 0.4 (2%) (0.02), set to 0 for no current                    
            
            gb_htk_rm = 2.8;                %gK bar (high threshold K) (mS/cm^2)        
            gb_ltk_rm = 0;                 %gK bar (low thfreshold K) (mS/cm^2)        
            gb_h_rm = 0.13;                 %gh bar (hyper-pol act. cation) (mS/cm^2)   
            gl = 0.03;                      %gLeak (mS/cm^2)
        elseif neuron_type== 2    % Transient
            V(1)= -65.7;                % ~Resting Potential 
            gb_k_rm=0;                      %gK bar (mS/cm^2)                           
            
            gb_na_rm= 14.6;                   %gNa bar (mS/cm^2), for transient current                         
            gb_na_r_rm= 0; %gb_na_rm * .1;    %gNa bar for resurgent current, set to 0 for no current 
            gb_na_p_rm= 0; %gb_na_rm * .02;   %ga bar for persistent current, set to 0 for no current                    
            
            gb_htk_rm= 2.8;                  %gK bar (high threshold K) (mS/cm^2)       
            gb_ltk_rm= 1.1;                  %gK bar (low threshold K) (mS/cm^2)        
            gb_h_rm = 0.13;
            gl=0.03;                         %gLeak (mS/cm^2)
        elseif neuron_type==3     %Sus-B or Sus-C parameters        
            V(1)=-64.1;      %Sus-C              % ~Resting Potential 
 %           V(1)=-63.5;        %Sus-B 
            gb_na_rm= 13;                  %gNa bar (mS/cm^2) sus-B = 16, sus-C = 13
            gb_na_r_rm = 0; %gb_na_rm * .1;    %gNa bar for resurgent current, set to 0 for no current 
            gb_na_p_rm = 0; %gb_na_rm * .02;   %gNa bar for persistent current, set to 0 for none 
            
            gb_k_rm= 0;                      %gK bar (mS/cm^2)                           
            gb_htk_rm= 2.8;                  %gK bar (high threshold K) (mS/cm^2)        
            gb_ltk_rm= .55;                %gK bar (low threshold K) (mS/cm^2), sus-B = 0.4, sus-C = 0.55
            gb_h_rm = 0.13;                 %gh bar (hyper-pol act. cation) (mS/cm^2)  
            gl=0.03;                        %gLeak (mS/cm^2)
        end        
        
%% EPSC_shape
EPSC_shape=2;               %1 = cochlear epsc(alpha = 0.4)     2 = vestibular epsc (a=1.8)      3 = alpha blunted % The shape is defined in generat_EPSC_train.m


%% Stimulation
epsc_amp_94=0;

% Conditions for Simulations ==> 
    % Trial: The type of cell and its respective conductances
    % CS: The stimulation conditions and desired responses   
    
trial = neuron_type; % appears to be redundant with neuron_type, edited by RK on 3/18/2013
Outputdata = struct;

cs = 2;
%% cs = 2 (CC voltage response, for step evoked currents); cs = 3 (EPSC II, for collecting II times); cs = 4(CC II)
%see lines 214 onwards for controlling the batch processing for
%step-evoked current-clamp simulations
if cs==2
    I= zeros(1,dur/dt); %plot_EPSC;            % Array representing current clamp
    I(start:stop)= 5;            % single long pulse, current clamp (x10 pA)(2.5, 6, 8, 15)
end
     %% EPSC_RESPONSE %%%
     if cs==3    %Calculating EPSC response
            % Batch for Intervent Interval Calculations
           b_switch=0;     % Batch on (change excitation variable) = 1; Batch on (change magnitude variable) = 2; Batch on (EPSC duration) = 3; Batch on (Dynamic Range Finder) = 4; Batch off = 0
%            mag_array= 10.^(-2:0.2:1); %10.^(-0.8:0.2:0.2);
%            excite_array=[15 20 30 40 50 60 70 80 90 100 120 140 180 200 220 240 15 20 30 40 50 60 70 80 90 100 120 140 180 200 220 240 15 20 30 40 50 60 70 80 90 100 120 140 180 200 220 240];
%            excite_array =[1000,500];
           excite_array = [0.07, 0.1198, 0.1899, 0.3, 0.47, 0.75, 1.198, 1.89, 3.01, 4.77, 7.56, 11.98, 18.99, 30.1, 47.71];
           time_array = dt:dt:dur;
           if b_switch==1 %titrate the epsc interval
                mag_mult=0.00251;
                b_length=length(excite_array);
                II_is=zeros(b_length,dur/2);    %Preallocation
                for batch=1:b_length
                    excitation=1000/excite_array(batch);                                          % mean EPSC intervent interval (ms)
                    rate_dispay=excite_array(batch);
                    temporary=EPSC_excitation_response(V(1),c,excitation,mag_mult);         %Iterspike Interval (ms)
                    II_is(batch,1:length(temporary))=temporary;
                    %Save Data
%                         save_trial_data(neuron_type,temporary,V,mag_mult,excitation)
%                         append_excel_data(temporary,neuron_type,excitation,mag_mult)
                    %Save Data
                end
                
           elseif b_switch==2 %titrate the EPSC magnitute, keep excitation rate fixed.
                excitation =3;
                b_length=length(mag_array);
                II_is=zeros(b_length,dur/2);
                for batch=1:b_length
                   mag_mult=mag_array(batch);
                    temporary=EPSC_excitation_response(V(1),c,excitation,mag_mult);         %Iterspike Interval (ms)
                    II_is(batch,1:length(temporary))=temporary;
                    
                    %Save Data
%                         save_trial_data(trial,temporary,V,mag_mult,excitation)
%                         append_excel_data(temporary,trial,excitation,mag_mult)
                    %Save Data
                end
                
           elseif b_switch==3
                excitation=.3;
                mag_mult= .1;
                b_length=length(mag_array);
                II_is=zeros(b_length,dur/2);
                for batch=1:b_length
%                     spike_dur=1*batch;
                    temporary=EPSC_excitation_response(V(1),c,excitation,mag_mult)*dt;         %Iterspike Interval (ms)
                    II_is(batch,1:length(temporary))=temporary;
                    
                    %Save Data
%                         save_trial_data(trial,temporary,V,mag_mult,excitation)
%                         append_excel_data(temporary,trial,excitation,mag_mult)
%                     %Save Data
                    
                end
                
           elseif b_switch==0
                excitation= 3;          % mean EPSC intervent interval (ms)
                mag_mult= .05; %0.01  0.05 	0.1	   0.3   0.5  0.7   1     1.2     
%                 spike_dur=0.4;         % this does not refer to the length of the EPSC spike, but rather represents the alpha value (e.g. alpha = 1.4 corresponds to spike duration of ~ 17.5 ms)
                II_is=EPSC_excitation_response(V(1),c,excitation,mag_mult)*dt;       %Iterspike Interval (ms)
                Outputdata.Vsave = VV;
                Outputdata.Syn_con = plot_syn;
                Outputdata.EPSCs = plot_EPSC;
                Outputdata.Time = time_array;
                Outputdata.II = II_is;
                %Save Data
%                     save_trial_data(trial,temporary,V,mag_mult,excitation)
%                     append_excel_data(temporary,trial,excitation,mag_mult)
                %Save Data
          
           elseif b_switch==4 % This code bit detects the boundaries of the response area.  Fig 9 in Hight and Kalluri 2018 was generated by repeated running this and saving data in an excel spreadsheet for subsequent plotting.
%                 spike_dur=0.4;
                array=boundary_detection_array(1);
                initial=[10 24];                % x (interval),y (mag) coordinate
                x_direction=1;                 % -1 == left, 1== right
                y_direction=1;                % -1 == bottom, 1== top
                direction=[x_direction y_direction];
                boundary_detection(array,initial,direction,V(1),c,trial);
                for n=1:length(array(1,:,1))
                    visual(:,length(array(1,:,1))-n+1)=spike_rate_array(:,n);
                    visual_spike_count(:,length(array(1,:,1))-n+1)=spike_count(:,n);
                    visual_array_epsc(:,length(array(1,:,1))-n+1)=array(:,n,1);
                    visual_array_mag(:,length(array(1,:,1))-n+1)=array(:,n,2);
                end
                for n=1:length(array(1,:,1))
                    for m=1:length(array(:,1,1))
                        if visual_spike_count(m,n)==0
                            visual_trimmed(m,n)=0;
                        elseif visual_spike_count(m,n) < 0
                            visual_trimmed(m,n)=visual_spike_count(m,n);
                        else
                            visual_trimmed(m,n)=visual(m,n);
                        end
                    end
                end
                visual=visual';
                visual_spike_count=visual_spike_count';
                visual_trimmed=visual_trimmed';
           end
           
           % added by SBL Aug 2020
%            Outputdata.Vsave(batch,:)= VV;
%            Outputdata.Syn(batch,:) = plot_syn;
%            Outputdata.Time(batch,:) = time_array; 
%            Outputdata.II(batch,:)= II_is;
     elseif cs == 4           
            II_cc=CC_response();
            V = V';  
            
            %%%HERE BEGINS CONTROLS FOR BATCH SIMULATIONS in SIMPLE CURRENT
            %%%CLAMP
          
            %% CC_RESPONSE; Mostly for step-evoked response %%%%
     elseif cs == 1 || cs == 2
            b_switch=0;             % b_switch = 1              Batch on (change current clamp mag.); 
                                    % b_switch = 2              Batch on (change specific conductance); 
                                    % b_switch = 0              Batch off, no Outputdata 
            plot_switch=2;          % plot_switch = 0           (independent plots); 
                                    % plot_switch = 1           (all on one plot, same figure); 
                                    % plot_switch = 2           (all on 1 figure, all subplots); 
                                    % plot_switch = 3           (no plots)
            v_rest_control=0;       % v_rest_control = 1        Control the resting potential using constant current
                                    % v_rest_control = 0        No control over resting potential
            threshold_switch=0;     % threshold_switch = 1   	Turn on code (detect the voltage and current threshold)
                                    % threshold_switch = 0      Turn off code (detecting the voltage and current threshold)
            save_switch=0;          % save_switch = 1           Save the responses & conditions of the stimulation
                                    % save switch = 0           don't save the responses
            
            % Batch for Current Clamp
            if b_switch==1 || b_switch==3
               cc_mag_array=[.5];      %[-10,-5,-2,-1,0,1,2,5,7,10];                     % CC magnitude array 1
               b_length=length(cc_mag_array); %for current clamp series
               gna_steps= ones(1,20)*20;
               gltk_steps= linspace(0.2,0.80,20); %titrating gltk
               gh_steps= ones(1,20)*0.91;
%                b_length=length(gna_steps); %for conductances series
               V=ones(b_length,dur/dt)*V(1);
               legend_value=ones(1,b_length);
               %gna_steps=[8 13 18 23 28];
               %gltk_steps=[0 0 0 0 0];
               ss=zeros(1,length(cc_mag_array));       % preallocating the Vhold array
               I_threshold=zeros(1,length(cc_mag_array));
               for batch=1:b_length
                    if b_switch==1
                        cc_mag=cc_mag_array(batch);
                        I(start:stop)=cc_mag;
                        legend_value(batch)=cc_mag;
                    elseif b_switch==2
                        cc_mag=5; %fixed array
%                         I(start:stop)=cc_mag;
                        % Select which conductance to chance (use ctl. R or
                        % T to toggle OFF or ON respectively)        
                         gb_na_rm=gna_steps(batch);
%                          gb_h_rm=gh_steps(batch);
%                          gb_htk_rm=batch*2.5-1.5;
                         gb_ltk_rm=gltk_steps(batch);
                         batch;
                    end
                    if v_rest_control==1
                        if threshold_switch==1
                            % Where Threshold code starts
                            dur=2000;
                            I(1:dur/dt)=cc_mag_array(batch);
                            start2=400;
                            cc_mag_array_2=0.54;                               % CC magnitude Array 2
                            v_threshold=zeros(length(cc_mag_array_2),5);    % preallocating array for recording V thresholds with respect to the dV/dt threshold (first column will be current used, i.e. cc magnitude array 2)
                            I_thres_record(1:4)=0;                          % preallocating array for recording I thresholds with respect to the dV/dt threshold
                            dvdt=zeros(1,length(350/dt:(dur-2)/dt));     % preallocating array for dV/dt array
                            d2vdt2=zeros(1,length(350/dt:(dur-2)/dt));   % preallocating array for d2V/dt2 array
                            v_phase=zeros(1,length(350/dt:(dur-2)/dt));  % preallocating the voltage array corresponding to the dV/dt and d2V/dt2 arrays
                            v_max=zeros(1,length(cc_mag_array_2)+1);        % preallocating the v_max array (+1 so that v_max(1) can always be zero in the case that the first stimulation generates an action potential)
                            v_max(1)=-999;
                            % Preallocating various arrays depending on the
                            % threshold detection (e.g. sustained v.
                            % transient
                            if trial==1
                                v_record=zeros(1,2);
                                v_threshold=zeros(length(cc_mag_array_2),3);
                            else
                                v_record=zeros(1,4);
                                v_theshold=zeros(length(cc_mag_array_2),5);
                                I_thres_record=zeros(1,4);
                            end
                            for batch_2=1:length(cc_mag_array_2)
                                cc_mag_2=cc_mag_array_2(batch_2);
                                I(start2/dt:dur/dt)=cc_mag+cc_mag_2;
                                [V,Ioutput]=single_compart_second_rm(V(1),I,c,cs,trial,epsc_amp_94);
                                ss(batch)=V(400/dt-1);
                                v_hold=ss(batch);
                                if trial==1
                                else
                                    v_record(1:length(v_record))=0;             % counter for recording the voltage (i.e. once the voltage threshold is recorded, the loop stops looking for the voltage threshold)
                                end
                                v_threshold(batch_2,1)=cc_mag_2*10;         % Current step used (for determining V_Threshold)
                                for rr=0:length(V(350/dt:(dur-2)/dt))
                                    dvdt(rr+1)=(-V(350/dt+2+(rr+1))+8*V(350/dt+1+(rr+1))-8*V(350/dt-1+(rr+1))+V(350/dt-2+(rr+1)))/(12*dt);
                                    d2vdt2(rr+1)=(-V(350/dt-2+(rr+1))+16*V(350/dt-1+(rr+1))-30*V(350/dt+(rr+1))+16*V(350/dt+1+(rr+1))-V(350/dt+2+(rr+1)))/(12*dt^2);
                                    v_phase(rr+1)=V(350/dt+rr);
                                    if trial == 1
%                                         if v_phase(rr+1) > -60 && v_phase(rr+1) < -50 && d2vdt2(rr+1) > 0 && v_record(1)==0
%                                             potential_v_threshold=v_phase(rr+1);
%                                             v_record(1)=1;
                                        if v_phase(rr+1) > -54 && v_phase(rr+1) < -50 && d2vdt2(rr+1) > 0 && v_record(2)==0
%                                             v_threshold(batch_2,2)=potential_v_threshold;
                                            v_threshold(batch_2,2)=v_phase(rr+1);
                                            v_threshold(batch_2,3)=v_max(batch_2);
                                            I_threshold(batch)=cc_mag_2*10;
                                            v_record(2)=1;
                                        end
                                    else
                                        if dvdt(rr+1) >= 7.5 && v_record(1)==0;
                                            v_threshold(batch_2,1+1)=v_phase(rr+1);   % V_Threshold(dv/dt=0.00075)
                                            v_record(1)=1;
                                        end
                                        if dvdt(rr+1) >= 7.5 && I_thres_record(1)==0;
                                            I_threshold(batch,1)=cc_mag_2*10;
                                            I_thres_record(1)=1;
                                        end
                                        if dvdt(rr+1) >= 10 && v_record(2)==0;
                                            v_threshold(batch_2,2+1)=v_phase(rr+1);   % V_Threshold(dv/dt=0.001)
                                            v_record(2)=1;
                                        end
                                        if dvdt(rr+1) >= 10 && I_thres_record(2)==0;
                                            I_threshold(batch,2)=cc_mag_2*10;
                                            I_thres_record(2)=1;
                                        end
                                        if dvdt(rr+1) >= 12.5 && v_record(3)==0;
                                            v_threshold(batch_2,3+1)=v_phase(rr+1);   % V_Threshold(dv/dt=0.00125)
                                            v_record(3)=1;
                                        end
                                        if dvdt(rr+1) >= 12.5 && I_thres_record(3)==0;
                                            I_threshold(batch,3)=cc_mag_2*10;
                                            I_thres_record(3)=1;
                                        end
                                        if dvdt(rr+1) >= 15 && v_record(4)==0;
                                            v_threshold(batch_2,4+1)=v_phase(rr+1);   % V_Threshold(dv/dt=0.0015)
                                            v_record(4)=1;
                                        end
                                        if dvdt(rr+1) >= 15 && I_thres_record(4)==0;
                                            I_threshold(batch,4)=cc_mag_2*10;
                                            I_thres_record(4)=1;
                                        end
                                    end
                                end
                                v_max(batch_2+1)=max(v_phase);
                                if plot_switch==0
                                elseif plot_switch==1
                                elseif plot_switch==2
                                else   plot_switch==3 %(No Plots)
                                end
                                if save_switch==1
                                    if trial ==1
                                        type='Sustained';
                                    else
                                        type='Transient';
                                    end
                                     saveas(gcf,['Threshold_' type '_Ihold_' num2str(floor((cc_mag*10))) '_' num2str(round(10*((cc_mag*10)-floor((cc_mag*10))-1/10*(10*(cc_mag*10)-floor(10*(cc_mag*10)))))) num2str(round(10*(10*(cc_mag*10)-floor(10*(cc_mag*10))-1/10*(100*(cc_mag*10)-floor(100*(cc_mag*10)))))) '_Iexcite_' num2str(floor((cc_mag_2*10))) '_' num2str(round(10*((cc_mag_2*10)-floor((cc_mag_2*10))-1/10*(10*(cc_mag_2*10)-floor(10*(cc_mag_2*10)))))) num2str(round(10*(10*(cc_mag_2*10)-floor(10*(cc_mag_2*10))-1/10*(100*(cc_mag_2*10)-floor(100*(cc_mag_2*10)))))) '_timestamp_' datestr(now,'HH_MM_ss_AM')])
                                else
                                end
                            end
                        else
                            I(1:dur/dt)=cc_mag_array(batch);
                            V=single_compart_second_rm(V(1),I,c,cs,trial,epsc_amp_94);
                            if plot_switch==0
                                figure(batch)
                                plot(dt:dt:dur,V)
                                xlabel('time (ms)')
                                ylabel('Vm (mV)')
                            elseif plot_switch==1
                            elseif plot_switch==2
                            else        % Plot_switch==3 (No Plot)
                            end
                            ylim([-80 80])
                            ss(batch)=V(400/dt-1);
                        end                        
                        
                    else
                        [V,Ioutput]=single_compart_second_rm(V(1),I,c,cs,trial,epsc_amp_94);
                        if plot_switch==0
                            figure(batch)
                            plot(dt:dt:dur,V)
                        elseif plot_switch==1
                        elseif plot_switch==2
                        else   plot_switch==3; %(No Plot)
                        end
                        ylim([-80 80])
                    end                 
                    
                    if plot_switch==0
                    elseif plot_switch==2
                        subplot(2,ceil(b_length/2),batch)
                        plot(dt:dt:dur,V)
                        ylim([-80 40])
                        ylabel('voltage (mV)')
                        xlabel('time (ms)')
                        title(['Response to Current Clamp Step at ',num2str(10*I(start)),' pA'])
                    elseif plot_switch==1
                        color_code=['r' 'y' 'g' 'c' 'm' 'b' 'k' 'k' 'k' 'k' 'k' 'k' 'k''k' 'k' 'k' 'k' 'k' 'k'];
                        %color_code=['b' 'r' 'g' 'g'];
                        figure(20)
                        plot(dt:dt:dur,V,[color_code(1) '-'],'Linewidth',2)
                        %plot(dt:dt:dur,V,[color_code(batch) '-'],'Linewidth',4)
                        %Add the Rm and Vrest here
                        Vrest(batch) = V(end);
                        Rm(batch) = (V(end)-V(40000))./abs(I(start).*10);
                        ylabel('voltage (mV)')
                        xlabel('time (ms)')
                        title('Response to Current Clamp Step')
                        hold on
                    end
                  
                    %% Create a structure with important parameters to easily output.
                    Outputdata.Vsave(batch,:)= V; %RK 5/14/2015
                    Outputdata.gNasave(batch,:)=gb_na_rm; %RK 8/29/2017
                    Outputdata.gKLsave(batch,:)=gb_ltk_rm; %RK 8/29/2017
                    Outputdata.gHsave(batch,:)=gb_h_rm; %RK 8/29/2017
                    Outputdata.cc_mag_save(batch,:)=cc_mag_array; %RK 8/29/2017
                    Outputdata.time = (0:length(V)-1)*dt;
                    Outputdata.Ioutput(batch)=Ioutput;
                    Outputdata.Ihshift(batch,:)=Ih_shift;
                end
                if b_length == 8 && plot_switch==2
                    legend([num2str(legend_value(1)*10),' pA'],[num2str(legend_value(2)*10),' pA'],[num2str(legend_value(3)*10),' pA'],[num2str(legend_value(4)*10),' pA'],[num2str(legend_value(5)*10),' pA'],[num2str(legend_value(6)*10),' pA'],[num2str(legend_value(7)*10),' pA'],[num2str(legend_value(8)*10),' pA'])
                end              
                hold off

%% b_switch==0
            else        
                [V, Ioutput]=single_compart_second_rm(V(1),I,c,cs,trial,epsc_amp_94);
                time_array = (dt:dt:dur);
                I_print = 1;
% Create a structure with important parameters to easily output.
                Outputdata.Vsave(1,:)= V; 
                Outputdata.Ioutput(1)=Ioutput;
% Plotting the responses
                figure(trial+cs)
                subplot(2,1,1)
                plot(dt:dt:dur,V)
                ylabel('voltage (mV)')
                xlabel('time (ms)')
                if trial==1 && cs==1
                    title('Sustained Neuron response to EPSP Spikes')
                    subplot(2,1,2)
                    plot(dt:dt:dur,epsc_amp_94(1:dur/dt)*10)
                    title('Synaptic Activity')
                    ylabel('Current (pA) at Voltage Clamp = 94 mV')
                    xlabel('time(ms)')
                elseif trial ==1 && cs==2
                    title(['Sustained Neuron response to Current Clamp step at ',num2str(10*I(start)),' pA'])
                    subplot(2,1,2)
                    plot(dt:dt:dur,I(1:dur/dt)*10)
                    title('Current Clamp')
                    ylabel('current (pA)')
                    xlabel('time(ms)')
                elseif trial ==2 && cs==1
                    title('Transient Neuron response to EPSP Spikes')
                    subplot(2,1,2)
                    plot(dt:dt:dur,epsc_amp_94(1:dur/dt)*10)
                    title('Synaptic Activity')
                    ylabel('Current (pA) at Voltage Clamp = 94 mV')
                    xlabel('time(ms)')
                elseif trial ==2 && cs==2
                    title(['Transient Neuron response to Current Clamp at ',num2str(10*I(start)),' pA'])
                    subplot(2,1,2)
                    plot(dt:dt:dur,I(1:dur/dt)*10)
                    title('Current Clamp')
                    ylabel('current (pA)')
                    xlabel('time(ms)')
                elseif trial ==3 && cs==2
                    title(['Type Custom Cell response to Current Clamp at ',num2str(10*I(start)),' pA'])
                    subplot(2,1,2)
                    plot(dt:dt:dur,I(1:dur/dt)*10)
                    title('Current Clamp')
                    ylabel('current (pA)')
                    xlabel('time(ms)')
                end
            end
     end

V = VV;
%Spikes_count_CV;
%    end    
%  end
toc

%% Save Code for CV
% cd('C:\Users\baeza\OneDrive\Desktop\Model_data\EPSCmag\Control'); % Change directory for where you wish to save
% filename=input('EnterFileName:','s');
% save(filename,'-struct','Outputdata'); %Output data structure is defined in lines near 463.
% 
