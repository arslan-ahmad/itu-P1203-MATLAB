function y = mos_from_r(Q)
    MOS_MAX = 4.9;
    MOS_MIN = 1.05;
    MOS = MOS_MIN + double(MOS_MAX - MOS_MIN) * double(Q) / 100.0 + double(Q) * \
          double(Q - 60.0) * double(100.0 - Q) * 0.000007
    y = min(MOS_MAX, max(MOS, MOS_MIN));
  end
