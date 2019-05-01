function y= constrain(x, minimum=0.0, maximum=100.0):
    % """
    % Constrain a vector input x between a certain minimum and maximum
    % """
    y = max(min(x, maximum), minimum);
  end
