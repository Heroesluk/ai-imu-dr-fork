function interpolatedPose = interpolatePose(pose,sampledTime,resampledTime)

addpath(genpath(pwd));
TAG = 'interpolatePose';

t1DateTime = datetime('now');
t1DateStr = datestr(t1DateTime,'yyyy-mm-dd HH:MM:ss.FFF');
logMsg = sprintf('Start time %s',t1DateStr);
log2terminal('I',TAG,logMsg);

sampledTimeSize = size(sampledTime,1);


sampledTimeSection = zeros(sampledTimeSize-1,2);
sampledTimeSection(:,1) = sampledTime(1:(sampledTimeSize-1),1);
sampledTimeSection(:,2) = sampledTime(2:sampledTimeSize,1);
resampledTimeSize = size(resampledTime,1);
resampledTimeMapInterpolationSection = zeros(resampledTimeSize,7);
resampledTimeMapInterpolationSection(:,1) = resampledTime;
resampledTimeMapInterpolationSection(1,2) = 1;
resampledTimeMapInterpolationSection(1,3:4) = sampledTimeSection(1,1:2);
for i = 2:resampledTimeSize
    resampledTimeMapSectionLowerBound = resampledTime(i,1)>sampledTimeSection(:,1);
    resampledTimeMapSectionUpperBound = resampledTime(i,1)<=sampledTimeSection(:,2);
    resampledTimeMapSectionBoundIndex = resampledTimeMapSectionLowerBound == resampledTimeMapSectionUpperBound;
    resampledTimeMapInterpolationSection(i,2) = find(resampledTimeMapSectionBoundIndex == 1);
    resampledTimeMapInterpolationSection(i,3:4) = sampledTimeSection(resampledTimeMapSectionBoundIndex,1:2);
end
resampledTimeMapInterpolationSection(:,5) = resampledTimeMapInterpolationSection(:,1) - resampledTimeMapInterpolationSection(:,3);
resampledTimeMapInterpolationSection(:,6) = resampledTimeMapInterpolationSection(:,4) - resampledTimeMapInterpolationSection(:,3);
resampledTimeMapInterpolationSection(:,7) = resampledTimeMapInterpolationSection(:,5) ./ resampledTimeMapInterpolationSection(:,6);


parsedSampledRotation = zeros(3,3,sampledTimeSize);
parsedSampledTranslation = zeros(sampledTimeSize,3);
for i = 1:sampledTimeSize
    parsedSampledRotation(1:3,1:3,i) = pose{i}(1:3,1:3);
    parsedSampledTranslation(i,1:3) = (pose{i}(1:3,4))';
end
parsedSampledQuaternion = quaternion(parsedSampledRotation,'rotmat','frame');
resampledTranslation = interp1(sampledTime,parsedSampledTranslation,resampledTime);
resampledPoseMatrix = zeros(4,4,resampledTimeSize);
resampledPoseCell = cell(resampledTimeSize,1);
for i = 1:resampledTimeSize
    interpolationSectionLowerBoundIndex = resampledTimeMapInterpolationSection(i,2);
    interpolationSectionUpperBoundIndex = interpolationSectionLowerBoundIndex + 1;
    interpolationCoefficient = resampledTimeMapInterpolationSection(i,7);
    interpolationSectionLowerBound = parsedSampledQuaternion(interpolationSectionLowerBoundIndex,1);
    interpolationSectionUpperBound = parsedSampledQuaternion(interpolationSectionUpperBoundIndex,1);
    interpolationQuaternion = slerp(interpolationSectionLowerBound,interpolationSectionUpperBound,interpolationCoefficient);
    interpolationRotationMatrix = rotmat(interpolationQuaternion,'frame');
    interpolationPose = [interpolationRotationMatrix resampledTranslation(i,1:3)'; zeros(1,3) 1];
    resampledPoseMatrix(1:4,1:4,i) = interpolationPose;
    resampledPoseCell{i,1} = interpolationPose;
end

interpolatedPose = resampledPoseCell;

t2DateTime = datetime('now');
dt = t2DateTime - t1DateTime;
dtSecond = seconds(dt);
t2DateStr = datestr(t2DateTime,'yyyy-mm-dd HH:MM:ss.FFF');
logMsg = sprintf('End time %s',t2DateStr);
log2terminal('I',TAG,logMsg);
logMsg = sprintf('Time spent %.0f s',dtSecond);
log2terminal('I',TAG,logMsg);

end

