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

TAG = 'ValidateBatchTrackData';
kRawFolderName = 'raw';
kMotionSensorAccelerometerFileNameChar = 'MotionSensorAccelerometer.csv';
kMotionSensorAccelerometerFileNameString = string(kMotionSensorAccelerometerFileNameChar);
kMotionSensorAccelerometerUncalibratedFileNameChar = 'MotionSensorAccelerometerUncalibrated.csv';
kMotionSensorAccelerometerUncalibratedFileNameString = string(kMotionSensorAccelerometerUncalibratedFileNameChar);
kMotionSensorGyroscopeFileNameChar = 'MotionSensorGyroscope.csv';
kMotionSensorGyroscopeFileNameString = string(kMotionSensorGyroscopeFileNameChar);
kMotionSensorGyroscopeUncalibratedFileNameChar = 'MotionSensorGyroscopeUncalibrated.csv';
kMotionSensorGyroscopeUncalibratedFileNameString = string(kMotionSensorGyroscopeUncalibratedFileNameChar);
kPositionSensorMagneticFieldFileNameChar = 'PositionSensorMagneticField.csv';
kPositionSensorMagneticFieldFileNameString = string(kPositionSensorMagneticFieldFileNameChar);
kPositionSensorMagneticFieldUncalibratedFileNameChar = 'PositionSensorMagneticFieldUncalibrated.csv';
kPositionSensorMagneticFieldUncalibratedFileNameString = string(kPositionSensorMagneticFieldUncalibratedFileNameChar);
kPositionSensorGameRotationVectorFileNameChar = 'PositionSensorGameRotationVector.csv';
kPositionSensorGameRotationVectorFileNameString = string(kPositionSensorGameRotationVectorFileNameChar);
kGnssLocationFileNameChar = 'GnssLocation.csv';
kGnssLocationFileNameString = string(kGnssLocationFileNameChar);
kGnssMeasurementFileNameChar = 'GnssMeasurement.csv';
kGnssMeasurementFileNameString = string(kGnssMeasurementFileNameChar);
kValidateSensorFileList = horzcat(kMotionSensorAccelerometerFileNameString,...
    kMotionSensorAccelerometerUncalibratedFileNameString,...
    kMotionSensorGyroscopeFileNameString,...
    kMotionSensorGyroscopeUncalibratedFileNameString,...
    kPositionSensorMagneticFieldFileNameString,...
    kPositionSensorMagneticFieldUncalibratedFileNameString,...
    kPositionSensorGameRotationVectorFileNameString,...
    kGnssLocationFileNameString,...
    kGnssMeasurementFileNameString);
kValidateSensorFileListLength = length(kValidateSensorFileList);

cPhoneMapNumber = ["GOOGLE_Pixel3" "HUAWEI_Mate30"];
% cPhoneMapNumber = ["GOOGLE_Pixel3" "HUAWEI_Mate30" "HUAWEI_P20"];
kPhoneMapNumberLength = length(cPhoneMapNumber);

% cDatasetFolderPath = 'C:\DoctorRelated\20230410重庆VDR数据采集';
cDatasetFolderPath = 'E:\DoctorRelated\20230410重庆VDR数据采集';
cDatasetCollectionDate = '2023_04_10';
cReorganizedFolderName = 'Reorganized';
cReorganizedFolderPath = fullfile(cDatasetFolderPath,cDatasetCollectionDate,cReorganizedFolderName);
cReorganizedFolderDir = dir(cReorganizedFolderPath);
cReorganizedFolderDirLength = length(cReorganizedFolderDir);
cTrackSmartPhoneStatisticFileName = 'TrackSmartPhoneSensorStatistic.csv';
isTrackSmartPhoneStatisticRecomputed = true;
cTrackSmartPhoneStatisticColumn = 11;
cTrackStatisticRecomputed = false;
isTrackStatisticRecomputed = isTrackSmartPhoneStatisticRecomputed || cTrackStatisticRecomputed;
cTrackStatisticFileName = 'TrackSensorSampleRateStatistic.csv';
cIntedayStatisticRecomputed = false;
isIntedayStatisticRecomputed = isTrackSmartPhoneStatisticRecomputed || cTrackStatisticRecomputed || cIntedayStatisticRecomputed;
cIntedayStatisticFileName = 'IntedaySampleRateStatistic.csv';

tIntedayStatisticFilePath = fullfile(cReorganizedFolderPath,cIntedayStatisticFileName);
if ~isfile(tIntedayStatisticFilePath) || isIntedayStatisticRecomputed
    tIntedayStatisticMatrix = [];
    for i = 1:cReorganizedFolderDirLength
        tTrackFolderNameStr = cReorganizedFolderDir(i).name;
        if ~strcmp(tTrackFolderNameStr,'.') && ~strcmp(tTrackFolderNameStr,'..')
            tTrackFolderPath = fullfile(cReorganizedFolderPath,tTrackFolderNameStr);
            if isfolder(tTrackFolderPath)
                % Head statistic of track
                tTrackStatisticFilePath = fullfile(tTrackFolderPath,cTrackStatisticFileName);
                if ~isfile(tTrackStatisticFilePath) || isTrackStatisticRecomputed
                    tTrackFolderDir = dir(tTrackFolderPath);
                    tTrackFolderDirLength = length(tTrackFolderDir);
                    tTrackStatisticMatrix = [];
                    for j = 1:tTrackFolderDirLength
                        tTrackSmartPhoneFolderNameChar = tTrackFolderDir(j).name;
                        if ~strcmp(tTrackSmartPhoneFolderNameChar,'.') && ~strcmp(tTrackSmartPhoneFolderNameChar,'..')
                            tTrackSmartPhoneFolderPath = fullfile(tTrackFolderPath,tTrackSmartPhoneFolderNameChar);
                            if isfolder(tTrackSmartPhoneFolderPath)
                                % Head statistic of track smart phone
                                tTrackSmartPhoneStatisticFilePath = fullfile(tTrackSmartPhoneFolderPath,kRawFolderName,cTrackSmartPhoneStatisticFileName);
                                if ~isfile(tTrackSmartPhoneStatisticFilePath) || isTrackSmartPhoneStatisticRecomputed
                                    tTrackSmartPhoneStatisticMatrix = zeros(kValidateSensorFileListLength,cTrackSmartPhoneStatisticColumn);
                                    for k = 1:kValidateSensorFileListLength
                                        tSensorFileName = kValidateSensorFileList(k);
                                        tSensorFilePath = fullfile(tTrackSmartPhoneFolderPath,kRawFolderName,tSensorFileName);
                                        tTrackSmartPhoneStatisticMatrix(k,1) = k;
                                        if isfile(tSensorFilePath)
                                            tSensorRawData = readmatrix(tSensorFilePath);
                                            tSensorRawDataLength = size(tSensorRawData,1);
                                            if strcmp(tSensorFileName,kGnssLocationFileNameString)
                                                tSensorRawDataSystemClockSensorEventTime = tSensorRawData(:,1) * MS2S + (tSensorRawData(:,5) - tSensorRawData(:,2)) * NS2S;
                                            elseif strcmp(tSensorFileName,kGnssMeasurementFileNameString)
                                                tSensorRawDataSystemClockSensorEventTime = tSensorRawData(:,1) * MS2S;
                                            else
                                                tSensorRawDataSystemClockSensorEventTime = tSensorRawData(:,1) * MS2S + (tSensorRawData(:,4) - tSensorRawData(:,2)) * NS2S;
                                            end
                                            tSensorRawDataHeadTime = tSensorRawDataSystemClockSensorEventTime(1,1);
                                            tSensorRawDataTailTime = tSensorRawDataSystemClockSensorEventTime(tSensorRawDataLength,1);
                                            tSensorRawDataDuration = tSensorRawDataTailTime - tSensorRawDataHeadTime;

                                            tSensorRawDataSampleInterval = tSensorRawDataSystemClockSensorEventTime(2:tSensorRawDataLength) - tSensorRawDataSystemClockSensorEventTime(1:(tSensorRawDataLength-1));
                                            tSensorRawDataSampleIntervalMax = max(tSensorRawDataSampleInterval);
                                            tSensorRawDataSampleIntervalMin = min(tSensorRawDataSampleInterval);
                                            tSensorRawDataSampleIntervalMean = mean(tSensorRawDataSampleInterval);
                                            tSensorRawDataSampleRate = 1/tSensorRawDataSampleIntervalMean;

                                            tSensorFileDir = dir(tSensorFilePath);
                                            tSensorFileBytes = tSensorFileDir.bytes;

                                            tTrackSmartPhoneStatisticMatrix(k,2) = tSensorRawDataLength;
                                            tTrackSmartPhoneStatisticMatrix(k,3) = tSensorRawDataHeadTime;
                                            tTrackSmartPhoneStatisticMatrix(k,4) = tSensorRawDataTailTime;
                                            tTrackSmartPhoneStatisticMatrix(k,5) = tSensorRawDataDuration;
                                            tTrackSmartPhoneStatisticMatrix(k,6) = tSensorRawDataSampleIntervalMin;
                                            tTrackSmartPhoneStatisticMatrix(k,7) = tSensorRawDataSampleIntervalMax;
                                            tTrackSmartPhoneStatisticMatrix(k,8) = tSensorRawDataSampleIntervalMean;
                                            tTrackSmartPhoneStatisticMatrix(k,9) = tSensorRawDataSampleRate;
                                            tTrackSmartPhoneStatisticMatrix(k,10) = tSensorFileBytes;
                                            tTrackSmartPhoneStatisticMatrix(k,11) = tTrackSmartPhoneStatisticMatrix(k,10) / tTrackSmartPhoneStatisticMatrix(k,5);
                                        else
                                            logMsg = sprintf('Missing data track %s smart phone %s file %s',tTrackFolderNameStr,tTrackSmartPhoneFolderNameChar,tSensorFileName);
                                            log2terminal('W',TAG,logMsg);
                                        end
                                    end
                                    writematrix(tTrackSmartPhoneStatisticMatrix,tTrackSmartPhoneStatisticFilePath);
                                else
                                    tTrackSmartPhoneStatisticMatrix = readmatrix(tTrackSmartPhoneStatisticFilePath);
                                end
                                % Tail statistic of track smart phone
                                tTrackSmartPhoneFolderNameString = string(tTrackSmartPhoneFolderNameChar);
                                tTrackSmartPhoneNumber = find(cPhoneMapNumber == tTrackSmartPhoneFolderNameString);
                                tTrackSmartPhoneStatisticMatrixSizeRow = size(tTrackSmartPhoneStatisticMatrix,1);
                                tIntedayTrackSmartPhoneStatisticMatrix = horzcat(ones(tTrackSmartPhoneStatisticMatrixSizeRow,1)*tTrackSmartPhoneNumber,tTrackSmartPhoneStatisticMatrix);
                                tTrackStatisticMatrix = vertcat(tTrackStatisticMatrix,tIntedayTrackSmartPhoneStatisticMatrix);
                            end
                        end
                    end
                    writematrix(tTrackStatisticMatrix,tTrackStatisticFilePath);
                else
                    tTrackStatisticMatrix = readmatrix(tTrackStatisticFilePath);
                end
                % Tail statistic of track
                logMsg = sprintf('Statistic track %s', tTrackFolderNameStr);
                log2terminal('I',TAG,logMsg);
                tTrackNumber = str2double(tTrackFolderNameStr);
                tTrackStatisticMatrixSizeRow = size(tTrackStatisticMatrix,1);
                tIntedayTrackStatisticMatrix = horzcat(ones(tTrackStatisticMatrixSizeRow,1)*tTrackNumber,tTrackStatisticMatrix);
                tIntedayStatisticMatrix = vertcat(tIntedayStatisticMatrix,tIntedayTrackStatisticMatrix);
            end
        end
    end
    writematrix(tIntedayStatisticMatrix,tIntedayStatisticFilePath);
else
    tIntedayStatisticMatrix = readmatrix(tIntedayStatisticFilePath);
end

% Validate the same smart phone sampling during the day
for i = 1:kPhoneMapNumberLength
    tPhoneName = cPhoneMapNumber(i);
    tIntedayPhoneStatisticMatrix = tIntedayStatisticMatrix(tIntedayStatisticMatrix(:,2)==i,:);
    figureNameText = sprintf('%s',tPhoneName);
    figure('Name',figureNameText);
    ViridisColerPalette03 = ["#fde725" "#21918c" "#440154"];
    pPhoneSensorPlotRows = kValidateSensorFileListLength;
    pPhoneSensorPlotColumns = 1;
    for j = 1:kValidateSensorFileListLength
        tSensorFileName = kValidateSensorFileList(j);
        tSensorFileNameSplit = split(tSensorFileName,".");
        tSensorName = tSensorFileNameSplit(1);
        tIntedayPhoneSensorStatisticMatrix = tIntedayPhoneStatisticMatrix(tIntedayPhoneStatisticMatrix(:,3)==j,:);
        sampleRateStatistic = tIntedayPhoneSensorStatisticMatrix(:,11);
        sampleRateMean = mean(sampleRateStatistic);
        sampleRateStd = std(sampleRateStatistic);
        dataRateStatistic = tIntedayPhoneSensorStatisticMatrix(:,13);
        dataRateMean = mean(dataRateStatistic);
        dataRateStd = std(dataRateStatistic);
        logMsg = sprintf('Statistic smart phone %s: sensor %s: sample rate mean %.0f Hz, std %.1f Hz, data rate mean %.0f bps, std %.0f bps',tPhoneName,tSensorName,sampleRateMean,sampleRateStd,dataRateMean*8,dataRateStd*8);
        log2terminal('I',TAG,logMsg);

        subplot(pPhoneSensorPlotRows,pPhoneSensorPlotColumns,j);
        hold on;
        plot(tIntedayPhoneSensorStatisticMatrix(:,1),sampleRateStatistic,'Color',ViridisColerPalette03(3));
        xlabel('Track');
        ylabel('Sample rate (Hz)');
        titleText = sprintf('%s',tSensorName);
        title(titleText);
        hold off;
    end
end
