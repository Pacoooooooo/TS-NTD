function [is_member] = my_ismember(target,  data)
%my_ismember 通过排序来缩小查找范围
%   此处显示详细说明

% data = sort(data);
n_element = length(data);
div_num = 100;

div_points = data(floor(linspace(1, n_element, div_num)));
small_points = div_points<target;
start_idx = sum(small_points)+1;

is_member = ismember(target, data(start_idx, n_element));

end

