function rf_score = rfmodel(O21, O22, l_buff, p_buff, duration)
    if ~isempty(l_buff) && ~isempty(p_buff)
        if p_buff(1) == 0
            initial_buffering_length = l_buff(1);
        else
            initial_buffering_length = 0;
        end
    else
        initial_buffering_length = 0;
    end
    rebuf_stats = get_rebuf_stats(l_buff, p_buff, duration);
    rebuf_stats(2) = 1.0 * initial_buffering_length / 3.0 + rebuf_stats(2);
    rebuf_stats(3) = 1.0 * initial_buffering_length / duration / 3.0 + rebuf_stats(4);

    O21_rounded = round(O21,3);
    O22_rounded = round(O22,3);
    sec_moses_feature_video = scale_moses(O22_rounded, 3);
    sec_moses_feature_audio = scale_moses(O21_rounded, 2);
    sec_mos_stat = prctile(O22_rounded, [1, 5, 10]);

    tree_path = '/home/arslan/Documents/TNSM/p1203-matlab/trees';
    feature = [rebuf_stats, sec_moses_feature_video, sec_mos_stat, sec_moses_feature_audio, duration];
    rf_score = execute_trees(feature,tree_path);
  end
