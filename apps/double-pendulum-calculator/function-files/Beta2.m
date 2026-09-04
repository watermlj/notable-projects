function beta2 = Beta2(length1, length2, theta1, theta2, omega1, g)

    beta2 = ((omega1^2 * length1 * sin(theta1 - theta2)) / (length2)) - ...
        (g * sin(theta2)) / (length2);

end