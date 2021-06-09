function [rcp_result] = RCP(tensor_data, rank, opts)
%regular_cp 带有F范数正则项的CP分解
%   tensor_data: rating tensor,#of_user x #of_item x #of_timeslice, 
%                   "0" stands for "Not Rated"
%   rank:       #of features
%   opts:
%       alpha_U:  regular parameter for U, default 1
%       alpha_L:  regular parameter for L, default 1
%       alpha_T:  regular parameter for T, default 1
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Parameters Setting
if isfield(opts,'alpha_U') alpha_U = opts.alpha_U; else alpha_U = 1; end
if isfield(opts,'alpha_L') alpha_L = opts.alpha_L; else alpha_L = 1; end
if isfield(opts,'alpha_T') alpha_T = opts.alpha_T; else alpha_T = 1; end
if isfield(opts,'maxiter') maxiter = opts.maxiter; else maxiter = 1e3; end
if isfield(opts,'epsilon') epsilon = opts.epsilon; else epsilon = 1e-4; end

[n_user, n_item, n_time] = size(tensor_data);
tdata = tensor(tensor_data);
clear tensor_data

% -------------------------------------------------------------------------
% Initial Matrices
U = randn(n_user, rank);
L = randn(n_item, rank);
T = randn(n_time, rank);

% -------------------------------------------------------------------------
% Algorithm Loop
U0 = U;
L0 = L;
T0 = T;
REL_ERR = zeros(maxiter,1);
for iter = 1:maxiter
    if mod(iter, round(maxiter/10)) == 0	
        fprintf('[Info][RCP]Iter: %4d Step Relative Error: %.4f .\n', iter, REL_ERR(iter-1)); 
    end
    % ========== Update U ==========
    temp = khatrirao(T,L)' * khatrirao(T,L);
    temp1 = inv(temp + alpha_U * eye(size(temp)));
    temp2 = tenmat(tdata,1);
    U = temp2.data * (khatrirao(T,L) ) * temp1;
    % ========== Update L ==========
    temp = khatrirao(T,U)' * khatrirao(T,U);
    temp1 = inv(temp + alpha_L * eye(size(temp)));
    temp2 = tenmat(tdata, 2);
    L = temp2.data * (khatrirao(T, U) ) * temp1;
    % ========== Update T ==========
    temp = khatrirao(L,U)' * khatrirao(L, U);
    temp1 = inv(temp + alpha_T * eye(size(temp)));
    temp2 = tenmat(tdata, 3);
    T = temp2.data * (khatrirao(L, U) ) * temp1;
    % ========== Stop Criterion Check ==========
    [REL_ERR(iter), is_conv] = is_convergent(U,L,T, U0,L0,T0, epsilon);
    if is_conv
        break;
    else
        U0 = U;
        L0 = L;
        T0 = T;
    end
end

% -------------------------------------------------------------------------
% Return Result
hat_tensor = ktensor({U,L,T});
hat_tensor = double(hat_tensor);
rcp_result.tensor = hat_tensor;
rcp_result.factor = {U,L,T};
rcp_result.relerr = REL_ERR;

end

%% ================================================================
% Sub-Function
% =========================================================================
function [rel_err, is_conv] = is_convergent(U,L,T, U0,L0,T0, epsilon)
    ten_ori = ktensor({U0, L0, T0});
    ten_hat = ktensor({U, L, T});
    rel_err = norm(ten_ori(:) - ten_hat(:))/norm(ten_ori(:)); 

    if rel_err < epsilon
        is_conv = 1;
    else
        is_conv = 0;
    end
end