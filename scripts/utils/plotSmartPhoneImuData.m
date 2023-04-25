function [] = plotSmartPhoneImuData(plotFlag,smartPhoneImuGyroscopeFilePath,smartPhoneImuAccelerometerFilePath)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明

TAG = 'plotSmartPhoneImuData';

if plotFlag ~= 0
    smartPhoneImuGyroscopeData = readmatrix(smartPhoneImuGyroscopeFilePath);
    smartPhoneImuAccelerometerData = readmatrix(smartPhoneImuAccelerometerFilePath);

    figure;
    timeReferenceSubPlotRows = 2;
    timeReferenceSubPlotColumns = 1;
    % https://waldyrious.net/viridis-palette-generator/
    ViridisColerPalette03 = ["#fde725" "#21918c" "#440154"];
    pSmartPhoneImuGyroscopeDataTime = smartPhoneImuGyroscopeData(:,2);
    pSmartPhoneImuGyroscopeData = smartPhoneImuGyroscopeData(:,4:6);
    pSmartPhoneImuAccelerometerDataTime = smartPhoneImuAccelerometerData(:,2);
    pSmartPhoneImuAccelerometerData = smartPhoneImuAccelerometerData(:,4:6);
    subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,1);
    hold on;
    plot(pSmartPhoneImuGyroscopeDataTime,pSmartPhoneImuGyroscopeData(:,1),'Color',ViridisColerPalette03(1),'DisplayName','Gyroscope X');
    plot(pSmartPhoneImuGyroscopeDataTime,pSmartPhoneImuGyroscopeData(:,2),'Color',ViridisColerPalette03(2),'DisplayName','Gyroscope Y');
    plot(pSmartPhoneImuGyroscopeDataTime,pSmartPhoneImuGyroscopeData(:,3),'Color',ViridisColerPalette03(3),'DisplayName','Gyroscope Z');
    xlabel('Sample (s)');
    ylabel('Value (rad/s)');
    title('Smart Phone raw IMU gyroscope data');
    legend;
    hold off;
    subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,2);
    hold on;
    plot(pSmartPhoneImuAccelerometerDataTime,pSmartPhoneImuAccelerometerData(:,1),'Color',ViridisColerPalette03(1),'DisplayName','Accelerometer X');
    plot(pSmartPhoneImuAccelerometerDataTime,pSmartPhoneImuAccelerometerData(:,2),'Color',ViridisColerPalette03(2),'DisplayName','Accelerometer Y');
    plot(pSmartPhoneImuAccelerometerDataTime,pSmartPhoneImuAccelerometerData(:,3),'Color',ViridisColerPalette03(3),'DisplayName','Accelerometer Z');
    xlabel('Sample (s)');
    ylabel('Value (m/s^{2})');
    title('Smart Phone raw IMU accelerometer data');
    legend;
    hold off;
end


end