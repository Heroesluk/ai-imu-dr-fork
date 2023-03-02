% close all;
clear;
addpath(genpath(pwd));

S2MS = 1e3;
MS2S = 1/S2MS;
S2NS = 1e9;
NS2S = 1/S2NS;
MS2NS = 1e6;
NS2MS = 1/MS2NS;
US2NS = 1e3;
NS2US = 1/US2NS;

LEAPSECOND = 18;
LEAPNANOSECOND = LEAPSECOND * S2NS;

TAG = 'CompareReference';

COM_NUM = 2;


cReferenceDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_02_28\REF\CoSLAM-2023-02-28-19-37-48';
% cReferenceDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_02_28\REF\CoSLAM-2023-02-28-19-21-39';
cReferenceDatasetImuFileName = 'imu_data.txt';
cReferenceDatasetImuFilePath = fullfile(cReferenceDatasetFolderPath,cReferenceDatasetImuFileName);
referenceImuData = loadCoSlamImuData(cReferenceDatasetImuFilePath,1);
referenceImuTime = referenceImuData{1,1};
referenceImuDataSize = size(referenceImuTime,1);
[referenceZeroOClockDateTime, referenceZeroOClockClockOffset] = getUtcTimeMapZeroOClockTime(referenceImuTime(1,1));
zReferenceImuTime = referenceImuTime - referenceZeroOClockClockOffset;
referenceImuAccelerometerData = cat(2,referenceImuData{1,2},referenceImuData{1,3},referenceImuData{1,4});


cDatasetFolderPath2 = 'C:\Users\QIAN LONG\Downloads\2023_02_28\HUAWEI\0020';
% cDatasetFolderPath2 = 'C:\Users\QIAN LONG\Downloads\2023_02_28\SAMSUNG\0020';
% cDatasetFolderPath2 = 'C:\Users\QIAN LONG\Downloads\2023_02_28\PIXEL\0020';
kRawFolderName = 'raw';
kMotionSensorAccelerometerUncalibratedFileName = 'MotionSensorAccelerometerUncalibrated.csv';
motionSensorAccelerometerUncalibratedFilePath = fullfile(cDatasetFolderPath2,kRawFolderName,kMotionSensorAccelerometerUncalibratedFileName);
motionSensorAccelerometerUncalibratedRawData = readmatrix(motionSensorAccelerometerUncalibratedFilePath);
motionSensorAccelerometerUncalibratedDataSize = size(motionSensorAccelerometerUncalibratedRawData,1);
bootTimeGnssClock = motionSensorAccelerometerUncalibratedRawData(:,3);
sensorEventTime = motionSensorAccelerometerUncalibratedRawData(:,4);
[referenceZeroOClockDateTimeFromGnssClock, referenceZeroOClockFromGnssClockOffset] = getGnssClockGpsTimeMapZeroOClockTime(bootTimeGnssClock(1,1));
referenceZeroOClockLeapseconds = getZeroOClockTimeGpsTimeLeapseconds(referenceZeroOClockDateTimeFromGnssClock);
zBootTimeGpsClock = bootTimeGnssClock - referenceZeroOClockFromGnssClockOffset * S2NS - referenceZeroOClockLeapseconds * S2NS;
zEventTimeGnssClock = (zBootTimeGpsClock + sensorEventTime) * NS2S;
sensorAccelerometerData = motionSensorAccelerometerUncalibratedRawData(:,[5 6 7]);


intersectionHeadTime = max(zReferenceImuTime(1,1),zEventTimeGnssClock(1,1));
intersectionTailTime = min(zReferenceImuTime(referenceImuDataSize,1),zEventTimeGnssClock(motionSensorAccelerometerUncalibratedDataSize,1));

resampleHeadTime = ceil(intersectionHeadTime);
resampleTailTime = floor(intersectionTailTime);

resampleRate = 200;
resampleInterval = 1 / resampleRate;
resampleTimeSeries = resampleHeadTime:resampleInterval:resampleTailTime;

resampledReferenceImuAccelerometerData = interp1(zReferenceImuTime,referenceImuAccelerometerData,resampleTimeSeries);
resampledSensorAccelerometerData = interp1(zEventTimeGnssClock,sensorAccelerometerData,resampleTimeSeries);

clippedTime = [41950.000 42150.000];
clippedTimeIndex = find(resampleTimeSeries>=clippedTime(1)&resampleTimeSeries<=clippedTime(2));
% clippedDataX = resampledReferenceImuAccelerometerData(clippedTimeIndex,3) - 9.8;
% clippedDataY = resampledSensorAccelerometerData(clippedTimeIndex,3) - 9.8;
clippedDataX = resampledReferenceImuAccelerometerData(clippedTimeIndex,2);
clippedDataY = resampledSensorAccelerometerData(clippedTimeIndex,2);
[clippedDataR,clippedDataLags] = xcorr(clippedDataY(:,1),clippedDataX(:,1),'normalized');
figure;
stem(clippedDataLags,clippedDataR);

intersectionLim = [intersectionHeadTime intersectionTailTime];
figure;
timeReferenceSubPlotRows = 2;
timeReferenceSubPlotColumns = 1;
subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,1);
plot(resampleTimeSeries,resampledReferenceImuAccelerometerData);
% xlim(intersectionLim);
ax = gca;
ax.XAxis.Exponent = 0;

subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,2);
plot(resampleTimeSeries,resampledSensorAccelerometerData);
ax = gca;
ax.XAxis.Exponent = 0;
% xlim(intersectionLim);

dcm_obj = datacursormode(gcf);
set(dcm_obj,'UpdateFcn',@customDataTipFunction)


