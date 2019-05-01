function y = exponential(a, b, c, d, x)
    % """
    % Return exponential constrained between a range.
    % Call with exponential(a, b, c, d, x).
    % Parameters:     a: defines left anchor point of function on y-axis
    %                 b: defines slope of curve
    %                 c: shifts the anchor point of curve on x-axis (set to 0)
    %                 d: defines slope of the curve
    % Visualization at: https://www.desmos.com/calculator/xsy2xdqmuo
    % """
    y = b + (a - b) * np.exp(-(x - c) * np.log(0.5) / (-(d - c)));
  end 
