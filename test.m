clear all 
close all
clc
%% test for PV 
% test passed


mpd1=importfile('bbb.csv',1,17);
video11=table2cell(mpd1);
video11([1,2,3,5,7,9,10,15],:)=[];
% video1=cell2mat(video11(end,3:end));
bitrate_kbps_segment_size =  cell2mat(video11(end,3:end))/4e3;
bitrate_kbps_segment_size =bitrate_kbps_segment_size';
dis = char(video11{end,2});
a = split(dis,"x");
display_res = str2double(a{1,1})*str2double(a{2,1});
% display_res = display_res*ones(1,length(bitrate_kbps_segment_size));
coding_res = str2double(a{1,1})*str2double(a{2,1}); 
% coding_res = coding_res*ones(1,length(bitrate_kbps_segment_size));
framerate = 25;
% framerate = 25*ones(1,length(bitrate_kbps_segment_size));
O22 = pv(coding_res, display_res, bitrate_kbps_segment_size, framerate);

%% test for pq 
l_buff= [1 3];
p_buff = [10 15]; 
device = 'pc';
[O23,O34,O35,O46] = pq (O22, l_buff, p_buff, device);