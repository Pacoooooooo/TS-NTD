function [upd] = cal_upd(tensor_data)
%z_calc_upd 计算UPD
%   tensor_data: rating tensor, #of_user x #of_item x #of_timeslice, 
%                   "0" stands for "Not Rated"
%   upd:    1 x #of_user
% -------------------------------------------------------------------------

[n_user, n_item, n_time] = size(tensor_data);
MISS_FLAG = mode(tensor_data, 'all');
prev_data = tensor_data(:,:,1:n_time-1);
curr_data = tensor_data(:,:,n_time);
upd = zeros(n_user,1);
clear tensor_data;

rated_prev_index = prev_data ~= MISS_FLAG; % 评过分的位置
rated_prev_index = sum(rated_prev_index, 3) ~= MISS_FLAG; % 0/1 矩阵
rated_curr_index = curr_data ~= MISS_FLAG; % 评过分的位置，0/1 矩阵
clear prev_data curr_data;

for u = 1:n_user
    n_intersect = my_intersct(rated_prev_index(u,:),rated_curr_index(u,:));
    n_union = my_union(rated_prev_index(u,:),rated_curr_index(u,:));
    upd(u) = 1 - (n_intersect / n_union);
end

end

%% ================================================================
% Sub-Function
% =========================================================================
function n_intersect = my_intersct(prev_list, curr_list)
    n_intersect = sum(prev_list .* curr_list);
end

function n_union = my_union(prev_list, curr_list)
    n_union = sum((prev_list + curr_list) > 0);
end

