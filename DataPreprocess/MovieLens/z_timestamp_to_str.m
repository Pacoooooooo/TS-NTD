function [time_str] = z_timestamp_to_str(unix_ts)
%timestamp_to_str 将UNIX时间戳转换成时间字符串
%   unix_ts: UNIX时间戳
%   time_str: 时间字符串（北京时间）

time_zone = 8;
% 86400 = 60*60*24
conv_t2 = (unix_ts+3600*time_zone)/86400 + datenum(1970,1,1);
time_str = datestr(conv_t2);

end

