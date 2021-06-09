function [sim_matrices] = cal_user_sim(tensor_data)
%calc_user_sim 计算用户时间相似度矩阵
%   tensor_data
%   sim_matrices

[n_user, n_item, n_time] = size(tensor_data);
sim_matrices = cell(n_time, 1);
tdata = max(0, tensor_data);
clear tensor_data
sim_matrices{1} = eye(n_user);
for t = 2:n_time
    user_sim_vector = ones(n_user,1);
    for u = 1:n_user
        x = tdata(u,:,t);
        y = tdata(u,:,t-1);
        user_sim_vector(u) = cal_cos_sim(x,y);
    end
    sim_matrices{t} = diag(user_sim_vector);
end
end

