function deg_frame_rate_v = degradation_due_to_frame_rate_reduction(deg_cod_v, deg_scal_v, framerate)
    % """
    % Degradation due to frame rate reduction
    % """
    t1 = 30.98;
    t2 = 1.29;
    t3 = 64.65;
    deg_frame_rate_v = 0;
    if framerate < 24
        deg_frame_rate_v = (100 - deg_cod_v - deg_scal_v) * (t1 - t2 * framerate) / (t3 + framerate);
    end
    deg_frame_rate_v = constrain(deg_frame_rate_v, 0, 100);
  end
