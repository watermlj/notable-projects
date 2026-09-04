function gamma2 = ...
    Gamma2(mass1, mass2, length1, length2, theta1, theta2, omega1, omega2, g)

    alpha1 = Alpha1(mass1, mass2, length1, length2, theta1, theta2);
    alpha2 = Alpha2(length1, length2, theta1, theta2);
    beta1 = Beta1(mass1, mass2, length1, length2, theta1, theta2, omega2, g);
    beta2 = Beta2(length1, length2, theta1, theta2, omega1, g);

    gamma2 = (beta2 - alpha2 * beta1) / (1 - alpha1 * alpha2);

end