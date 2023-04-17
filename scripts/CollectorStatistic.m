close all;
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

TAG = 'CustomViewerGnssViewer';

% cDatasetFolderPath = 'C:\DoctorRelated\20230410重庆VDR数据采集\2023_04_10\HUAWEI_Mate30';
% cDatasetFolderPath = 'C:\DoctorRelated\20230410重庆VDR数据采集\2023_04_11\HUAWEI_Mate30';
% cDatasetFolderPath = 'C:\DoctorRelated\20230410重庆VDR数据采集\2023_04_11\HUAWEI_P20';
% cDatasetFolderPath = 'C:\DoctorRelated\20230410重庆VDR数据采集\2023_04_11\GOOGLE_Pixel3';
cDatasetFolderPath = 'C:\DoctorRelated\20230410重庆VDR数据采集\2023_04_13\HUAWEI_Mate30';
% cDatasetFolderPath = 'C:\DoctorRelated\20230410重庆VDR数据采集\2023_04_13\HUAWEI_P20';
% cDatasetFolderPath = 'C:\DoctorRelated\20230410重庆VDR数据采集\2023_04_13\GOOGLE_Pixel3';

kRawFolderName = 'raw';
kMotionSensorAccelerometerUncalibratedFileName = 'MotionSensorAccelerometerUncalibrated.csv';

if exist(cDatasetFolderPath,'dir')
    
    datasetDir = dir(cDatasetFolderPath);
    datasetDirLength = length(datasetDir);
    collectorStatisticCell = cell(datasetDirLength, 6);
    for i = 1 : datasetDirLength
        trackFolderNameStr = datasetDir(i).name;
        trackFolderPath = fullfile(cDatasetFolderPath,trackFolderNameStr);
        if ~strcmp(trackFolderNameStr,'.') && ~strcmp(trackFolderNameStr,'..') && isfolder(trackFolderPath)
            trackMotionSensorAccelerometerUncalibratedFilePath = fullfile(trackFolderPath,kRawFolderName,kMotionSensorAccelerometerUncalibratedFileName);
            trackMotionSensorAccelerometerUncalibratedRawData = readmatrix(trackMotionSensorAccelerometerUncalibratedFilePath);
            N = length(trackMotionSensorAccelerometerUncalibratedRawData);
            
            
            
            collectorStatisticCell{i,1} = trackFolderNameStr;
            collectorStatisticCell{i,2} = trackMotionSensorAccelerometerUncalibratedRawData(1,1);
            collectorStatisticCell{i,3} = trackMotionSensorAccelerometerUncalibratedRawData(N,1);
            collectorStatisticCell{i,4} = (collectorStatisticCell{i,3} - collectorStatisticCell{i,2}) * MS2S;
        end
    end
end

trackDurationStatistic = cell2mat(collectorStatisticCell(:,4));
trackTotalSecondsVaule = sum(trackDurationStatistic);
collectorStatisticCell{2,4} = trackTotalSecondsVaule;
trackTotalSeconds = seconds(trackTotalSecondsVaule);
[trackTotalHour,trackTotalMinute,trackTotalSecond] = hms(trackTotalSeconds);
collectorStatisticCell{1,4} = sprintf('%1uh %02um %02.0fs',trackTotalHour,trackTotalMinute,trackTotalSecond);

cStatisticFileName = 'BasicStatistic.csv';
cStatisticFilePath = fullfile(cDatasetFolderPath,cStatisticFileName);
writecell(collectorStatisticCell,cStatisticFilePath);


