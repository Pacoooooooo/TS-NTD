function num = z_which_slice(edges, timestamp)
% ��������� timestamp == edges(end) ʱ��
% ����ֵ���� n_slice+1��
% ��ʱ���� timestamp_histogram ����ʹ�ò�����ָ����⡣
    num = sum((edges - timestamp) <= 0);
end