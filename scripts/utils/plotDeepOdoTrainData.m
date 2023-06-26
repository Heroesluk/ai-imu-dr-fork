function [] = plotDeepOdoTrainData(plotFlag,resampleDataTime,resampledGroundTruthData,deepOdoTrainData)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明

TAG = 'plotDeepOdoTrainData';

if plotFlag ~= 0
    resampleDataTimeSize = size(resampleDataTime,1);

    figure;
    timeReferenceSubPlotRows = 5;
    timeReferenceSubPlotColumns = 1;
    groundTruthImuDataTime = resampleDataTime;
    pXLim = [groundTruthImuDataTime(1) groundTruthImuDataTime(resampleDataTimeSize)];
    % https://waldyrious.net/viridis-palette-generator/
    ViridisColerPalette03 = ["#fde725" "#21918c" "#440154"];
    subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,1);
    smartPhoneSensorGyroscopeDataTime = resampleDataTime;
    smartPhoneSensorGyroscopeData = deepOdoTrainData(:,2:4);
    hold on;
    plot(smartPhoneSensorGyroscopeDataTime,smartPhoneSensorGyroscopeData(:,1),'Color',ViridisColerPalette03(1),'DisplayName','Gyroscope X');
    plot(smartPhoneSensorGyroscopeDataTime,smartPhoneSensorGyroscopeData(:,2),'Color',ViridisColerPalette03(2),'DisplayName','Gyroscope Y');
    plot(smartPhoneSensorGyroscopeDataTime,smartPhoneSensorGyroscopeData(:,3),'Color',ViridisColerPalette03(3),'DisplayName','Gyroscope Z');
    xlim(pXLim);
    xlabel('Sample (s)');
    ylabel('Value (rad/s)');
    title('Ground truth raw IMU gyroscope data');
    legend;
    hold off;
    subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,2);
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
    subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,3);
    smartPhoneSensorAccelerometerDataTime = resampleDataTime;
    smartPhoneSensorAccelerometerData = deepOdoTrainData(:,5:7);
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
    subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,4);
    smartPhoneSensorPressureDataTime = resampleDataTime;
    smartPhoneSensorPressureData = deepOdoTrainData(:,8);
    hold on;
    plot(smartPhoneSensorPressureDataTime,smartPhoneSensorPressureData(:,1),'Color','k');
    xlim(pXLim);
    xlabel('Sample (s)');
    ylabel('Value (hPa)');
    title('Smart phone pressure data');
    legend;
    hold off;
    subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,5);
    deepOdoTrainDataTime = resampleDataTime;
    deepOdoTrainDataVelocity = deepOdoTrainData(:,9);
    hold on;
    plot(deepOdoTrainDataTime,deepOdoTrainDataVelocity(:,1),'Color','b');
    xlim(pXLim);
    xlabel('Sample (s)');
    ylabel('Value (m/s)');
    title('Ground truth car velocity data');
    legend;
    hold off;

    dcm_obj = datacursormode(gcf);
    set(dcm_obj,'UpdateFcn',@customDataTipFunction)

end


end