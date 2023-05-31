function interpolatedSpanData = interpolateSpanRawData(spanRawData,resampledTime)

addpath(genpath(pwd));
TAG = 'interpolateSpanRawData';

t1DateTime = datetime('now');
t1DateStr = string(t1DateTime,'yyyy-MM-dd HH:mm:ss.SSS');
logMsg = sprintf('Interpolate start time %s',t1DateStr);
log2terminal('I',TAG,logMsg);

sampledTime = spanRawData(:,1);
sampledTimeSize = size(sampledTime,1);
sampledTimeSection = zeros(sampledTimeSize-1,2);
sampledTimeSection(:,1) = sampledTime(1:(sampledTimeSize-1),1);
sampledTimeSection(:,2) = sampledTime(2:sampledTimeSize,1);

resampledTimeSize = size(resampledTime,1);
resampledTimeMapInterpolationSection = zeros(resampledTimeSize,7);
resampledTimeMapInterpolationSection(:,1) = resampledTime;
for i = 1:resampledTimeSize
    resampledTimeMapSectionLowerBound = resampledTime(i,1)>sampledTimeSection(:,1);
    resampledTimeMapSectionUpperBound = resampledTime(i,1)<=sampledTimeSection(:,2);
    resampledTimeMapSectionBoundIndex = resampledTimeMapSectionLowerBound == resampledTimeMapSectionUpperBound;
    resampledTimeMapInterpolationSection(i,2) = find(resampledTimeMapSectionBoundIndex == 1);
    resampledTimeMapInterpolationSection(i,3:4) = sampledTimeSection(resampledTimeMapSectionBoundIndex,1:2);
end
resampledTimeMapInterpolationSection(:,5) = resampledTimeMapInterpolationSection(:,1) - resampledTimeMapInterpolationSection(:,3);
resampledTimeMapInterpolationSection(:,6) = resampledTimeMapInterpolationSection(:,4) - resampledTimeMapInterpolationSection(:,3);
resampledTimeMapInterpolationSection(:,7) = resampledTimeMapInterpolationSection(:,5) ./ resampledTimeMapInterpolationSection(:,6);

% compute scale from first lat value
scale = latToScale(spanRawData(1,2));

referenceTransition = [];
parsedSampledRotation = zeros(3,3,sampledTimeSize);
parsedSampledTranslation = zeros(sampledTimeSize,3);
parsedSampledVelocity = spanRawData(:,5:7);
for i = 1:sampledTimeSize
    [t(1,1),t(2,1)] = latlonToMercator(spanRawData(i,2),spanRawData(i,3),scale);
    t(3,1) = spanRawData(i,4);
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

    % normalize translation and rotation (start at 0/0/0)
    if isempty(referenceTransition)
        referenceTransition = t;
    end

    parsedSampledRotation(1:3,1:3,i) = R';
    parsedSampledTranslation(i,1:3) = t-referenceTransition;
end
parsedSampledQuaternion = quaternion(parsedSampledRotation,'rotmat','frame');
resampledTranslation = interp1(sampledTime,parsedSampledTranslation,resampledTime);
resampledTranslation = resampledTranslation - resampledTranslation(1,1:3);
resampledVelocity = interp1(sampledTime,parsedSampledVelocity,resampledTime);
resampledPoseMatrix = zeros(resampledTimeSize,15);
for i = 1:resampledTimeSize
    interpolationSectionLowerBoundIndex = resampledTimeMapInterpolationSection(i,2);
    interpolationSectionUpperBoundIndex = interpolationSectionLowerBoundIndex + 1;
    interpolationCoefficient = resampledTimeMapInterpolationSection(i,7);
    interpolationSectionLowerBound = parsedSampledQuaternion(interpolationSectionLowerBoundIndex,1);
    interpolationSectionUpperBound = parsedSampledQuaternion(interpolationSectionUpperBoundIndex,1);
    interpolationQuaternion = slerp(interpolationSectionLowerBound,interpolationSectionUpperBound,interpolationCoefficient);
    interpolationRotationMatrix = rotmat(interpolationQuaternion,'frame');

    resampledPoseMatrix(i,1:3) = interpolationRotationMatrix(1,1:3);
    resampledPoseMatrix(i,4:6) = interpolationRotationMatrix(2,1:3);
    resampledPoseMatrix(i,7:9) = interpolationRotationMatrix(3,1:3);
end
resampledPoseMatrix(:,10:12) = resampledTranslation;
resampledPoseMatrix(:,13:15) = resampledVelocity;

interpolatedSpanData = resampledPoseMatrix;

t2DateTime = datetime('now');
dt = t2DateTime - t1DateTime;
dtSecond = seconds(dt);
t2DateStr = string(t2DateTime,'yyyy-MM-dd HH:mm:ss.SSS');
logMsg = sprintf('Interpolate end time %s',t2DateStr);
log2terminal('I',TAG,logMsg);
logMsg = sprintf('Interpolate time spent %.0f s',dtSecond);
log2terminal('I',TAG,logMsg);

end

