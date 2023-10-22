function [i t]=inf_tau_r_rm(V)

%  i=(1+exp((V+85)/8))^(-1);%  %Note that V1/2 in Hight and Kalluri was
%  more negative at -100 mV rather than at -85 mV as used by Rothman and
%  Manis, 2003.  For this VGN model we titrate between -100 mV and -85 mV
%  to represent the modulation of IH by cAMP concentration.
%  t=10^5*(237*exp((V+60)/12)+17*exp(-(V+60)/14))^(-1)+25; % Based on Hight
%  and Kalluri, 2016 which was based on Rothman and Manis, 2003

 global Ih_shift    %1=min actitvation (100uM condition) 2= 25%-activation 3=50%-activation 4=58%-activation 5=66%-activation 6=75%-activation 7= max activation (db-cAMP condition)
        Ih_shift = 7; % This parameter selects the activation condition as shown above.
 
   if Ih_shift==1 %min activation is based on fitting on data presented in Ventura and Kalluri (xx), Figure 3 at 100 micro-molar 
     i=(1+exp((V+96.11)/8.1))^(-1);
     a = 86.86183;
     b = 5.76769;
     c = 3393.34171;
     d = 6.67393;
     e = 295.95798;
     t = ((1/c)*1./(exp(-(V+a)./b)) + (exp((V+a)./d)))+e;  
    
     elseif Ih_shift==2 %25%-activation.  The V1/2 and tau fits are interpolated between the 100 uM and 500 uM conditions.
        i=(1+exp((V+91.67525)/8.2))^(-1);
        a = 85.3077;
        b = 6.34179;
        c = 3183.003;
        d = 8.72304;
        e = 274.3381;
        t = ((1/c)*1./(exp(-(V+a)./b)) + (exp((V+a)./d)))+e;
     
    elseif Ih_shift==3 %Based on half-way between the two fits 50%-activation.  Interpolation as above
        i=(1+exp((V+89.2405)/8.3))^(-1);
        a = 83.75372;
        b = 6.34179;
        c = 2972.664705;
        d = 10.77215;
        e = 252.71829;
        t = (1/c)*1./(exp(-(V+a)./b) + exp((V+a)./d))+e;
 
    elseif Ih_shift==4  %58% activation
       i=(1+exp((V+88.428416)/8.35))^(-1);
       a = 83.23572;
       b = 6.437473;
       c = 2902.551813;
       d = 11.456875;
       e = 246.67834;
       t = (1/c)*1./(exp(-(V+a)./b) + exp((V+a)./d))+e;
        
    elseif Ih_shift==5  %66.6% activation
       i=(1+exp((V+87.6163)/8.40))^(-1);
       a = 82.71772;
       b = 6.533156;
       c = 2832.43892;
       d = 12.1416;
       e = 240.63839;
       t = (1/c)*1./(exp(-(V+a)./b) + exp((V+a)./d))+e;
           
    elseif Ih_shift==6  % 75%-activation
       i=(1+exp((V+86.80425)/8.45))^(-1);
       a = 82.19972;
       b = 6.62884;
       c = 2762.32603;
       d = 12.826325;
       e = 234.598445;
       t = (1/c)*1./(exp(-(V+a)./b) + exp((V+a)./d))+e;
    
    elseif Ih_shift==7  %max activation is based on fitting data in Ventura and Kalluri (xx), Figure 3 at 500 micro-molar  DB-cAMP  
       i=(1+exp((V+84.368)/8.6))^(-1);
       a = 80.64572;
       b = 6.91589;
       c = 2551.9877;
       d = 14.8805;
       e = 209.4786;
       t = ((1/c)*(1./(exp(-(V+a)./b)) + (exp((V+a)./d))))+e;
       
    end  
end