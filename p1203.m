function [O22,O23,O34,O35,O46]  = p1203 (coding_res, display_res, bitrate_kbps_segment_size, framerate,l_buff, p_buff, device)
   O22 = pv(coding_res, display_res, bitrate_kbps_segment_size, framerate);
   [O23,O34,O35,O46] = pq(O22, l_buff, p_buff, device);
end