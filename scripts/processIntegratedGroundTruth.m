function [] = processIntegratedGroundTruth(folderPath)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

TAG = 'processIntegratedGroundTruth';

% 加载数据
preprocessRawFlatData = loadPreprocessRawFlat(folderPath);
preprocessTime = getPreprocessTime(preprocessRawFlatData);
preprocessPhoneImuGyroscope = getPreprocessPhoneImuGyroscope(preprocessRawFlatData);
preprocessPhoneImuAccelerometer = getPreprocessPhoneImuAccelerometer(preprocessRawFlatData);
preprocessGroundTruthNavOrientation = getPreprocessGroundTruthNavOrientationRotationMatrix(preprocessRawFlatData);
preprocessGroundTruthNavVelocity = getPreprocessGroundTruthNavVelocity(preprocessRawFlatData);
preprocessGroundTruthNavPosition = getPreprocessGroundTruthNavPosition(preprocessRawFlatData);


tFilterStateCell = filterInitialization(folderPath);
saveFilterStateCell = horzcat({preprocessTime(1)},tFilterStateCell);
saveFilterState = saveFilterStateCell;

preprocessGroundTruthNavVelocityCovarianceMatrix = diag([1e-3 1e-3 1e-3]).^2;
preprocessGroundTruthNavPositionCovarianceMatrix = diag([1e-3 1e-3 1e-3]).^2;

globalHeadTime = preprocessTime(1);
globalTailTime = preprocessTime(end);
globalTimeInterval = globalTailTime - globalHeadTime;
cLogTriggerInterval = 3;
logPrevTriggerTimer = convertTo(datetime("now"),'posixtime') - cLogTriggerInterval;
filterTimeLength = size(preprocessRawFlatData,1);
for i = 2:filterTimeLength
    tFilterTime = preprocessTime(i-1);
    tMeasurementTime = preprocessTime(i);
    tDeltaTime = tMeasurementTime - tFilterTime;
    tMeasurementImuGyroscope = preprocessPhoneImuGyroscope(i-1,:);
    tMeasurementImuAccelerometer = preprocessPhoneImuAccelerometer(i-1,:);
    tMeasurementNavVelocity = preprocessGroundTruthNavVelocity(i,:);
    tMeasurementNavPosition = preprocessGroundTruthNavPosition(i,:);

    imuMeasurement = cell(1,3);
    imuMeasurement{1,1} = tDeltaTime;
    imuMeasurement{1,2} = tMeasurementImuGyroscope;
    imuMeasurement{1,3} = tMeasurementImuAccelerometer;
    tFilterStateCell = filterPropagateImuMeasurement(tFilterStateCell,imuMeasurement);

    positionMeasurement = cell(1,2);
    positionMeasurement{1,1} = tMeasurementNavPosition;
    positionMeasurement{1,2} = preprocessGroundTruthNavPositionCovarianceMatrix;
    tFilterStateCell = filterUpdatePositionMeasurement(tFilterStateCell,positionMeasurement);

    % velocityMeasurement = cell(1,2);
    % velocityMeasurement{1,1} = tMeasurementNavVelocity;
    % velocityMeasurement{1,2} = preprocessGroundTruthNavVelocityCovarianceMatrix;
    % tFilterStateCell = filterUpdateVelocityMeasurement(tFilterStateCell,velocityMeasurement);

    saveFilterStateCell = horzcat({tMeasurementTime},tFilterStateCell);
    saveFilterState = vertcat(saveFilterState,saveFilterStateCell);

    logCheckTime = convertTo(datetime("now"),'posixtime');
    if (logCheckTime - logPrevTriggerTimer) > cLogTriggerInterval
        logMsg = sprintf('filter time: %.3f s (%.3f | %.2f %%)',tFilterTime,globalTailTime,(tFilterTime-globalHeadTime)/globalTimeInterval*100);
        log2terminal('I',TAG,logMsg);
        logPrevTriggerTimer = logCheckTime;
    end

end

saveFilterStateIntegratedGroundTruth(folderPath,saveFilterState);
