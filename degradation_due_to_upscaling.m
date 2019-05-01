function deg_scal_v =  degradation_due_to_upscaling(coding_res, display_res)
    % """
    % Degradation due to upscaling
    % """
    scale_factor = display_res / coding_res;
    scale_factor = max(scale_factor, 1);
    u1 = 72.61;
    u2 = 0.32;
    deg_scal_v = u1 * log10(u2 * (scale_factor - 1.0) + 1.0);
    deg_scal_v = constrain(deg_scal_v, 0.0, 100.0);
  end
