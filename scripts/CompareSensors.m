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

TAG = 'CompareSensors';

COM_NUM = 2;

% cDatasetFolderPath1 = 'C:\Users\QIAN LONG\Downloads\2023_02_22\0010';
% cDatasetFolderPath2 = 'C:\Users\QIAN LONG\Downloads\2023_02_22\Pixel\0010';

cDatasetFolderPath1 = 'C:\Users\QIAN LONG\Downloads\2023_02_28\HUAWEI\0010';
cDatasetFolderPath2 = 'C:\Users\QIAN LONG\Downloads\2023_02_28\PIXEL\0010';

cDatasetContainerList = cell(COM_NUM,6);
cDatasetContainerList{1,1} = cDatasetFolderPath1;
cDatasetContainerList{2,1} = cDatasetFolderPath2;

kRawFolderName = 'raw';

kMotionSensorAccelerometerUncalibratedFileName = 'MotionSensorAccelerometerUncalibrated.csv';

for i = 1:COM_NUM
    datasetFolderPath = cDatasetContainerList{i,1};
    motionSensorAccelerometerUncalibratedFilePath = fullfile(datasetFolderPath,kRawFolderName,kMotionSensorAccelerometerUncalibratedFileName);
    motionSensorAccelerometerUncalibratedRawData = readmatrix(motionSensorAccelerometerUncalibratedFilePath);
    N = length(motionSensorAccelerometerUncalibratedRawData);
    bootTimeGnssClock = motionSensorAccelerometerUncalibratedRawData(:,3);
    sensorEventTime = motionSensorAccelerometerUncalibratedRawData(:,4);
    [referenceZeroOClockDateTimeFromGnssClock, referenceZeroOClockFromGnssClockOffset] = getGnssClockGpsTimeMapZeroOClockTime(bootTimeGnssClock(1,1));
    referenceZeroOClockLeapseconds = getZeroOClockTimeGpsTimeLeapseconds(referenceZeroOClockDateTimeFromGnssClock);
    zBootTimeGpsClock = bootTimeGnssClock - referenceZeroOClockFromGnssClockOffset * S2NS - referenceZeroOClockLeapseconds * S2NS;
    zEventTimeGnssClock = zBootTimeGpsClock + sensorEventTime;

    systemTime = motionSensorAccelerometerUncalibratedRawData(:,1);
    systemClockTime = motionSensorAccelerometerUncalibratedRawData(:,2);
    [referenceZeroOClockDateTimeFromSystemClock, referenceZeroOClockFromSystemClockOffset] = getSystemCurrentTimeMillisMapZeroOClockTime(systemTime(1,1));
    zSystemTime = systemTime - referenceZeroOClockFromSystemClockOffset * S2MS;
    sensorEventTimeStampMinusElapsedRealtimeNanos = sensorEventTime - systemClockTime;
    zEventTimeSystemClock = zSystemTime * MS2NS + sensorEventTimeStampMinusElapsedRealtimeNanos;

    cDatasetContainerList{i,2} = zEventTimeGnssClock;
    cDatasetContainerList{i,3} = motionSensorAccelerometerUncalibratedRawData(:,[5 6 7]);
    cDatasetContainerList{i,4} = cDatasetContainerList{i,2}(1,1)*NS2S;
    cDatasetContainerList{i,5} = cDatasetContainerList{i,2}(N,1)*NS2S;
    logMsg = sprintf('sensor log head time: %.9f s, tail time: %.9f s',cDatasetContainerList{i,4},cDatasetContainerList{i,5});
    log2terminal('I',TAG,logMsg);
end

intersectionHeadTime = max(cell2mat(cDatasetContainerList(:,4)));
intersectionTailTime = min(cell2mat(cDatasetContainerList(:,5)));

resampleHeadTime = ceil(intersectionHeadTime);
resampleTailTime = floor(intersectionTailTime);

resampleRate = 200;
resampleInterval = 1 / resampleRate;
resampleTimeSeries = resampleHeadTime:resampleInterval:resampleTailTime;

for i = 1:COM_NUM
    resampledData = interp1(cDatasetContainerList{i,2}*NS2S,cDatasetContainerList{i,3},resampleTimeSeries);
    cDatasetContainerList{i,6} = resampledData;
end

figure;
timeReferenceSubPlotRows = 2;
timeReferenceSubPlotColumns = 1;
subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,1);
plot(cDatasetContainerList{1,6});
subplot(timeReferenceSubPlotRows,timeReferenceSubPlotColumns,2);
plot(cDatasetContainerList{2,6});



