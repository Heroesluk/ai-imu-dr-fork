function [] = plotComparedResampledData(plotFlag,resampleDataTime,resampledGroundTruthData,resampledTestData)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明

TAG = 'plotComparedResampledData';

if plotFlag ~= 0
    resampleDataTimeSize = size(resampleDataTime,1);

    figure;
    timeReferenceSubPlotRows = 2;
    timeReferenceSubPlotColumns = 1;
    groundTruthImuDataTime = resampleDataTime;
    pXLim = [groundTruthImuDataTime(1) groundTruthImuDataTime(resampleDataTimeSize)];
    % https://waldyrious.net/viridis-palette-generator/
    ViridisColerPalette03 = ["#fde725" "#21918c" "#440154"];
    subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,1);
    groundTruthImuAccelerometerData = resampledGroundTruthData;
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
    smartPhoneSensorAccelerometerDataTime = resampleDataTime;
    smartPhoneSensorAccelerometerData = resampledTestData;
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