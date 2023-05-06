function outputArg1 = uppercaseGreekLetterPsiSubscript2(observationAngularSpeed,observationAccelerometer,dt)
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
phiPower7 = phiPower6 * phi;
theta = phi * dt;
thetaPower2 = theta * theta;
thetaPower3 = thetaPower2 * theta;
theta2 = theta * 2;
thetaSin = sin(theta);
thetaCos = cos(theta);
theta2Sin = sin(theta2);
theta2Cos = cos(theta2);
skewObservationAccelerometer = skew(observationAccelerometer);


outputArg1 = skewObservationAccelerometer * uppercaseGreekLetterGammaSubscript3(- observationAngularSpeed * dt) * dt * dt * dt *...
    ((theta * thetaSin + 2 * thetaCos - 2) / phiPower4 .* skewObservationAngularSpeed * skewObservationAccelerometer ...
    + (6 * theta - 8 * thetaSin + theta2Sin) / (8 * phiPower5) .* skewObservationAngularSpeed * skewObservationAccelerometer * skewObservationAngularSpeed ...
    + (2 * thetaPower2 + 8 * thetaSin + 16 * thetaCos + theta2Cos - 17) / (8 * phiPower6) .* skewObservationAngularSpeed * skewObservationAccelerometer * skewObservationAngularSpeedPower2 ...
    + (thetaPower3 + 6 * theta - 12 * thetaSin + 6 * theta * thetaCos) / (6 * phiPower5) .* skewObservationAngularSpeedPower2 * skewObservationAccelerometer ...
    + (6 * thetaPower2 + 16 * thetaCos - theta2Cos - 15) / (8 * phiPower6) .* skewObservationAngularSpeedPower2 * skewObservationAccelerometer * skewObservationAngularSpeed ...
    + (4 * thetaPower3 + 6 * theta - 24 * thetaSin - 3 * theta2Sin + 24 * theta * thetaCos) / (24 * phiPower7) .* skewObservationAngularSpeedPower2 * skewObservationAccelerometer * skewObservationAngularSpeedPower2);

end
