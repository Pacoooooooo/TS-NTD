function num = z_which_slice(edges, timestamp)
% 这个函数当 timestamp == edges(end) 时，
% 返回值将是 n_slice+1。
% 当时搭配 timestamp_histogram 函数使用不会出现该问题。
    num = sum((edges - timestamp) <= 0);
end