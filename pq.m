function [O23,O34,O35,O46] = pq (O22, l_buff, p_buff, device)
% Programmed by Arslan Ahmad 30-04-2019
% Input Arguments:
%     O21 {list} -- list of O21 scores it is assumed no need to provide it
%     O22 {list} -- list of O22 scores
%     l_buff {list} -- durations of buffering events [default: []]]
%     p_buff {list} -- locations of buffering events in media time (in seconds) [default: []]]
%     device {str} -- pc or mobile

% Output Arguments
    % Calculate O46 and other diagnostic values according to P.1203.3
    % "O23": O23,
    % "O34": O34
    % "O35": O35,
    % "O46": O46
%% IN PROGRESS AR
        % # ---------------------------------------------------------------------
        % # Clause 3.2.2
        O22_len = length(O22);
        % # duration of the video (video lengths)
        duration = O22_len;
        O21 = 5.0* ones(duration,1);

        % # ---------------------------------------------------------------------
        % # Clause 8.1.1.1
        c_ref7 = 0.48412879;
        c_ref8 = 10;
        % # calculate weighted total stalling length


        for i=1:length(l_buff)
            w_stall(i) = l_buff(i) * exponential(1, c_ref7, 0, c_ref8, duration - p_buff(i));
        end
        total_stall_len = sum(w_stall);

        % # calculate average stalling interval
        avg_stall_interval = 0;
        num_stalls = length(l_buff);
        if num_stalls > 1
          for i=2:length(p_buff)
            sum_stall = sum(p_buff(i) - p_buff(i-1));
            avg_stall_interval = sum_stall / (length(l_buff) - 1);
          end
        end
        %
        % # ---------------------------------------------------------------------
        % # Clause 8.1.2.2
        vid_qual_spread = max(O22) - min(O22);
        %
        % # ---------------------------------------------------------------------
        % # Clause 8.1.2.3
        vid_qual_change_rate = double(0);
        for i = 2:duration
            diff = O22(i) - O22(i-1);
            if (diff > 0.2 | diff < -0.2)
                vid_qual_change_rate += 1;
              end
            end
        vid_qual_change_rate = vid_qual_change_rate / duration;
        % %DONE AR
        % # ---------------------------------------------------------------------
        % # Clause 8.1.2.4 and 8.1.2.5
        QC = [];

        ma_order = 5;
        ma_kernel = ones(ma_order) / ma_order;
        padding_beg = O22(1) * (ma_order - 1);
        padding_end = O22(end) * (ma_order - 1));
        padded_O22 = append(append(padding_beg, O22), padding_end);
        ma_filtered = conv(padded_O22, ma_kernel);
        % %DONE AR
        step = 3;
        for i:step:length(ma_filtered)
          current_score =  ma_filtered(i);
          next_score = ma_filtered(i+step);
          %%% check if correct AR
          % current_score, next_score in zip(ma_filtered[0::step], ma_filtered[step::step]):
            thresh = 0.2;
            if (next_score - current_score) > thresh
                QC.append(1);
            elseif -thresh < (next_score - current_score) < thresh
                QC.append(0);
            else
                QC.append(-1);
              end
            end

        lens = [];
        for i=1:length(QC)
          index = i;
          val = QC(i);
            if val ~= 0
                if lens & lens[-1][1] ~= val
                    lens.append([index, val]);
                if not lens:
                    lens.append([index, val]);
                  end
                end
              end
        if lens
          %%%%%%%need to have a look
            lens.insert(0, [0, 0]);
            lens.append([length(QC), 0]);
            for i =2:length(lens)
            distances(i) = lens(i)-lens(i-1);
            end
            longest_period = max(distances) * step;
        else
            longest_period = length(QC) * step;
          end
        q_dir_changes_longest = longest_period;
        %TODO Arslan
        q_dir_changes_tot = sum(1 for k, g in groupby([s for s in QC if s != 0]))

        # ---------------------------------------------------------------------
        # Eq. 19-21
        O35_denominator = O35_numerator = 0;
        av1 = -0.00069084;
        av2 = 0.15374283;
        av3 = 0.97153861;
        av4 = 0.02461776;
        t1 = 0.00666620027943848;
        t2 = 0.0000404018840273729;
        t3 = 0.156497800436237;
        t4 = 0.143179744942738;
        t5 = 0.0238641564518876;
        O34 = zeros(duration);
        for t = 1:duration
            O34[t] = max(min(
                av1 + av2 * O21[t] + av3 * O22[t] + av4 * O21[t] * O22[t],
                5), 1);
            temp = O34[t];
            w1 = t1 + t2 * exp((t / double(duration)) / t3);
            w2 = t4 - t5 * temp;

            O35_numerator += w1 * w2 * temp;
            O35_denominator += w1 * w2;
        O35_baseline = O35_numerator / O35_denominator;
        % Done Arslan
        # ---------------------------------------------------------------------
        # Clause 8.1.2.1
        c1 = 1.87403625;
        c2 = 7.85416481;
        c23 = 0.01853820;
        O34_diff = list(O34);
        for i = 1:duration
            # Eq. 5
            w_diff = exponential(1, c1, 0, c2, duration-i-1);
            O34_diff(i) = (O34(i) - O35_baseline) * w_diff;

        # Eq. 6
        neg_perc = prctile(O34_diff, 10);
        # Eq. 7
        negative_bias = max(0, -neg_perc) * c23;

        # ---------------------------------------------------------------------
        # Eq. 29
        s1 = 9.35158684;
        s2 = 0.91890815;
        s3 = 11.0567558;
        stalling_impact = exp(- num_stalls / s1) * \
            exp(- total_stall_len / duration / s2) * \
            exp(- avg_stall_interval / duration / s3);
        # Eq. 31
        O23 = 1 + 4 * stalling_impact;

        # ---------------------------------------------------------------------
        # Clause 8.3

        # Eq. 24
        osc_comp = 0;
        comp1 = 0.67756080;
        comp2 = -8.05533303;
        osc_test = ((q_dir_changes_longest / duration) < 0.25) and (q_dir_changes_longest < 30);
        if osc_test
            # Eq. 27
            q_diff = max(0.0, 1 + log10(vid_qual_spread + 0.001));
            # Eq. 23
            osc_comp = max(0.0, min(q_diff * exp(comp1 * q_dir_changes_tot + comp2), 1.5));
          end
        # Eq. 26
        adapt_comp = 0;
        comp3 = 0.17332553;
        comp4 = -0.01035647;
        adapt_test = (q_dir_changes_longest / duration) < 0.25;
        if adapt_test
            adapt_comp = max(0.0, min(comp3 * vid_qual_spread * vid_qual_change_rate + comp4, 0.5));
          end
        # Eq. 18
        O35 = O35_baseline - negative_bias - osc_comp - adapt_comp;

        # ---------------------------------------------------------------------
        # Eq. 28
        mos = 1.0 + (O35 - 1.0) * stalling_impact;

        # ---------------------------------------------------------------------
        # Eq. 28
        rf_score = rfmodel.calculate(O21, O22, l_buff, p_buff, duration);
        O46 = 0.75 * max(min(mos, 5), 1) + 0.25 * rf_score;
