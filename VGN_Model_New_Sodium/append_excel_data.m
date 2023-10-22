function status=append_excel_data(II_is,trial,excitation,mag_mult)

global gb_na_rm gb_ltk_rm gb_htk_rm gb_h_rm gl
global Ena El Ek Eh time dt dur spike_dur EPSC_shape

spike_dur=0.4;     % spike dur is not used in function anymore (6/16/12) but is included in this code and excel worksheet
if EPSC_shape==1
    if trial==1
        sheet='sustained';
    elseif trial==2
        sheet='transient';
    end
elseif EPSC_shape==2
    if trial==1
        sheet='sustained_EPSC_shape_II';
    elseif trial==2
        sheet='transient_EPSC_shape_II';
    end
elseif EPSC_shape==3
    if trial==1
        sheet='sustained_EPSC_shape_III';
    elseif trial==2
        sheet='transient_EPSC_shape_III';
    end
end
    
source_path='C:\Users\baeza\OneDrive\Desktop\\Modeling\Results\EPSCsims\';
source_file_name='II_is_data_master_MC.xlsx';

filename=[source_path,source_file_name];
fid=fopen(filename,'r');

e_data=xlsread(filename,sheet,'B2:MZZ100');

status=fclose(fid);

new_line=[Ek Ena El Eh gb_na_rm gb_htk_rm gb_ltk_rm gb_h_rm gl mag_mult excitation 1000/excitation spike_dur dt dur time mean(II_is) std(II_is) std(II_is)/mean(II_is) 1000/mean(II_is) length(II_is) II_is];

max=length(e_data(:,1));
max_II=length(e_data(1,:));

yes=0;
for m=1:max
    if yes==1
        break
    end
    if Ek < e_data(m,1)
        % Push existing data down one row and insert new data
        e_data(m+1:max+1,1:max_II)=e_data(m:max,1:max_II);
        e_data(m,1:max_II)=NaN;
        e_data(m,1:length(new_line))=new_line;
        yes=1;
    elseif Ek==e_data(m,1)
        for n=m:max
            if yes==1
                break
            elseif Ek~= e_data(n,1)
                break
            else
                if Ena < e_data(n,2)
                    % Push existing data down one row and insert new data
                    e_data(n+1:max+1,1:max_II)=e_data(n:max,1:max_II);
                    e_data(n,1:max_II)=NaN;
                    e_data(n,1:length(new_line))=new_line;
                    yes=1;
                elseif Ena==e_data(n,2)
                    for o=n:max
                        if yes==1
                            break
                        elseif Ena~= e_data(o,2)
                            break
                        else
                            if gb_na_rm < e_data(o,5)
                                % Push existing data down one row and
                                % insert new data
                                e_data(o+1:max+1,1:max_II)=e_data(o:max,1:max_II);
                                e_data(o,1:max_II)=NaN;
                                e_data(o,1:length(new_line))=new_line;
                                yes=1;
                            elseif gb_na_rm == e_data(o,5)
                                for p=o:max
                                    if yes==1
                                        break
                                    elseif gb_na_rm ~= e_data(p,5)
                                        break
                                    else
                                        if gb_htk_rm < e_data(p,6)
                                            % Push existing data down one row and insert new data
                                            e_data(p+1:max+1,1:max_II)=e_data(p:max,1:max_II);
                                            e_data(p,1:max_II)=NaN;
                                            e_data(p,1:length(new_line))=new_line;
                                            yes=1;
                                        elseif gb_htk_rm == e_data(p,6)
                                            for q=p:max
                                                if yes==1
                                                    break
                                                elseif gb_htk_rm ~= e_data(q,6)
                                                    break
                                                else
                                                    if gb_ltk_rm < e_data(q,7)
                                                        % Push existing data down one row and insert new data
                                                        e_data(q+1:max+1,1:max_II)=e_data(q:max,1:max_II);
                                                        e_data(q,1:max_II)=NaN;
                                                        e_data(q,1:length(new_line))=new_line;
                                                        yes=1;
                                                    elseif gb_ltk_rm == e_data(q,7)
                                                        for r=q:max
                                                            if yes==1
                                                                break
                                                            elseif gb_ltk_rm ~= e_data(r,7)
                                                                break
                                                            else
                                                                if mag_mult < e_data(r,10)
                                                                    % Push existing data down one row and insert new data
                                                                    e_data(r+1:max+1,1:max_II)=e_data(r:max,1:max_II);
                                                                    e_data(r,1:max_II)=NaN;
                                                                    e_data(r,1:length(new_line))=new_line;
                                                                    yes=1;
                                                                elseif mag_mult == e_data(r,10)
                                                                    for s=r:max
                                                                        if yes==1
                                                                            break
                                                                        elseif mag_mult ~= e_data(s,10)
                                                                            break
                                                                        else
                                                                            if excitation < e_data(s,11)
                                                                                % Push existing data down one row and insert new data
                                                                                e_data(s+1:max+1,1:max_II)=e_data(s:max,1:max_II);
                                                                                e_data(s,1:max_II)=NaN;
                                                                                e_data(s,1:length(new_line))=new_line;
                                                                                yes=1;
                                                                            elseif excitation == e_data(s,11)
                                                                                for t=s:max
                                                                                    if yes==1
                                                                                        break
                                                                                    elseif excitation~=e_data(t,11)
                                                                                        break
                                                                                    elseif spike_dur < e_data(t,13)
                                                                                        % Push existing data down one row and insert new data
                                                                                        e_data(t+1:max+1,1:max_II)=e_data(t:max,1:max_II);
                                                                                        e_data(t,1:max_II)=NaN;
                                                                                        e_data(t,1:length(new_line))=new_line;
                                                                                        yes=1;
                                                                                    elseif spike_dur == e_data(t,13)
                                                                                        
                                                                                        % Append new data!
                                                                                        for zz=21:max_II;
                                                                                            if e_data(s,zz) > 0
                                                                                                if zz==max_II
                                                                                                    e_data(s,zz+1:zz+length(II_is))=II_is;
                                                                                                    point=zz+1;
                                                                                                    break
                                                                                                end
                                                                                            else
                                                                                                e_data(s,zz:zz+length(II_is)-1)=II_is;
                                                                                                point=zz;
                                                                                                break
                                                                                            end
                                                                                        end
                                                                                        e_data(s,15)=e_data(s,15)+dur;
                                                                                        e_data(s,16)=e_data(s,16)+time;
                                                                                        e_data(s,17)=mean([e_data(s,22:point-1) II_is]);
                                                                                        e_data(s,18)=std([e_data(s,22:point-1) II_is]);
                                                                                        e_data(s,19)=e_data(s,18)/e_data(s,17);
                                                                                        e_data(s,20)=1000/e_data(s,17);
                                                                                        e_data(s,21)=e_data(s,21)+length(II_is);
                                                                                        yes=1;
                                                                                
                                                                                    elseif t == max
                                                                                        e_data(t+1,1:length(new_line))=new_line;
                                                                                        e_data(t+1,length(new_line)+1:max_II)=NaN;
                                                                                        yes=1;
                                                                                    end
                                                                                end
                                                                            elseif s == max
                                                                              % Insert new row of data after existing data
                                                                              e_data(s+1,1:length(new_line))=new_line;
                                                                              e_data(s+1,length(new_line)+1:max_II)=NaN;
                                                                              yes=1;
                                                                            end
                                                                        end
                                                                    end
                                                                elseif r == max
                                                                    % Insert new row of data after existing data
                                                                    e_data(r+1,1:length(new_line))=new_line;
                                                                    e_data(r+1,length(new_line)+1:max_II)=NaN;
                                                                    yes=1;
                                                                end
                                                            end
                                                        end
                                                    elseif q == max
                                                        % Insert new row of
                                                        % data after existing data
                                                        e_data(q+1,1:length(new_line))=new_line;
                                                        e_data(q+1,length(new_line)+1:max_II)=NaN;
                                                        yes=1;
                                                    end
                                                end
                                            end
                                        elseif p == max
                                            % insert new row of data after
                                            % existing data
                                            e_data(p+1,1:length(new_line))=new_line;
                                            e_data(p+1,length(new_line)+1:max_II)=NaN;
                                            yes=1;
                                        end
                                    end
                                end
                            elseif o == max
                                % insert new row of data after existing
                                % data
                                e_data(o+1,1:length(new_line))=new_line;
                                e_data(o+1,length(new_line)+1:max_II)=NaN;
                                yes=1;
                            end
                        end
                    end
                elseif n==max
                    % insert new row of data after existing data
                    e_data(n+1,1:length(new_line))=new_line;
                    e_data(n+1,length(new_line)+1:max_II)=NaN;
                    yes=1;
                end
            end
        end
    elseif m==max
        % insert new row of data after existing data
        e_data(m+1,1:length(new_line))=new_line;
        e_data(m+1,length(new_line)+1:max_II)=NaN;
        yes=1;
    end
end

xlswrite(filename, e_data, sheet,'B2')

                                                                                
