function degradation_integration(mos_cod_v, deg_cod_v, deg_scal_v, deg_frame_rate_v)
    % """
    % Integrate the three degradations
    % """
    deg_all = constrain(deg_cod_v + deg_scal_v + deg_frame_rate_v, 0.0, 100.0);
    qv = 100 - deg_all;
    y = mos_from_r(qv);
  end
