function y= constrain(x, minimum, maximum)
    % """
    % Constrain a vector input x between a certain minimum and maximum
    % """
    y = max(min(x, maximum), minimum);
  end
