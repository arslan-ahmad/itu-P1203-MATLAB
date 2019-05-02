function score = pv(coding_res, display_res, bitrate_kbps_segment_size, framerate)
  %% this function implements the mode 0 of p.1203
  % output of this function is O.22 of the model
  % Programmed by Arslan Ahmad 30-04-2019
  % Mode 0 model
  %
  % Arguments:
  %     coding_res {int} -- number of pixels in coding resolution
  %     display_res {int} -- number of display resolution pixels
  %     bitrate_kbps_segment_size {float} -- bitrate in kBit/s
  %     framerate {float} -- frame rate
  %
  % Returns:
  %     float -- O22 score
  %% COMPLETED AR
%   # compression degradation
      a1 = 11.9983519;
      a2 = -2.99991847;
      a3 = 41.2475074001;
      a4 = 0.13183165961;
      q1 = 4.66;
      q2 = -0.07;
      q3 = 4.06;
      quant = a1 + a2 * log(a3 + log(bitrate_kbps_segment_size) + log(bitrate_kbps_segment_size .* bitrate_kbps_segment_size / (coding_res * framerate) + a4));
      mos_cod_v = q1 + q2 * exp(q3 * quant);
      mos_cod_v = constrain(mos_cod_v, 1.0, 5.0); %done
      deg_cod_v = 100.0 - r_from_mos(mos_cod_v); %done
      deg_cod_v = constrain(deg_cod_v, 0.0, 100.0); %done

%       # scaling, framerate degradation
      deg_scal_v = degradation_due_to_upscaling(coding_res, display_res); %done
      deg_frame_rate_v = degradation_due_to_frame_rate_reduction(deg_cod_v, deg_scal_v, framerate); %done

%       # degradation integration
      score = degradation_integration(mos_cod_v, deg_cod_v, deg_scal_v, deg_frame_rate_v); %done
    end
