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

TAG = 'ValidateBatchTrackDataGnssClock';
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

isTrackSmartPhoneStatisticRecomputed = false;
cTrackSmartPhoneStatisticColumn = 7;
isIntedayStatisticRecomputed = true;
cIntedayStatisticFileName = 'IntedayGnssClockStatistic.csv';

tIntedayStatisticFilePath = fullfile(cReorganizedFolderPath,cIntedayStatisticFileName);
if ~isfile(tIntedayStatisticFilePath) || isIntedayStatisticRecomputed
    tIntedayStatisticMatrix = [];
    for i = 1:cReorganizedFolderDirLength
        tTrackFolderNameStr = cReorganizedFolderDir(i).name;
        if ~strcmp(tTrackFolderNameStr,'.') && ~strcmp(tTrackFolderNameStr,'..')
            tTrackFolderPath = fullfile(cReorganizedFolderPath,tTrackFolderNameStr);
            if isfolder(tTrackFolderPath)
                % Head statistic of track
                tTrackFolderDir = dir(tTrackFolderPath);
                tTrackFolderDirLength = length(tTrackFolderDir);
                tTrackStatisticMatrix = [];
                for j = 1:tTrackFolderDirLength
                    tTrackSmartPhoneFolderNameChar = tTrackFolderDir(j).name;
                    if ~strcmp(tTrackSmartPhoneFolderNameChar,'.') && ~strcmp(tTrackSmartPhoneFolderNameChar,'..')
                        tTrackSmartPhoneFolderPath = fullfile(tTrackFolderPath,tTrackSmartPhoneFolderNameChar);
                        if isfolder(tTrackSmartPhoneFolderPath)
                            % Head statistic of track smart phone
                            tSensorGnssMeasurementFileName = kGnssMeasurementFileNameString;
                            tSensorGnssMeasurementFilePath = fullfile(tTrackSmartPhoneFolderPath,kRawFolderName,tSensorGnssMeasurementFileName);    
                            tSensorRawData = readmatrix(tSensorGnssMeasurementFilePath);
                            tSensorRawDataLength = length(tSensorRawData);

                            tSensorRawDatatBiasUncertaintyNanos = tSensorRawData(:,8);
                            [tSensorRawDatatBiasUncertaintyNanosEcdfF,tSensorRawDatatBiasUncertaintyNanosEcdfX] = ecdf(tSensorRawDatatBiasUncertaintyNanos);
                            tSensorRawDatatBiasUncertaintyNanosEcdfY = interp1(tSensorRawDatatBiasUncertaintyNanosEcdfF,tSensorRawDatatBiasUncertaintyNanosEcdfX,[0.6827 0.9545 0.9973],'linear');
                            tSensorRawDatatBiasUncertaintyNanosMax = max(tSensorRawDatatBiasUncertaintyNanos);
                            tSensorRawDatatBiasUncertaintyNanosMin = min(tSensorRawDatatBiasUncertaintyNanos);
                            tSensorRawDatatBiasUncertaintyNanosMean = mean(tSensorRawDatatBiasUncertaintyNanos);

                            tTrackSmartPhoneStatisticMatrix = zeros(1,cTrackSmartPhoneStatisticColumn);
                            tTrackSmartPhoneStatisticMatrix(1,1) = find(kValidateSensorFileList == tSensorGnssMeasurementFileName);
                            tTrackSmartPhoneStatisticMatrix(1,2) = tSensorRawDatatBiasUncertaintyNanosMean;
                            tTrackSmartPhoneStatisticMatrix(1,3) = tSensorRawDatatBiasUncertaintyNanosMin;
                            tTrackSmartPhoneStatisticMatrix(1,4) = tSensorRawDatatBiasUncertaintyNanosEcdfY(1);
                            tTrackSmartPhoneStatisticMatrix(1,5) = tSensorRawDatatBiasUncertaintyNanosEcdfY(2);
                            tTrackSmartPhoneStatisticMatrix(1,6) = tSensorRawDatatBiasUncertaintyNanosEcdfY(3);
                            tTrackSmartPhoneStatisticMatrix(1,7) = tSensorRawDatatBiasUncertaintyNanosMax;
                            % Tail statistic of track smart phone
                            tTrackSmartPhoneFolderNameString = string(tTrackSmartPhoneFolderNameChar);
                            tTrackSmartPhoneNumber = find(cPhoneMapNumber == tTrackSmartPhoneFolderNameString);
                            tTrackSmartPhoneStatisticMatrixSizeRow = size(tTrackSmartPhoneStatisticMatrix,1);
                            tIntedayTrackSmartPhoneStatisticMatrix = horzcat(ones(tTrackSmartPhoneStatisticMatrixSizeRow,1)*tTrackSmartPhoneNumber,tTrackSmartPhoneStatisticMatrix);
                            tTrackStatisticMatrix = vertcat(tTrackStatisticMatrix,tIntedayTrackSmartPhoneStatisticMatrix);
                        end
                    end
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

