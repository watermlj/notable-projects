clc
clear
close all

%% Step 1: Grab system information and specify time-evolved vectors

[theta1, theta2, omega1, omega2, gamma1, gamma2] = deal(zeros(1, 2));

[mass1, mass2, length1, length2, g, theta1(1, 2), theta2(1, 2), ...
    omega1(1, 2), omega2(1, 2), h, timeFinal, n, massColor1, ...
    massColor2] = GetSystemSpec();

%% Step 2: Calculate remaining initial values, preallocate vector space

gamma1(1, 2) = Gamma1(mass1, mass2, length1, length2, theta1(1, 2), ...
    theta2(1, 2), omega1(1, 2), omega2(1, 2), g);
gamma2(1, 2) = Gamma2(mass1, mass2, length1, length2, theta1(1, 2), ...
    theta2(1, 2), omega1(1, 2), omega2(1, 2), g);

for i = [theta1, theta2, omega1, omega2, gamma1, gamma2]

    resize(i, [n + 1, 2]);

end

%% Step 3: Perform state vector updates using RK4

[theta1, theta2, omega1, omega2, gamma1, gamma2] = ...
    RK4_Algorithm(mass1, mass2, length1, length2, g, n, h, theta1, ...
    theta2, omega1, omega2, gamma1, gamma2);

%% Step 4: Data Visualization

set(groot, 'defaultFigureVisible', 'off')

GenerateAnimGIF(length1, length2, theta1, theta2, massColor1, ...
    massColor2, n + 1, timeFinal);
