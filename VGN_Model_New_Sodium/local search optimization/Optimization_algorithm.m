%% optimize conductance parameters
global V_data neuron_type V inj_step_size

neuron_type = 2; % 1 = sustained-A, 2 = transient, 3 = susB, 4 = susC

if neuron_type == 1
    load V_data_susA;
    inj_step_size = 5;
elseif neuron_type == 2
    load V_data_tran;
    inj_step_size = 10;
elseif neuron_type == 3
    load V_data_susB;
    inj_step_size = 7.5;
elseif neuron_type == 4
    load V_data_susC;
    inj_step_size = 7.5;
end

tic

trials = 50;
best_error = Inf;
best_position = 0;
for i = 1:trials
    [current_position, current_error] = local_search;  
    if current_error < best_error
        best_error = current_error;
        best_position = current_position;
    end
end
disp(best_error);
disp(best_position);
single_compartment_simpleCC(best_position{:}, neuron_type, inj_step_size, 1);

toc

function[current_position, current_error] = local_search
%phys range for gNa bar for transient Na current (mS/cm^2)
gb_na_min = 5;
gb_na_max = 18;
gb_na_step = 0.5;
%gK bar (high threshold K) (mS/cm^2)
gb_htk_min = 0;
gb_htk_max = 4;
gb_htk_step = 0.1;
 %gK bar (low threshold K) (mS/cm^2)
gb_ltk_min = 0;
gb_ltk_max = 1.1;
gb_ltk_step = 0.05;
%gh bar (hyper-pol act. cation) (mS/cm^2)
gb_h_min = 0.07;
gb_h_max = 0.91;
gb_h_step = 0.02;
%gl bar (leak current) (mS/cm^2)
gb_l_min = 0;
gb_l_max = 0.1;
gb_l_step = 0.01;

gb_na = datasample(gb_na_min:gb_na_step:gb_na_max, 1);
gb_htk = datasample(gb_htk_min:gb_htk_step:gb_htk_max, 1);
gb_ltk = datasample(gb_ltk_min:gb_ltk_step:gb_ltk_max, 1);
gb_h = datasample(gb_h_min:gb_h_step:gb_h_max, 1);
gb_l = datasample(gb_l_min:gb_l_step:gb_l_max, 1);

% gb_na = 25;
% gb_htk = 3.9;
% gb_ltk = 0;
% gb_h = 0.13;
% gb_l = 0.03;

current_position = {gb_na, gb_htk, gb_ltk, gb_h, gb_l};
current_error = run_HH(current_position{:});
while 1
    gb_na = current_position{1};
    gb_htk = current_position{2};
    gb_ltk = current_position{3};
    gb_h = current_position{4};
    gb_l = current_position{5};
    
    fprintf("Current position");
    disp(current_position);
    fprintf("Current Error: %d\n\n", current_error); 
    best_error = current_error;
    best_position = current_position;
    neighbors = 0;
    if gb_na > gb_na_min
        neighbors = neighbors + 1;
        position = {gb_na - gb_na_step, gb_htk, gb_ltk, gb_h, gb_l};
        error = run_HH(position{:});
        if error < best_error
            best_error = error;
            best_position = position;
        end
    end
    if gb_na < gb_na_max
        neighbors = neighbors + 1;
        position = {gb_na + gb_na_step, gb_htk, gb_ltk, gb_h, gb_l};
        error = run_HH(position{:});
        if error < best_error
            best_error = error;
            best_position = position;
        end
    end
    if gb_htk > gb_htk_min
        neighbors = neighbors + 1;
        position = {gb_na, gb_htk - gb_htk_step, gb_ltk, gb_h, gb_l};
        error = run_HH(position{:});
        if error < best_error
            best_error = error;
            best_position = position;
        end
    end
    if gb_htk < gb_htk_max
        neighbors = neighbors + 1;
        position = {gb_na, gb_htk + gb_htk_step, gb_ltk, gb_h, gb_l};
        error = run_HH(position{:});
        if error < best_error
            best_error = error;
            best_position = position;
        end
    end
    if gb_ltk > gb_ltk_min
        neighbors = neighbors + 1;
        position = {gb_na, gb_htk, gb_ltk - gb_ltk_step, gb_h, gb_l};
        error = run_HH(position{:});
        if error < best_error
            best_error = error;
            best_position = position;
        end
    end
    if gb_ltk < gb_ltk_max
        neighbors = neighbors + 1;
        position = {gb_na, gb_htk, gb_ltk + gb_ltk_step, gb_h, gb_l};
        error = run_HH(position{:});
        if error < best_error
            best_error = error;
            best_position = position;
        end
    end
    if gb_h > gb_h_min
        neighbors = neighbors + 1;
        position = {gb_na, gb_htk, gb_ltk, gb_h - gb_h_step, gb_l};
        error = run_HH(position{:});
        if error < best_error
            best_error = error;
            best_position = position;
        end
    end
    if gb_h < gb_h_max
        neighbors = neighbors + 1;
        position = {gb_na, gb_htk, gb_ltk, gb_h + gb_h_step, gb_l};
        error = run_HH(position{:});
        if error < best_error
            best_error = error;
            best_position = position;
        end
    end
    if gb_l > gb_l_min
        neighbors = neighbors + 1;
        position = {gb_na, gb_htk, gb_ltk, gb_h, gb_l - gb_l_step};
        error = run_HH(position{:});
        fprintf("Neighbor: ")
        disp(position)
        fprintf("Error: %d\n", error)
        if error < best_error
            best_error = error;
            best_position = position;
        end
    end
    if gb_l < gb_l_max
        neighbors = neighbors + 1;
        position = {gb_na, gb_htk, gb_ltk, gb_h, gb_l + gb_l_step};
        error = run_HH(position{:});
        if error < best_error
            best_error = error;
            best_position = position;
        end
    end
    
    if best_error == current_error
        break;
    else
        current_error = best_error;
        current_position = best_position;
    end
end
% single_compartment_simpleCC(gb_na, gb_htk, gb_ltk, gb_h, gb_l, neuron_type, 1);
end 

function[error] = run_HH(gb_na, gb_htk, gb_ltk, gb_h, gb_l, neuron_type, inj_step_size)
global V_data neuron_type V inj_step_size
[V] = single_compartment_simpleCC(gb_na, gb_htk, gb_ltk, gb_h, gb_l, neuron_type, inj_step_size, 0);
error = mean((V_data - V).^2);
end

