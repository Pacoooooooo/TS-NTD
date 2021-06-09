function [time_str] = z_timestamp_to_str(unix_ts)
%timestamp_to_str ��UNIXʱ���ת����ʱ���ַ���
%   unix_ts: UNIXʱ���
%   time_str: ʱ���ַ���������ʱ�䣩

time_zone = 8;
% 86400 = 60*60*24
conv_t2 = (unix_ts+3600*time_zone)/86400 + datenum(1970,1,1);
time_str = datestr(conv_t2);

end

