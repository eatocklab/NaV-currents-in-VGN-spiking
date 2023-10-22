function [V]=single_compartment_simpleCC(gb_na, gb_htk, gb_ltk, gb_h, gb_l, neuron_type, inj_step_size, plot_me)
% tic
%Set some global variables
global a_k_rm b_k_rm c_k_rm n_k_rm m_na_rm h_na_rm n_htk_rm p_htk_rm w_ltk_rm z_ltk_rm r_h_rm
global gb_k_rm gb_na_rm gb_na_r_rm gb_na_p_rm gb_ltk_rm gb_htk_rm gb_h_rm gl
global Ena El Ek Eh Esyn
global dt dur I_print V_data 



%% time and time steps
%Set the timing variables
%% time and time steps
dur= 12; % %1000; %2500; %1100;                       % time duration (ms)
dt= 0.012; %.0143;                        % delta t (ms)
start= .9; %300; %500                      % time at onset of current clamp (ms)
c_duration= 12; %1500;                % length of current clamp (ms)
I_print=1;                      % Plot the individual ionic currents

nt=1; 

% calculate start and stop #'s
start=start/dt;
stop=c_duration/dt+start;

I=zeros(1,dur/dt);           % Array representing current clamp
I(start:stop)= inj_step_size;
%% Experimental Conditions (e.g. reversal potential, etc.)

% Intristic Membrane Properties
c=0.9;                          % Membrane capacitance (microF/cm^2)

% Ionic Battery Values
Ek= -80;                        %K battery (mV)
Ena=80;                         %Na battery (mV)
El=-65;                         %Leak battery (mV)
Eh=-46;                         %Ionic battery (mV)
Esyn=3;                         %Synaptic battery (mV)


%% Neuron Type
if neuron_type==1         % Sustained
    V(1)=-58.76916;      %SBL              % ~Resting Potential
elseif neuron_type== 2    % Transient
    V(1)=-69.43264;                  % ~Resting Potential
elseif neuron_type==3     %Sus-B cell parameters
    V(1)=-60.97;                    % ~Resting Potential (going to be variable, depending on composition of conductances
elseif neuron_type==4     %Sus-C cell parameters
    V(1)=-60.97;                    % ~Resting Potential (going to be variable, depending on composition of conductances)
end

gb_na_rm = gb_na;                  %gNa bar for transient current (mS/cm^2) %used 13 mS/cm2 in Hight and Kalluri and the larger 20 mS/cm2 in Ventura and Kalluri
gb_na_r_rm =  0;% gb_na_rm * .1;       %gNa bar for resurgent current, set to 0 for no current
gb_na_p_rm =  0;% gb_na_rm * .025;     %gNa bar for persistent current, set to 0 for no current

gb_htk_rm = gb_htk;                 %gK bar (high threshold K) (mS/cm^2)
gb_ltk_rm = gb_ltk;                  %gK bar (low threshold K) (mS/cm^2)
gb_h_rm = gb_h;                  %gh bar (hyper-pol act. cation) (mS/cm^2)
gl=gb_l;                        %gLeak (mS/cm^2)

%%
V=single_compart_second_rm_simpleCC(V(1),I,c);
time_array = (dt:dt:dur);
Outputdata.Vsave = V;
Outputdata.time = (0:length(V)-1)*dt;
Outputdata.InjCurrent = I;
% Plotting the responses
if plot_me
    figure(neuron_type)
    subplot(2,1,1)
    plot(dt:dt:dur,V);hold on
    plot(dt:dt:dur,V_data,'bl--');hold off
    ylabel('voltage (mV)')
    xlabel('time (ms)')
    if neuron_type ==1
        title(['Sustained Neuron response to Current Clamp step at ',num2str(10*I(start)),' pA'])
        subplot(2,1,2)
        plot(dt:dt:dur,I(1:dur/dt)*10)
        title('Current Clamp')
        ylabel('current (pA)')
        xlabel('time(ms)')
    elseif neuron_type ==2
        title(['Transient Neuron response to Current Clamp at ',num2str(10*I(start)),' pA'])
        subplot(2,1,2)
        plot(dt:dt:dur,I(1:dur/dt)*10)
        title('Current Clamp')
        ylabel('current (pA)')
        xlabel('time(ms)')
    elseif neuron_type ==3
        title(['Sustained B Neuron response to Current Clamp at ',num2str(10*I(start)),' pA'])
        subplot(2,1,2)
        plot(dt:dt:dur,I(1:dur/dt)*10)
        title('Current Clamp')
        ylabel('current (pA)')
        xlabel('time(ms)')
    elseif neuron_type ==4
        title(['Sustained C Neuron response to Current Clamp at ',num2str(10*I(start)),' pA'])
        subplot(2,1,2)
        plot(dt:dt:dur,I(1:dur/dt)*10)
        title('Current Clamp')
        ylabel('current (pA)')
        xlabel('time(ms)')
    end
end
% toc
end

