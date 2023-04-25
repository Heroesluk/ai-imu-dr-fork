function [] = plotComparedImuData(plotFlag,groundTruthImuData,smartPhoneGyroscopeData,smartPhoneAccelerometerData)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明

TAG = 'plotGroundTruthImuData';

if plotFlag ~= 0
    groundTruthImuDataSize = size(groundTruthImuData,1);

    figure;
    timeReferenceSubPlotRows = 2;
    timeReferenceSubPlotColumns = 1;
    groundTruthImuDataTime = groundTruthImuData(:,1);
    pXLim = [groundTruthImuDataTime(1) groundTruthImuDataTime(groundTruthImuDataSize)];
    % https://waldyrious.net/viridis-palette-generator/
    ViridisColerPalette03 = ["#fde725" "#21918c" "#440154"];
    subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,1);
    groundTruthImuAccelerometerData = groundTruthImuData(:,2:4);
    hold on;
    plot(groundTruthImuDataTime,groundTruthImuAccelerometerData(:,1),'Color',ViridisColerPalette03(1),'DisplayName','Accelerometer X');
    plot(groundTruthImuDataTime,groundTruthImuAccelerometerData(:,2),'Color',ViridisColerPalette03(2),'DisplayName','Accelerometer Y');
    plot(groundTruthImuDataTime,groundTruthImuAccelerometerData(:,3),'Color',ViridisColerPalette03(3),'DisplayName','Accelerometer Z');
    xlim(pXLim);
    xlabel('Sample (s)');
    ylabel('Value (m/s^{2})');
    title('Ground truth raw IMU accelerometer data');
    legend;
    hold off;
    subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,2);
    smartPhoneSensorAccelerometerDataTime = smartPhoneAccelerometerData(:,2);
    smartPhoneSensorAccelerometerData = smartPhoneAccelerometerData(:,4:6);
    hold on;
    plot(smartPhoneSensorAccelerometerDataTime,smartPhoneSensorAccelerometerData(:,1),'Color',ViridisColerPalette03(1),'DisplayName','Accelerometer X');
    plot(smartPhoneSensorAccelerometerDataTime,smartPhoneSensorAccelerometerData(:,2),'Color',ViridisColerPalette03(2),'DisplayName','Accelerometer Y');
    plot(smartPhoneSensorAccelerometerDataTime,smartPhoneSensorAccelerometerData(:,3),'Color',ViridisColerPalette03(3),'DisplayName','Accelerometer Z');
    xlim(pXLim);
    xlabel('Sample (s)');
    ylabel('Value (m/s^{2})');
    title('Smart Phone raw IMU accelerometer data');
    legend;
    hold off;

    dcm_obj = datacursormode(gcf);
    set(dcm_obj,'UpdateFcn',@customDataTipFunction)

end


end