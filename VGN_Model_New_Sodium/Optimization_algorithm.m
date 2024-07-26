%% optimize conductance parameters
global dVdt dVdt_data V_data V neuron_type inj_step_size

neuron_type = 3; % 1 = sustained-A, 2 = transient, 3 = susB, 4 = susC

if neuron_type == 1
    dVdt_data = importdata("dVdt_data_susA.mat");
    V_data = importdata("V_data_susA.mat");
    inj_step_size = 10;
elseif neuron_type == 2
    dVdt_data = importdata("dVdt_data_tran.mat");
    V_data = importdata("V_data_tran.mat");
    inj_step_size = 12;
elseif neuron_type == 3
    dVdt_data = importdata("dVdt_data_susB.mat");
    V_data = importdata("V_data_susB.mat");
    inj_step_size = 12;
elseif neuron_type == 4
    dVdt_data = importdata("dVdt_data_susC.mat");
    V_data = importdata("V_data_susC.mat");
    inj_step_size = 12;
end

tic

trials = 1;
best_error = Inf;
best_position = 0;
for i = 1:trials
    [current_position, current_error] = local_search;  
    if current_error < best_error
        best_error = current_error;
        best_position = current_position;
    end
end
%disp(best_error);
%disp(best_position);
single_compartment_simpleCC(best_position{:}, neuron_type, inj_step_size, 1);

toc

function[current_position, current_error] = local_search
%phys range for gNa bar for Na current (mS/cm^2)
gb_na_min = 10;
gb_na_max = 16;
gb_na_step = 1;
%gK bar (high threshold K) (mS/cm^2)
gb_htk_min = 0;
gb_htk_max = 4;
gb_htk_step = 0.5;
 %gK bar (low threshold K) (mS/cm^2)
gb_ltk_min = 0;
gb_ltk_max = 1.1;
gb_ltk_step = 0.1;
%gh bar (hyper-pol act. cation) (mS/cm^2)
gb_h_min = 0.07;
gb_h_max = 0.91;
gb_h_step = 0.05;
%gl bar (leak current) (mS/cm^2)
gb_l_min = 0;
gb_l_max = 0.1;
gb_l_step = 0.02;

% Seed data
% random seed
% gb_na = datasample(gb_na_min:gb_na_step:gb_na_max, 1);
% gb_htk = datasample(gb_htk_min:gb_htk_step:gb_htk_max, 1);
% gb_ltk = datasample(gb_ltk_min:gb_ltk_step:gb_ltk_max, 1);
% gb_h = datasample(gb_h_min:gb_h_step:gb_h_max, 1);
% gb_l = datasample(gb_l_min:gb_l_step:gb_l_max, 1);

% specific seed
gb_na = 13;
gb_htk = 4;
gb_ltk = 0.45;
gb_h = 0.5;
gb_l = 0.1;

current_position = {gb_na, gb_htk, gb_ltk, gb_h, gb_l};
current_error = run_HH(current_position{:});
while 1
    gb_na = current_position{1};
    gb_htk = current_position{2};
    gb_ltk = current_position{3};
    gb_h = current_position{4};
    gb_l = current_position{5};
    
    %fprintf("Current position");
    disp(current_position);
    %fprintf("Current Error: %d\n\n", current_error); 
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
        %fprintf("Neighbor: ")
        disp(position)
        %fprintf("Error: %d\n", error)
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
global dVdt_data neuron_type V inj_step_size
[dVdt, V] = single_compartment_simpleCC(gb_na, gb_htk, gb_ltk, gb_h, gb_l, neuron_type, inj_step_size, 0);
error = mean((dVdt_data - dVdt).^2);
end

