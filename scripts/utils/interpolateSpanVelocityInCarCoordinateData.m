function interpolatedSpanVelocityInCarCoordinateData = interpolateSpanVelocityInCarCoordinateData(spanRawData,resampledTime)

addpath(genpath(pwd));
TAG = 'interpolateSpanVelocityInCarCoordinateData';

t1DateTime = datetime('now');
t1DateStr = string(t1DateTime,'yyyy-MM-dd HH:mm:ss.SSS');
logMsg = sprintf('Interpolate span data start time %s',t1DateStr);
log2terminal('I',TAG,logMsg);

sampledTime = spanRawData(:,1);
sampledTimeSize = size(sampledTime,1);

spanRawDataVelocityInCarCoordinate = zeros(sampledTimeSize,3);
for i = 1:sampledTimeSize
    rx = deg2rad(spanRawData(i,8)); % pitch
    ry = deg2rad(spanRawData(i,9)); % roll
    rz = deg2rad(-spanRawData(i,10)); % heading
    Rx = [1        0       0;
        0  cos(rx) sin(rx);
        0 -sin(rx) cos(rx)];
    Ry = [cos(ry) 0 -sin(ry);
        0 1 0;
        sin(ry) 0 cos(ry)];
    Rz = [cos(rz) sin(rz) 0;
        -sin(rz) cos(rz) 0;
        0 0 1];
    R = Ry*Rx*Rz;

    velocityInWorldCoordinate = spanRawData(i,5:7);
    velocityInCarCoordinate = R * velocityInWorldCoordinate';
    spanRawDataVelocityInCarCoordinate(i,1:3) = velocityInCarCoordinate;
end

resampledVelocityInCarCoordinate = interp1(sampledTime,spanRawDataVelocityInCarCoordinate,resampledTime);

interpolatedSpanVelocityInCarCoordinateData = resampledVelocityInCarCoordinate;

t2DateTime = datetime('now');
dt = t2DateTime - t1DateTime;
dtSecond = seconds(dt);
t2DateStr = string(t2DateTime,'yyyy-MM-dd HH:mm:ss.SSS');
logMsg = sprintf('Interpolate end time %s',t2DateStr);
log2terminal('I',TAG,logMsg);
logMsg = sprintf('Interpolate span data time spent %.0f s',dtSecond);
log2terminal('I',TAG,logMsg);

end

