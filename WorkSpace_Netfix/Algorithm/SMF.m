function [smf_result] = SMF(tensor_data, rank, opts)
%smf Sequential Matrix Factorization
%   tensor_data: rating tensor,#of_user x #of_item x #of_timeslice,
%                   "0" stands for "Not Rated"
%   rank:       #of features
%   opts:
%       alpha:  regular parameter for U_t, default 1
%       beta:   regular parameter for L, default 1
%       gamma:  regular parameter for Similarity-Smooth
%       agg_type:   aggregation function type
%  ------------------------------------------------------------------------
%   pred_tensor: predict tensor data
%   U_t:    #of_time matrices ¡ª¡ª user latent factor matrix
%   L:      item latent factor matrix
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% Parameters Setting
if isfield(opts,'alpha') alpha = opts.alpha; else alpha = 1; end
if isfield(opts,'beta') beta = opts.beta; else beta = 1; end
if isfield(opts,'lambda') lambda = opts.lambda; else lambda = 1; end
if isfield(opts,'maxiter') maxiter = opts.maxiter; else maxiter = 1e3; end
if isfield(opts,'epsilon') epsilon = opts.epsilon; else epsilon = 1e-4; end
[n_user, n_item, n_time] = size(tensor_data);

% -------------------------------------------------------------------------
% Generate Y_t, \Sigam_t
tic;
Y_t = generate_indicator_matrix(tensor_data);
S_t = generate_coeffcient_matrix(tensor_data);
% ts = datestr(datetime('now'));
% file_name = ['smf_matrix_', ts(1:11),'_' ,ts(13:14),ts(16:17),ts(19:20), '.mat'];
% save(file_name, 'Y_t', 'S_t')
generate_matrix_time = toc;
fprintf("[Info][SMF]Éú³É¾ØÕóºÄÊ±: %.4f.\n", generate_matrix_time);
% -------------------------------------------------------------------------
% Initial Matrices
U_t = cell(n_time, 1);
for t = 1:n_time
    U_t{t} =  rand(n_user, rank);
end
L = rand(n_item, rank);

% -------------------------------------------------------------------------
% Algorithm Loop
L0 =  L;
U0_t = U_t;
REL_ERR = zeros(maxiter,1);
for iter = 1:maxiter
    if mod(iter, round(maxiter/10)) == 0	
        fprintf('[Info][SMF]Iter: %4d Step Relative Error: %.4f .\n', iter, REL_ERR(iter-1)); 
    end
    % ========== Update U_t ==========
    for t = 1:n_time
        if t == 1
            temp_UP = (Y_t{t} .* tensor_data(:,:,t)) * L;
        else
            temp_UP = (Y_t{t} .* tensor_data(:,:,t)) * L + ...
                lambda * S_t{t} * U_t{t-1};
        end
        temp_DOWN = (Y_t{t} .* (U_t{t} * L')) * L + ...
            lambda * S_t{t} * U_t{t} + alpha * U_t{t};
        temp_DOWN = temp_DOWN + eps * ones(size(temp_DOWN));
        temp = temp_UP ./ temp_DOWN;
        temp = max(eps, temp);
        U_t{t} = U_t{t} .* (sqrt(temp));
    end
    % ========== Update L ==========
    temp_UP = (Y_t{1} .* tensor_data(:,:,1))' * U_t{1};
    temp_DOWN = (Y_t{1} .* (U_t{1}*L'))' * U_t{1};
    for t = 2:n_time
        temp_UP = temp_UP + (Y_t{t} .* tensor_data(:,:,t))' * U_t{t};
        temp_DOWN = temp_DOWN + (Y_t{t} .* (U_t{t}*L'))' * U_t{t};
    end
    temp_DOWN = temp_DOWN + beta * L;
    temp = temp_UP ./ temp_DOWN;
    temp = max(eps, temp);
    L = L .* (sqrt(temp));
    
    % ========== Stop Criterion Check ==========
    [REL_ERR(iter), is_conv] = is_convergent(U_t,L, U0_t,L0, epsilon);
    if is_conv
        break;
    else
        L0 = L;
        U0_t = U_t;
    end
    
end

% -------------------------------------------------------------------------
% Return Result
hat_tensor = tensor_data;
for t = 1:n_time
    hat_tensor(:,:,t) = U_t{t}*L';
end
clear tensor_data;
smf_result.tensor = hat_tensor;
smf_result.U_t = U_t;
smf_result.L = L;
smf_result.relerr = REL_ERR;
smf_result.SIGMA = S_t;
end

%% ================================================================
%  Sub-Function
% =========================================================================

function [rel_err, is_conv] = ...
    is_convergent(U_t,L,U0_t,L0,epsilon)
n_time = length(U_t);
[n_item, ~] = size(L);
[n_user, ~] = size(U_t{1});
hat_ten_0 = zeros(n_user, n_item, n_time);
hat_ten = hat_ten_0;
for t = 1:n_time
    hat_ten(:,:,t) = U_t{t}*L';
end
for t = 1:n_time
    hat_ten_0(:,:,t) = U0_t{t}*L0';
end
rel_err = norm(hat_ten_0(:) - hat_ten(:))/norm(hat_ten_0(:));
if rel_err < epsilon
    is_conv = 1;
else
    is_conv = 0;
end

end

function Y_t = generate_indicator_matrix(tensor_data)
[n_user, n_item, n_time] = size(tensor_data);
Y_t = cell(n_time, 1);
for t = 1:n_time
    Y_t{t} = tensor_data(:,:,t) ~= 0;
end
end

function S_t = generate_coeffcient_matrix(tensor_data)
S_t = cal_user_sim(tensor_data);
end
