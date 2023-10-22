function boundary_detection(array,initial,direction,V,c,trial)

global Ena El Ek Eh Esyn
global gb_k_rm gb_na_rm gb_ltk_rm gb_htk_rm gb_h_rm gl
global dur time VV spike_rate_array spike_count plot_syn


x=initial(1);
x_d=direction(1);
y=initial(2);
y_d=0;              % always start going in x_direction
count=direction(2);
run=1;
[s_x s_y zz]=size(array);
spike_rate_array=zeros([s_x s_y]);
spike_count=zeros([s_x s_y]);
s=1;

if direction(1)==-1
for n=1:(s_x*s_y)
    if run==1;
        if x_d~=0
            x=x+(x_d*1);
        elseif y_d~=0
            y=y+(y_d*1*s);
        end
        
        path(n,1)=x;
        path(n,2)=y;
        
        if x==0 || y==0 || x > s_x || y > s_y
            run=0;
            break
        end
        excitation=1000/array(x,y,1);
        mag_mult=array(x,y,2);
        temporary=EPSC_excitation_response(V(1),c,excitation,mag_mult);       %Iterspike Interval (ms)+
        spike_count(x,y)=length(temporary)+1;
        spike_rate_array(x,y)=1000/mean(temporary);
        if spike_count(x,y) < dur/(1000/spike_rate_array(x,y))-5 || spike_count(x,y) < dur/(1000/20)-5 || spike_rate_array(x,y) < 20
            spike_count(x,y)=0;
        end
    
        % SAVE CODE
            cd(['C:\Users\baeza\OneDrive\Desktop\Model_data\Boundary_detection\' datestr(now,'yy') '_' datestr(now,'mm') '\' datestr(now,'yy') '_' datestr(now,'mm') '_' datestr(now,'dd') '\'])%M:\Physiology of the Inner Ear\EHight\Modeling\Results\
            if trial ==1
                type='Sustained';
            else
                type='Transient';
            end
            save(['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_excite_' num2str(floor(excitation)) '_' num2str(round(10*(excitation-floor(excitation)-1/10*(10*excitation-floor(10*excitation))))) num2str(round(10*(10*excitation-floor(10*excitation)-1/10*(100*excitation-floor(100*excitation))))) '_timestamp_' datestr(now,'HH_MM_AM')], 'VV', 'V', 'plot_syn', 'gb_k_rm', 'gb_na_rm', 'gb_htk_rm', 'gb_ltk_rm', 'gb_h_rm', 'gl','dur','temporary','mag_mult','time','excitation','Ek','Ena') 
            saveas(gcf,['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_excite_' num2str(floor(excitation)) '_' num2str(round(10*(excitation-floor(excitation)-1/10*(10*excitation-floor(10*excitation))))) num2str(round(10*(10*excitation-floor(10*excitation)-1/10*(100*excitation-floor(100*excitation))))) '_tstamp_' datestr(now,'HH_MM_AM')]) 
            
            cd('C:\Users\baeza\OneDrive\Desktop\VGN_Model_Sodium\')
        % SAVE CODE
        
        if x_d ~= 0
            if spike_rate_array(x,y) > 20 && spike_count(x,y) > dur/(1000/20)-5
                if x+direction(1)==0 || x+direction(1)==s_x+1
                    y_d=direction(2);
                    x_d=0;
                else
                    x_d=direction(1);
                    count=1;
                end
            else
                x=x-direction(1);
                x_d=0;
                y_d=direction(2);
            end
        else
            if spike_count(x,y) < dur/(1000/20)-5
                if s==-1
                    run=0;
                    break
                end
                s=-1;
                y=y-count;
                y_d=direction(2);
                count=1;
            elseif spike_rate_array(x,y) > 20 && spike_count(x,y) > dur/(1000/20)-5
                if y_d*s == -1
                    if spike_rate_array(x,y+1) > spike_rate_array(x,y)
%                         zzz=4
                            y_d=0;
                            x_d=direction(1);
                            y_d=0;
                            count=count+1*y_d;
                            s=1;
                    elseif spike_rate_array(x,y+1) > spike_rate_array(x,y) || spike_count(x,y) < dur/(1000/20)-5
                        if s==-1
                            run=0;
                            break
                        end
%                         zzz=5
                        s=-1;
                        x_d=0;
                        y_d=direction(2);
                        y=y-count;
                        count=1;
                    end
                elseif y_d*s==1
                    if spike_rate_array(x,y-1) < spike_rate_array(x,y)
%                         zzz=6
                        x_d=direction(1);
                        y_d=0;
                        count=count+1*y_d;
                        s=1;
                    elseif spike_rate_array(x,y-1) > spike_rate_array(x,y) || spike_count(x,y) < dur/(1000/20)-5
                        if s==-1
                            run=0;
                            break
                        end
%                         zzz=7
                        s=-1;
                        x_d=0;
                        y_d=direction(2);
                        y=y-count;
                        count=1;
                    end
                end
            end
        end
    else
        break
    end
end
end

% if direction(1)==1
%     
% % % % % % % % % % % % % % % % % % % % % % %     excitation=1000/array(x+1,y,1);
% % % % % % % % % % % % % % % % % % % % % % %     mag_mult=array(x+1,y,2);
% % % % % % % % % % % % % % % % % % % % % % %     temporary=EPSC_excitation_response(V(1),c,excitation,mag_mult);       %Iterspike Interval (ms)+
% % % % % % % % % % % % % % % % % % % % % % %     spike_count=length(temporary)+1;
% % % % % % % % % % % % % % % % % % % % % % %     spike_rate_array(x+1,y)=1000/mean(temporary);
% % % % % % % % % % % % % % % % % % % % % % %                 
% % % % % % % % % % % % % % % % % % % % % % %     % SAVE CODE
% % % % % % % % % % % % % % % % % % % % % % %         cd(['C:\Users\Ariel\Desktop\House\Modeling\Results\' datestr(now,'yy') '_' datestr(now,'mm') '\' datestr(now,'yy') '_' datestr(now,'mm') '_' datestr(now,'dd') '\'])
% % % % % % % % % % % % % % % % % % % % % % %         if trial ==1
% % % % % % % % % % % % % % % % % % % % % % %             type='Sustained';
% % % % % % % % % % % % % % % % % % % % % % %         else
% % % % % % % % % % % % % % % % % % % % % % %             type='Transient';
% % % % % % % % % % % % % % % % % % % % % % %         end
% % % % % % % % % % % % % % % % % % % % % % %         save(['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_timestamp_' datestr(now,'HH_MM_AM')], 'VV', 'V', 'plot_syn', 'gb_k_rm', 'gb_na_rm', 'gb_htk_rm', 'gb_ltk_rm', 'gb_h_rm', 'gl','dur','temporary','mag_mult','time','excitation') 
% % % % % % % % % % % % % % % % % % % % % % %         saveas(gcf,['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_tstamp_' datestr(now,'HH_MM_AM')]) 
% % % % % % % % % % % % % % % % % % % % % % %     % SAVE CODE
% % % % % % % % % % % % % % % % % % % % % % %     
% % % % % % % % % % % % % % % % % % % % % % %     excitation=1000/array(x+1,y+1,1);
% % % % % % % % % % % % % % % % % % % % % % %     mag_mult=array(x+1,y,2);
% % % % % % % % % % % % % % % % % % % % % % %     temporary=EPSC_excitation_response(V(1),c,excitation,mag_mult);       %Iterspike Interval (ms)+
% % % % % % % % % % % % % % % % % % % % % % %     spike_count=length(temporary)+1;
% % % % % % % % % % % % % % % % % % % % % % %     spike_rate_array(x+1,y)=1000/mean(temporary);
% % % % % % % % % % % % % % % % % % % % % % %                 
% % % % % % % % % % % % % % % % % % % % % % %     % SAVE CODE
% % % % % % % % % % % % % % % % % % % % % % %         cd(['C:\Users\Ariel\Desktop\House\Modeling\Results\' datestr(now,'yy') '_' datestr(now,'mm') '\' datestr(now,'yy') '_' datestr(now,'mm') '_' datestr(now,'dd') '\'])
% % % % % % % % % % % % % % % % % % % % % % %         if trial ==1
% % % % % % % % % % % % % % % % % % % % % % %             type='Sustained';
% % % % % % % % % % % % % % % % % % % % % % %         else
% % % % % % % % % % % % % % % % % % % % % % %             type='Transient';
% % % % % % % % % % % % % % % % % % % % % % %         end
% % % % % % % % % % % % % % % % % % % % % % %         save(['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_timestamp_' datestr(now,'HH_MM_AM')], 'VV', 'V', 'plot_syn', 'gb_k_rm', 'gb_na_rm', 'gb_htk_rm', 'gb_ltk_rm', 'gb_h_rm', 'gl','dur','temporary','mag_mult','time','excitation') 
% % % % % % % % % % % % % % % % % % % % % % %         saveas(gcf,['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_tstamp_' datestr(now,'HH_MM_AM')]) 
% % % % % % % % % % % % % % % % % % % % % % %     % SAVE CODE
% % % % % % % % % % % % % % % % % % % % % % %     
%     
%     for n=1:(s_x*s_y)
%         if run==1;
%             if x_d~=0
%                 x=x+(x_d);
%             elseif y_d~=0
%                 y=y+(y_d);
%             end
%             
%             path(n,1)=x;
%             path(n,2)=y;
% 
%             if x_d==1 && y+1 > s_y || y-1 == 0 || x > s_x
%                 run=0;
%                 break       
%             elseif y_d~=0 && y-1==0
%                 run=0;
%                 break
%             end
%             
%             if x_d==1
%                 excitation=1000/array(x,y,1);
%                 mag_mult=array(x,y,2);
%                 temporary=EPSC_excitation_response(V(1),c,excitation,mag_mult);       %Iterspike Interval (ms)+
%                 spike_count(x,y)=length(temporary)+1;
%                 spike_rate_array(x,y)=1000/mean(temporary);
%                 if spike_count(x,y) < dur/(1000/spike_rate_array(x,y))-5
%                     spike_count(x,y)=-1;
%                 end
%                 
%                 % SAVE CODE
%                     cd(['C:\Users\Ariel\Desktop\House\Modeling\Results\' datestr(now,'yy') '_' datestr(now,'mm') '\' datestr(now,'yy') '_' datestr(now,'mm') '_' datestr(now,'dd') '\'])
%                     if trial ==1
%                         type='Sustained';
%                     else
%                         type='Transient';
%                     end
%                     save(['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_timestamp_' datestr(now,'HH_MM_AM')], 'VV', 'V', 'plot_syn', 'gb_k_rm', 'gb_na_rm', 'gb_htk_rm', 'gb_ltk_rm', 'gb_h_rm', 'gl','dur','temporary','mag_mult','time','excitation') 
%                     saveas(gcf,['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_tstamp_' datestr(now,'HH_MM_AM')]) 
%                 % SAVE CODE
%                 
%                 excitation=1000/array(x,y+1,1);
%                 mag_mult=array(x,y+1,2);
%                 temporary=EPSC_excitation_response(V(1),c,excitation,mag_mult);       %Iterspike Interval (ms)+
%                 spike_count(x,y+1)=length(temporary)+1;
%                 if spike_count(x,y+1) < dur/(1000/20)-5
%                     spike_count(x,y+1)=-1;
%                 end
%                 spike_rate_array(x,y+1)=1000/mean(temporary);
%                 
%                 % SAVE CODE
%                     cd(['C:\Users\Ariel\Desktop\House\Modeling\Results\' datestr(now,'yy') '_' datestr(now,'mm') '\' datestr(now,'yy') '_' datestr(now,'mm') '_' datestr(now,'dd') '\'])
%                     if trial ==1
%                         type='Sustained';
%                     else
%                         type='Transient';
%                     end
%                     save(['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_timestamp_' datestr(now,'HH_MM_AM')], 'VV', 'V', 'plot_syn', 'gb_k_rm', 'gb_na_rm', 'gb_htk_rm', 'gb_ltk_rm', 'gb_h_rm', 'gl','dur','temporary','mag_mult','time','excitation') 
%                     saveas(gcf,['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_tstamp_' datestr(now,'HH_MM_AM')]) 
%                 % SAVE CODE
%                 
%                 excitation=1000/array(x,y-1,1);
%                 mag_mult=array(x,y-1,2);
%                 temporary=EPSC_excitation_response(V(1),c,excitation,mag_mult);       %Iterspike Interval (ms)+
%                 spike_count(x,y-1)=length(temporary)+1;
%                 if spike_count(x,y-1) < dur/(1000/20)-5
%                     spike_count(x,y-1)=-1;
%                 end
%                 spike_rate_array(x,y-1)=1000/mean(temporary);
%                 
%                 % SAVE CODE
%                     cd(['C:\Users\Ariel\Desktop\House\Modeling\Results\' datestr(now,'yy') '_' datestr(now,'mm') '\' datestr(now,'yy') '_' datestr(now,'mm') '_' datestr(now,'dd') '\'])
%                     if trial ==1
%                         type='Sustained';
%                     else
%                         type='Transient';
%                     end
%                     save(['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_timestamp_' datestr(now,'HH_MM_AM')], 'VV', 'V', 'plot_syn', 'gb_k_rm', 'gb_na_rm', 'gb_htk_rm', 'gb_ltk_rm', 'gb_h_rm', 'gl','dur','temporary','mag_mult','time','excitation') 
%                     saveas(gcf,['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_tstamp_' datestr(now,'HH_MM_AM')]) 
%                 % SAVE CODE
%                 
%             else
%                 excitation=1000/array(x,y+y_d,1);
%                 mag_mult=array(x,y+y_d,2);
%                 temporary=EPSC_excitation_response(V(1),c,excitation,mag_mult);       %Iterspike Interval (ms)+
%                 spike_count(x,y+y_d)=length(temporary)+1;
%                 if spike_count(x,y+y_d) < dur/(1000/20)-5
%                     spike_count(x,y+y_d)=-1;
%                 end
%                 spike_rate_array(x,y+y_d)=1000/mean(temporary);
%                 
%                 % SAVE CODE
%                     cd(['C:\Users\Ariel\Desktop\House\Modeling\Results\' datestr(now,'yy') '_' datestr(now,'mm') '\' datestr(now,'yy') '_' datestr(now,'mm') '_' datestr(now,'dd') '\'])
%                     if trial ==1
%                         type='Sustained';
%                     else
%                         type='Transient';
%                     end
%                     save(['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_timestamp_' datestr(now,'HH_MM_AM')], 'VV', 'V', 'plot_syn', 'gb_k_rm', 'gb_na_rm', 'gb_htk_rm', 'gb_ltk_rm', 'gb_h_rm', 'gl','dur','temporary','mag_mult','time','excitation') 
%                     saveas(gcf,['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_tstamp_' datestr(now,'HH_MM_AM')]) 
%                 % SAVE CODE
%             end 
%             
%             if spike_count(x,y) > spike_count(x,y+1) && spike_count(x,y) > spike_count(x,y-1)
%                 x_d=direction(1);
%                 y_d=0;
%             else
%                 y_d=direction(2);
%                 x_d=0;
%             end
%         end
%     end
% end

if direction(1)==1
    for n=1:(s_x*s_y)
        if run==1;
            if x_d~=0
                x=x+(x_d);
            elseif y_d~=0
                y=y+(y_d);
            end
            
            path(n,1)=x;
            path(n,2)=y;

            if x_d==1 && y+1 > s_y || y-1 == 0 || x+1 > s_x || array (x+1,y,1)==0
                run=0;
                break       
            elseif y_d~=0 && y-1==0 || array(x,y,1)==0;
                run=0;
                break
            end
            
            
            if spike_count(x,y) == 0
                excitation=1000/array(x,y,1);
                mag_mult=array(x,y,2);
                temporary=EPSC_excitation_response(V(1),c,excitation,mag_mult);       %Iterspike Interval (ms)+
                spike_count(x,y)=length(temporary)+1;
                spike_rate_array(x,y)=1000/mean(temporary);
                if spike_count(x,y) < dur/(1000/spike_rate_array(x,y))-5 || spike_count(x,y) < dur/(1000/20)-5 || spike_rate_array(x,y) < 20
                    spike_count(x,y)=-1;
                end
                
                % SAVE CODE
                    cd(['C:\Users\baeza\OneDrive\Desktop\Model_data\Boundary_detection\' datestr(now,'yy') '_' datestr(now,'mm') '\' datestr(now,'yy') '_' datestr(now,'mm') '_' datestr(now,'dd') '\'])
                    if trial ==1
                        type='Sustained';
                    else
                        type='Transient';
                    end
                    save(['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_excite_' num2str(floor(excitation)) '_' num2str(round(10*(excitation-floor(excitation)-1/10*(10*excitation-floor(10*excitation))))) num2str(round(10*(10*excitation-floor(10*excitation)-1/10*(100*excitation-floor(100*excitation))))) '_timestamp_' datestr(now,'HH_MM_AM')], 'VV', 'V', 'plot_syn', 'gb_k_rm', 'gb_na_rm', 'gb_htk_rm', 'gb_ltk_rm', 'gb_h_rm', 'gl','dur','temporary','mag_mult','time','excitation','Ek','Ena') 
                    saveas(gcf,['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_excite_' num2str(floor(excitation)) '_' num2str(round(10*(excitation-floor(excitation)-1/10*(10*excitation-floor(10*excitation))))) num2str(round(10*(10*excitation-floor(10*excitation)-1/10*(100*excitation-floor(100*excitation))))) '_tstamp_' datestr(now,'HH_MM_AM')]) 
                    cd('C:\Users\baeza\OneDrive\Desktop\VGN_Model_Sodium\')
                % SAVE CODE
            end
                    
            if spike_count(x+1,y) == 0
                excitation=1000/array(x+1,y,1);
                mag_mult=array(x+1,y,2);
                temporary=EPSC_excitation_response(V(1),c,excitation,mag_mult);       %Iterspike Interval (ms)+
                spike_count(x+1,y)=length(temporary)+1;
                spike_rate_array(x+1,y)=1000/mean(temporary);
                if spike_count(x+1,y) < dur/(1000/spike_rate_array(x+1,y))-5 || spike_count(x+1,y) < dur/(1000/20)-5 || spike_rate_array(x+1,y) < 20
                    spike_count(x+1,y)=-1;
                end
            
                % SAVE CODE
                    cd(['C:\Users\baeza\OneDrive\Desktop\Model_data\Boundary_detection\' datestr(now,'yy') '_' datestr(now,'mm') '\' datestr(now,'yy') '_' datestr(now,'mm') '_' datestr(now,'dd') '\'])
                    if trial ==1
                        type='Sustained';
                    else
                        type='Transient';
                    end
                    save(['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_excite_' num2str(floor(excitation)) '_' num2str(round(10*(excitation-floor(excitation)-1/10*(10*excitation-floor(10*excitation))))) num2str(round(10*(10*excitation-floor(10*excitation)-1/10*(100*excitation-floor(100*excitation))))) '_timestamp_' datestr(now,'HH_MM_AM')], 'VV', 'V', 'plot_syn', 'gb_k_rm', 'gb_na_rm', 'gb_htk_rm', 'gb_ltk_rm', 'gb_h_rm', 'gl','dur','temporary','mag_mult','time','excitation','Ek','Ena') 
                    saveas(gcf,['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_excite_' num2str(floor(excitation)) '_' num2str(round(10*(excitation-floor(excitation)-1/10*(10*excitation-floor(10*excitation))))) num2str(round(10*(10*excitation-floor(10*excitation)-1/10*(100*excitation-floor(100*excitation))))) '_tstamp_' datestr(now,'HH_MM_AM')]) 
                    cd('C:\Users\baeza\OneDrive\Desktop\VGN_Model_Sodium\')
                % SAVE CODE
            end
                
            if spike_count(x-1,y) == 0
                excitation=1000/array(x-1,y,1);
                mag_mult=array(x-1,y,2);
                temporary=EPSC_excitation_response(V(1),c,excitation,mag_mult);       %Iterspike Interval (ms)+
                spike_count(x-1,y)=length(temporary)+1;
                spike_rate_array(x-1,y)=1000/mean(temporary);
                if spike_count(x-1,y) < dur/(1000/spike_rate_array(x-1,y))-5 || spike_count(x-1,y) < dur/(1000/20)-5 || spike_rate_array(x-1,y) < 20
                    spike_count(x-1,y)=-1;
                end
            
                % SAVE CODE
                    cd(['C:\Users\baeza\OneDrive\Desktop\Model_data\Boundary_detection\' datestr(now,'yy') '_' datestr(now,'mm') '\' datestr(now,'yy') '_' datestr(now,'mm') '_' datestr(now,'dd') '\'])
                    if trial ==1
                        type='Sustained';
                    else
                        type='Transient';
                    end
                    save(['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_excite_' num2str(floor(excitation)) '_' num2str(round(10*(excitation-floor(excitation)-1/10*(10*excitation-floor(10*excitation))))) num2str(round(10*(10*excitation-floor(10*excitation)-1/10*(100*excitation-floor(100*excitation))))) '_timestamp_' datestr(now,'HH_MM_AM')], 'VV', 'V', 'plot_syn', 'gb_k_rm', 'gb_na_rm', 'gb_htk_rm', 'gb_ltk_rm', 'gb_h_rm', 'gl','dur','temporary','mag_mult','time','excitation','Ek','Ena') 
                    saveas(gcf,['EPSCresponse_' type '_mag_' num2str(floor(mag_mult)) '_' num2str(round(10*(mag_mult-floor(mag_mult)-1/10*(10*mag_mult-floor(10*mag_mult))))) num2str(round(10*(10*mag_mult-floor(10*mag_mult)-1/10*(100*mag_mult-floor(100*mag_mult))))) '_excite_' num2str(floor(excitation)) '_' num2str(round(10*(excitation-floor(excitation)-1/10*(10*excitation-floor(10*excitation))))) num2str(round(10*(10*excitation-floor(10*excitation)-1/10*(100*excitation-floor(100*excitation))))) '_tstamp_' datestr(now,'HH_MM_AM')]) 
                    cd('C:\Users\baeza\OneDrive\Desktop\VGN_Model_Sodium\')
                % SAVE CODE
            end
                
            if spike_count(x,y) > spike_count(x-1,y) && spike_count(x,y) >= spike_count(x+1,y) 
                y_d=direction(2);
                x_d=0;
            elseif spike_rate_array(x,y) <=0
                y_d=direction(2);
                x_d=0;
            elseif spike_rate_array(x,y) > spike_rate_array(x+1,y) 
                y_d=direction(2);
                x_d=0;
            else
                x_d=direction(1);
                y_d=0; 
            end
        end
    end
end

% '_excite_' num2str(floor(excitation)) '_' num2str(round(10*(excitation-floor(excitation)-1/10*(10*excitation-floor(10*excitation))))) num2str(round(10*(10*excitation-floor(10*excitation)-1/10*(100*excitation-floor(100*excitation)))))
                    