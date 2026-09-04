function alpha1 = Alpha1(mass1, mass2, length1, length2, theta1, theta2)

    alpha1 = (mass2 * length2 * cos(theta1 - theta2)) / ...
        (mass1 * length1 + mass2 * length1);

end