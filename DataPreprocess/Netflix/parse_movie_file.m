function [ records ] = parse_movie_file( file_name )
%parse_movie_file ������Ӱ�ļ�,
%   ����Ӱ�ļ�������{[movie_id, user_id, rating,timestamp],[...],[...]}
%   �������ִ�к�ʱ�ر�á�����

    fid=fopen(file_name);  %���ı��ļ�
    line_num = 0;
    records = [];
    while ~feof(fid)
        str = fgetl(fid);   % ��ȡһ��, str���ַ���
        line_num = line_num + 1;
        if line_num == 1
            split_str = regexp(str ,'\:','split');
            movie_id = split_str(1);
        else
            split_str = regexp(str ,'\,','split');
            if length(split_str) == 3
            timestamp = str2timestamp(split_str(3));
            records(line_num-1, :) = [str2double(movie_id),...        % movie_id       
                                    str2double(split_str(1)),...    % user_id
                                    str2double(split_str(2)),...    % rating
                                    timestamp...        % timestamp           
                                    ];
            end
        end
        
    end
    fclose(fid);

end

function timestamp = str2timestamp(timestamp)
    format = 'yyyy-mm-dd';
    timestamp = datenum(timestamp, format);
%     class(timestamp) %double
end