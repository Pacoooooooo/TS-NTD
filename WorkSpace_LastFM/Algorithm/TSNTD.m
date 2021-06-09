function [result] = TSNTD(history_data, rank, SIGMA, opts)
%TS_NTD Temporal Similarity Nonnegative Tensor Decomposition
%   此处显示详细说明
%
%
%
%
%
% =========================================================================

% 参数设置
% Parameters Setting
regular_term = 1;
if isfield(opts,'alpha_U')  alpha_U = opts.alpha_U; else alpha_U = regular_term;   end
if isfield(opts,'alpha_L')  alpha_L = opts.alpha_L; else alpha_L = regular_term;   end
if isfield(opts,'alpha_T')  alpha_T = opts.alpha_T; else alpha_T = regular_term;   end
if isfield(opts, 'beta')    beta = opts.beta;       else beta = 1;      end
if isfield(opts,'maxiter')  maxiter = opts.maxiter; else maxiter = 1e3; end
if isfield(opts,'epsilon')  epsilon = opts.epsilon; else epsilon = 1e-4;end

[n_item, n_user, n_time] = size(history_data);
% -------------------------------------------------------------------------

tdata = history_data;
% -------------------------------------------------------------------------
% Initial Matrices
psedu_zero = eps;

U = max(psedu_zero, rand(n_user, rank));
L = max(psedu_zero, rand(n_item, rank));
T = max(psedu_zero, rand(n_time, rank));
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
% Uhat = cpd(history_data, rank);
% L = Uhat{1};
% U = Uhat{2}; 
% T = Uhat{3}; 
%  L = max(psedu_zero, L);
%  U = max(psedu_zero, U);
%  T = max(psedu_zero, T);
% -------------------------------------------------------------------------
% Algorithm Loop
U0 = U;
L0 = L;
T0 = T;
REL_ERR = zeros(maxiter,1);
for iter = 1:maxiter
    if mod(iter, round(maxiter/10)) == 0	
        fprintf('[Info][TSNTD]Iter: %4d Step Relative Error: %.4f .\n', iter, REL_ERR(iter-1)); 
    end
    % ========== Update L ==========
%     tdata = fmt(tdata); % fmt,ful 真是个耗时的操作
    TEMP_UP = mtkrprod(tdata, {L, U, T}, 1)  - alpha_L * L;
    TEMP_DOWN = L * kr(T,U)' * kr(T,U);
    L = L .* (TEMP_UP ./ TEMP_DOWN);
    L = max(psedu_zero, L);
%     tdata = ful(tdata);
    % ========== Update U ==========
%     tdata = fmt(tdata);
    TEMP_UP = mtkrprod(tdata, {L, U, T}, 2) - alpha_U * U;
    TEMP_DOWN = U * kr(T,L)' * kr(T,L);
    U = U .* (TEMP_UP ./ TEMP_DOWN);
    U = max(psedu_zero, U);
%     tdata = ful(tdata);
    % ========== Update T ==========
%     tdata = fmt(tdata);
    TEMP_UP = mtkrprod(tdata, {L, U, T}, 3) - alpha_T * T - beta * (SIGMA' * SIGMA * T);
    TEMP_DOWN = T * kr(U,L)' * kr(U,L);
    T = T .* (TEMP_UP ./ TEMP_DOWN);
    T = max(psedu_zero, T);
%     tdata = ful(tdata);
    % ========== Stop Criterion Check ==========
    [REL_ERR(iter), is_conv] = is_convergent(L,U,T, L0,U0,T0, epsilon);
%     if mod(iter, 5) == 0	
%         fprintf('Iter %4d | REL_ERR: %.4f \n', iter, REL_ERR(iter)); 
%     end
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
hat_tensor = cpdgen({L,U,T});
hat_tensor = double(hat_tensor);
result.tensor = hat_tensor;
result.factor = {L,U,T};
result.relerr = REL_ERR;
result.SIGMA = SIGMA;

end

%% ================================================================
% Sub-Function
% =========================================================================

function [rel_err, is_conv] = is_convergent(L, U, T, L0, U0,T0, epsilon)
    ten_ori = cpdgen({U0, L0, T0});
    ten_hat = cpdgen({U, L, T});
    rel_err = norm(ten_ori(:) - ten_hat(:))/norm(ten_ori(:)); 
    if rel_err < epsilon
        is_conv = 1;
    else
        is_conv = 0;
    end

%     ten_hat = cpdgen({L, U, T});
%     ten_err = ten_hat - origin_tdata;
%     ten_err(ismissing(origin_tdata)) = 0;
%     origin_tdata(ismissing(origin_tdata)) = 0;
%     rel_err = norm(ten_err(:)) / norm(origin_tdata(:));
%     if rel_err < epsilon
%         is_conv = 1;
%     else
%         is_conv = 0;
%     end
end
