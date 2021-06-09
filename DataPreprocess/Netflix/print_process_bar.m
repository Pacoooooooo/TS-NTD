function [] = print_process_bar(current,total,varargin)
%print_process_bar 显示循环程序运行进度
%   current：    当前进度
%   total：      总循环次数
col_num = 50;
if  mod(length(varargin), 2) == 0 && ~isempty(varargin)
    if strcmp(varargin{1}, 'col_num')
        col_num = varargin{2};
    end
end
s = '[';
info = '|%2.2f%%';
finish_num = ceil(current/total * col_num);
FINISH_FLAG = '+';
UNFINISH_FLAG = '-';
CURRENT_FLAG = '>';
% for i = 1:col_num + length(info) - 1
%     s = [s, '\b'];
% end
for i = 1:col_num
    if i < finish_num
        s = [s, FINISH_FLAG];
    else
        if i == finish_num
            s = [s, CURRENT_FLAG];
        else
            s = [s, UNFINISH_FLAG];
        end
    end
end
s = [s, ']'];
fprintf([s, info, '\n'], current/total*100);

