function y = get_rebuf_stats(l_buff, p_buff, duration)
    if isempty(p_buff) || (length(p_buff) == 1 && p_buff(1) == 0)
         y = [0, 0, 0, 0, duration];
    else
        events = [];
        index = 1;
        for i=1:length(p_buff)
          b = p_buff(i);
            if b ~= 0
                events = [events; [b, l_buff(index)]];
            index = index + 1;
            end
        end
        num_rebuf = length(events);
        len_rebuf = sum(events(:,2));
        num_rebuf_per_length = 1.0 * num_rebuf / duration;
        len_rebuf_per_length = 1.0 * len_rebuf / duration;
        time_of_last_rebuf = duration - events(end,1);
    end
      y = [num_rebuf, len_rebuf, num_rebuf_per_length, len_rebuf_per_length, time_of_last_rebuf];
      end
