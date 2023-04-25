function [] = plotGroundTruthImuData(plotFlag,groundTruthImuFilePath)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明

TAG = 'plotGroundTruthImuData';

if plotFlag ~= 0
    groundTruthImuData = readmatrix(groundTruthImuFilePath);
    groundTruthImuDataSize = size(groundTruthImuData,1);

    figure;
    timeReferenceSubPlotRows = 3;
    timeReferenceSubPlotColumns = 1;
    % https://waldyrious.net/viridis-palette-generator/
    ViridisColerPalette03 = ["#fde725" "#21918c" "#440154"];
    groundTruthImuDataTime = groundTruthImuData(:,1);
    groundTruthImuGyroscopeData = groundTruthImuData(:,5:7);
    groundTruthImuAccelerometerData = groundTruthImuData(:,2:4);
    groundTruthImuTemperatureData = groundTruthImuData(:,8);
    subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,1);
    hold on;
    plot(groundTruthImuDataTime,groundTruthImuGyroscopeData(:,1),'Color',ViridisColerPalette03(1),'DisplayName','Gyroscope X');
    plot(groundTruthImuDataTime,groundTruthImuGyroscopeData(:,2),'Color',ViridisColerPalette03(2),'DisplayName','Gyroscope Y');
    plot(groundTruthImuDataTime,groundTruthImuGyroscopeData(:,3),'Color',ViridisColerPalette03(3),'DisplayName','Gyroscope Z');
    xlabel('Sample (s)');
    ylabel('Value (°/s)');
    title('Ground truth raw IMU gyroscope data');
    legend;
    hold off;
    subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,2);
    hold on;
    plot(groundTruthImuDataTime,groundTruthImuAccelerometerData(:,1),'Color',ViridisColerPalette03(1),'DisplayName','Accelerometer X');
    plot(groundTruthImuDataTime,groundTruthImuAccelerometerData(:,2),'Color',ViridisColerPalette03(2),'DisplayName','Accelerometer Y');
    plot(groundTruthImuDataTime,groundTruthImuAccelerometerData(:,3),'Color',ViridisColerPalette03(3),'DisplayName','Accelerometer Z');
    xlabel('Sample (s)');
    ylabel('Value (m/s^{2})');
    title('Ground truth raw IMU accelerometer data');
    legend;
    hold off;
    subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,3);
    plot(groundTruthImuDataTime,groundTruthImuTemperatureData,'Color',ViridisColerPalette03(3));
    xlabel('Sample (s)');
    ylabel('Temperature (°C)');
    title('groundTruth IMU module temperature data');

    groundTruthRawImuSampleTimeInterval = groundTruthImuDataTime(2:groundTruthImuDataSize,1) - groundTruthImuDataTime(1:(groundTruthImuDataSize-1),1);
    groundTruthRawImuMeanSampleTimeInterval = mean(groundTruthRawImuSampleTimeInterval);
    groundTruthRawImuMaxSampleTimeInterval = max(groundTruthRawImuSampleTimeInterval);
    groundTruthRawImuMinSampleTimeInterval = min(groundTruthRawImuSampleTimeInterval);
    groundTruthRawImuSampleRate = 1 / groundTruthRawImuMeanSampleTimeInterval;
    logMsg = sprintf('groundTruth raw IMU sample interval mean %.3f s, min %.3f s, max %.3f s, estimated sample rate %.0f Hz', groundTruthRawImuMeanSampleTimeInterval,groundTruthRawImuMinSampleTimeInterval,groundTruthRawImuMaxSampleTimeInterval,groundTruthRawImuSampleRate);
    log2terminal('I',TAG,logMsg);
end


end