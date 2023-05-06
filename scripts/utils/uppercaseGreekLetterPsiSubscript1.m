function outputArg1 = uppercaseGreekLetterPsiSubscript1(observationAngularSpeed,observationAccelerometer,dt)
%UPPERCASEGREEKLETTERGAMMASUBSCRIPT0 此处显示有关此函数的摘要
%   此处显示详细说明

% addpath(genpath(pwd));

skewObservationAngularSpeed = skew(observationAngularSpeed);
skewObservationAngularSpeedPower2 = skewObservationAngularSpeed * skewObservationAngularSpeed;
phi = norm(observationAngularSpeed);
phiPower2 = phi * phi;
phiPower3 = phiPower2 * phi;
phiPower4 = phiPower3 * phi;
phiPower5 = phiPower4 * phi;
phiPower6 = phiPower5 * phi;
theta = phi * dt;
thetaPower2 = theta * theta;
theta2 = theta * 2;
thetaSin = sin(theta);
thetaCos = cos(theta);
theta2Sin = sin(theta2);
theta2Cos = cos(theta2);
skewObservationAccelerometer = skew(observationAccelerometer);


outputArg1 = skewObservationAccelerometer * uppercaseGreekLetterGammaSubscript2(- observationAngularSpeed * dt) * dt * dt *...
    ((thetaSin - theta * thetaCos) / phiPower3 .* skewObservationAngularSpeed * skewObservationAccelerometer ...
    + (theta2Cos - 4 * thetaCos + 3) / (4 * phiPower4) .* skewObservationAngularSpeed * skewObservationAccelerometer * skewObservationAngularSpeed ...
    + (4 * thetaSin + theta2Sin - 4 * theta * thetaCos - 2 * theta) / (4 * phiPower5) .* skewObservationAngularSpeed * skewObservationAccelerometer * skewObservationAngularSpeedPower2 ...
    + (thetaPower2 - 2 * theta * thetaSin - 2 * thetaCos + 2) / (2 * phiPower4) .* skewObservationAngularSpeedPower2 * skewObservationAccelerometer ...
    + (6 * theta - 8 * thetaSin + theta2Sin) / (4 * phiPower5) .* skewObservationAngularSpeedPower2 * skewObservationAccelerometer * skewObservationAngularSpeed ...
    + (2 * thetaPower2 - 4 * theta * thetaSin - theta2Cos + 1) / (4 * phiPower6) .* skewObservationAngularSpeedPower2 * skewObservationAccelerometer * skewObservationAngularSpeedPower2);

end
