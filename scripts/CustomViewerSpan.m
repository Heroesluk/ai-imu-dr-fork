clearvars;
close all;
dbstop error;
% clc;
addpath(genpath(pwd));

TAG = 'CustomViewerSpan';

cSpanDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\20230301\车载数据';
cSpanDatasetRawDataFileName = '车载原始数据.DAT';

cSpanDatasetRawDataFilePath = fullfile(cSpanDatasetFolderPath,cSpanDatasetRawDataFileName);
spanRawImuData = loadSpanRawImuData(cSpanDatasetRawDataFilePath);

spanRawImuDataGpsWeek = spanRawImuData(:,1);
tblSpanRawImuDataGpsWeek = tabulate(spanRawImuDataGpsWeek);
tblSpanRawImuDataGpsWeek = sortrows(tblSpanRawImuDataGpsWeek, -2);

validGpsWeek = tblSpanRawImuDataGpsWeek(1,1);
validSpanRawImuData = spanRawImuData(spanRawImuData(:,1) == validGpsWeek,:);
validSpanRawImuDataSize = size(validSpanRawImuData,1);

[spanUtcTimeDateTime,spanUtcTimeZeroOClockTimeDateTime,spanUtcTimeZeroOClockTimePosixTime,spanTime] = convertGpsWeekWeekSecondToUtcDateTime(validSpanRawImuData(:,1),validSpanRawImuData(:,2));

headTimeDateTime = spanUtcTimeDateTime(1,1);
headTimeDateStr = datestr(headTimeDateTime,'yyyy-mm-dd HH:MM:ss.FFF');
headSpanTime = spanTime(1,1);
tailGpsWeek = validSpanRawImuData(validSpanRawImuDataSize,1);
tailGpsWeekSecond = validSpanRawImuData(validSpanRawImuDataSize,2);
tailTimeDateTime =spanUtcTimeDateTime(validSpanRawImuDataSize,1);
tailTimeDateStr = datestr(tailTimeDateTime,'yyyy-mm-dd HH:MM:ss.FFF');
tailSpanTime = spanTime(validSpanRawImuDataSize,1);
duration = tailSpanTime - headSpanTime;
logMsg = sprintf('Data log from %s to %s, duration %.3f s',headTimeDateStr,tailTimeDateStr,duration);
log2terminal('I',TAG,logMsg);

spanUtcTimeZeroOClockTimeDateStr = datestr(spanUtcTimeZeroOClockTimeDateTime(1,1),'yyyy-mm-dd HH:MM:ss.FFF');
logMsg = sprintf('Zero O''Clock clock based date: %s, time offset %f s', spanUtcTimeZeroOClockTimeDateStr,spanUtcTimeZeroOClockTimePosixTime(1,1));
log2terminal('I',TAG,logMsg);

figure;
timeReferenceSubPlotRows = 3;
timeReferenceSubPlotColumns = 1;
% https://waldyrious.net/viridis-palette-generator/
ViridisColerPalette03 = ["#fde725" "#21918c" "#440154"];
subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,1);
hold on;
plot(spanTime,validSpanRawImuData(:,3),'Color',ViridisColerPalette03(1),'DisplayName','Gyroscope X');
plot(spanTime,validSpanRawImuData(:,4),'Color',ViridisColerPalette03(2),'DisplayName','Gyroscope Y');
plot(spanTime,validSpanRawImuData(:,5),'Color',ViridisColerPalette03(3),'DisplayName','Gyroscope Z');
xlabel('Sample (s)');
ylabel('Value (°/s)');
title('SPAN raw IMU gyroscope data');
legend;
hold off;
subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,2);
hold on;
plot(spanTime,validSpanRawImuData(:,6),'Color',ViridisColerPalette03(1),'DisplayName','Accelerometer X');
plot(spanTime,validSpanRawImuData(:,7),'Color',ViridisColerPalette03(2),'DisplayName','Accelerometer Y');
plot(spanTime,validSpanRawImuData(:,8),'Color',ViridisColerPalette03(3),'DisplayName','Accelerometer Z');
xlabel('Sample (s)');
ylabel('Value (m/s^{2})');
title('SPAN raw IMU accelerometer data');
legend;
hold off;
subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,3);
plot(spanTime,validSpanRawImuData(:,9),'Color',ViridisColerPalette03(3));
xlabel('Sample (s)');
ylabel('Temperature (°C)');
title('SPAN IMU module temperature data');

spanRawImuSampleTimeInterval = spanTime(2:validSpanRawImuDataSize,1) - spanTime(1:(validSpanRawImuDataSize-1),1);
spanRawImuMeanSampleTimeInterval = mean(spanRawImuSampleTimeInterval);
spanRawImuMaxSampleTimeInterval = max(spanRawImuSampleTimeInterval);
spanRawImuMinSampleTimeInterval = min(spanRawImuSampleTimeInterval);
spanRawImuSampleRate = 1 / spanRawImuMeanSampleTimeInterval;
logMsg = sprintf('Sample interval mean %.3f s, min %.3f s, max %.3f s, estimated sample rate %.0f Hz', spanRawImuMeanSampleTimeInterval,spanRawImuMinSampleTimeInterval,spanRawImuMaxSampleTimeInterval,spanRawImuSampleRate);
log2terminal('I',TAG,logMsg);

% figure;
% plot(spanTime(1:(validSpanRawImuDataSize-1)), spanRawImuSampleTimeInterval);

cSpanDatasetPostDataFileName = 'SPAN后处理数据.csv';
cSpanDatasetPostDataFilePath = fullfile(cSpanDatasetFolderPath,'SPAN',cSpanDatasetPostDataFileName);
spanPostData = loadSpanPostData(cSpanDatasetPostDataFilePath);

plotSEPose(spanPostData);
plotSE2Pose(spanPostData);
