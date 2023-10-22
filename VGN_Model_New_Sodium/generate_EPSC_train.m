function final_EPSC_train=generate_EPSC_train(EPSC_length,excitation)

global dur dt EPSC_shape


if EPSC_shape~=4
    EPSC_train=zeros(1,ceil(dur/dt+2*EPSC_length));
else
    EPSC_train=zeros(1,ceil(dur/dt));
end

count=1;
t=1;
cdf_ii=II_cumulative_distribution_function(excitation);
cdf_a=A_cumulative_distribution_function;

% Calculating initial II and Amplitude
r=round(rand(1)*1000);
rr=round(rand(1)*(1000-(min(cdf_a))))+min(cdf_a);
ii=find(cdf_ii==r);
if ii > 0
else
    for n=1:length(cdf_ii)
        if r < cdf_ii(n)
            ii=n;
            break
        end
    end
end
dt_a=0.01;
a=find(cdf_a==rr)*dt_a;
II=ii(1);
A=a(1);
%

EPSC_train(t)=A;
count=II;

if EPSC_shape~=4
    lll=dur/dt+EPSC_length;
else
    lll=dur/dt;
end

while t+count < lll  
    % Calculating initial II and Amplitude
    r=round(rand(1)*1000);
    rr=round(rand(1)*(1000-(min(cdf_a))))+min(cdf_a);
    ii=find(cdf_ii==r);
    if ii > 0
    else
        for n=1:length(cdf_ii)
            if r < cdf_ii(n)
                ii=n;
                break
            end
        end
    end
    a=find(cdf_a==rr)*dt_a;
    II=ii(1);
    A=a(1);
    %
    
    t=t+count;
    EPSC_train(t)=A;
    count=II;
end

if EPSC_shape==1
    waveform=alpha_func(1);
elseif EPSC_shape==2
    waveform=alpha_func_elongated(1);
elseif EPSC_shape==3
    waveform=alpha_func_blunted(1);
else
    waveform=1;
end

if EPSC_shape~=0
    EPSC_train=conv(EPSC_train,waveform);
    final_EPSC_train=EPSC_train(EPSC_length:length(EPSC_train));
else
    final_EPSC_train=EPSC_train;
end