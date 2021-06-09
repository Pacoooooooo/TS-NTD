function [result] = MTMF(history_data, rank, opts)
%MTMF Multi-Trans matrix factorization
%   此处显示详细说明

% -------------------------------------------------------------------------
% Parameters Setting
if isfield(opts,'beta') beta = opts.beta; else beta = 1; end               % 控制 稀疏，并没有用到
if isfield(opts,'lambda') lambda = opts.lambda; else lambda = 1; end       % 控制 与单位阵的差别
if isfield(opts,'maxiter') maxiter = opts.maxiter; else maxiter = 1e3; end
if isfield(opts,'epsilon') epsilon = opts.epsilon; else epsilon = 1e-4; end

[n_user, n_item, n_time] = size(history_data);

% -------------------------------------------------------------------------
% Initialization
U_t = cell(n_time, 1);
V_t = cell(n_time, 1);
B_t = cell(n_time-1, 1);
C_t = cell(n_time-1, 1);
U_t{n_time} = rand(n_user, rank);
V_t{n_time} = rand(rank, n_item);
for i = 1:n_time-1
    [U_t{i}, V_t{i}] = nnmf(history_data(:,:,i), rank);
    B_t{i} = eye(rank);
    C_t{i} = eye(rank);
end

% ----------------------------------------------------------------
% Algorithm Loop
C_t0 = C_t;
B_t0 = B_t;
U_t0 = U_t;
V_t0 = V_t;
R = history_data;
REL_ERR = zeros(maxiter,1);
for iter = 1:maxiter
    if mod(iter, round(maxiter/10)) == 0	
        fprintf('[Info][MTMF]Iter: %4d Step Relative Error: %.4f .\n', iter, REL_ERR(iter-1)); 
    end
    % =========== Update U_t{n_time} ==========
    U_t{n_time} = U_t{n_time} .* (  R(:,:,n_time) * V_t{n_time}' ./ ...
                                  (U_t{n_time} * V_t{n_time} * V_t{n_time}'...
                                  + eps.*ones(n_user, rank)) ...
                              );
    U_t{n_time} = min(1, max(0, U_t{n_time}));
    % =========== Update V_t{n_time} ==========
    V_t{n_time} = V_t{n_time} .* (  U_t{n_time}' * R(:,:,n_time)  ./ ...
                                  (U_t{n_time}' * U_t{n_time} * V_t{n_time}...
                                  + eps.*ones(rank, n_item)));
    V_t{n_time} = min(max(0, V_t{n_time}), 1);
    % =========== Update B_t{1,2,...,n_time-1} ==========
    for p = 1:n_time-1
        temp_UP = lambda .* (B_t{n_time - p} - eye(rank)) - ...
            U_t{n_time-p}' * R(:,:,n_time-p) * V_t{n_time-p}' * C_t{n_time-p};
        temp_DOWN = U_t{n_time-p}' * U_t{n_time-p} * B_t{n_time-p} * ...
            C_t{n_time-p} * V_t{n_time-p} * V_t{n_time-p}' * C_t{n_time-p}';
        B_t{n_time - p} = B_t{n_time - p} .* (temp_UP ./ (temp_DOWN+eps*(eye(size(temp_DOWN)))));
        B_t{n_time - p} = min(max(0, B_t{n_time - p}), 1); % 缩放到0~1之间
    end
    % =========== Update C_t{1,2,...,n_time-1} ==========
    for p = 1:n_time-1
        temp_UP = lambda .* (C_t{n_time - p} - eye(rank)) - ...
            B_t{n_time-p}' * U_t{n_time-p}' * R(:,:,n_time-p) * V_t{n_time-p}';
        temp_DOWN = B_t{n_time-p}' * U_t{n_time-p}' * U_t{n_time-p} * ...
            B_t{n_time-p} * C_t{n_time-p} * V_t{n_time-p} * V_t{n_time-p}';
        C_t{n_time - p} = C_t{n_time - p} .* (temp_UP ./ (temp_DOWN+eps*(eye(size(temp_DOWN)))));
        C_t{n_time - p} = min(max(0, C_t{n_time - p}), 1); % 缩放到0~1之间
    end
    % ========== Stop Criterion Check ==========
    [REL_ERR(iter), is_conv] = is_convergent(C_t, B_t, U_t, V_t, ...
                                C_t0, B_t0, U_t0, V_t0, epsilon);
    if is_conv
        break;
    else
        C_t0 = C_t;
        B_t0 = B_t;
        U_t0 = U_t;
        V_t0 = V_t;
    end
end

% -------------------------------------------------------------------------
% Return Result
hat_tensor = history_data;
hat_tensor(:,:,n_time) = U_t{n_time} * V_t{n_time};
for p = 1:n_time-1
    hat_tensor(:,:,n_time-p) = U_t{n_time-p} * B_t{n_time-p} * ...
        C_t{n_time-p} * V_t{n_time-p};
end
clear history_data;
result.tensor = hat_tensor;
result.U_t = U_t;
result.V_t = V_t;
result.B_t = B_t;
result.C_t = C_t;
result.relerr = REL_ERR;
end

%% ================================================================
%  Sub-Function
% =========================================================================
function [rel_err, is_conv] = is_convergent(C_t, B_t, U_t, V_t, ...
                                C_t0, B_t0, U_t0, V_t0, epsilon)
n_time = length(U_t);
[~, n_item] = size(V_t{1});
[n_user, ~] = size(U_t{1});
hat_ten_0 = zeros(n_user, n_item, n_time);
hat_ten = hat_ten_0;
hat_ten(:,:,n_time) = U_t{n_time} * V_t{n_time};
hat_ten_0(:,:,n_time) = U_t0{n_time} * V_t0{n_time};
for p = 1:n_time-1
    hat_ten(:,:,n_time-p) = U_t{n_time-p} * B_t{n_time-p} * ... 
        C_t{n_time-p} * V_t{n_time-p};
end
for p = 1:n_time-1
    hat_ten_0(:,:,n_time-p) = U_t0{n_time-p} * B_t0{n_time-p} * ... 
        C_t0{n_time-p} * V_t0{n_time-p};
end
% frob(hat_ten)
% frob(hat_ten_0)
rel_err = norm(hat_ten_0(:) - hat_ten(:))/norm(hat_ten_0(:));
if rel_err < epsilon
    is_conv = 1;
else
    is_conv = 0;
end

end


