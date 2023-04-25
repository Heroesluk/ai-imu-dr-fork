close all;
clear;
addpath(genpath(pwd));

load 'SmartPhoneDataConfig.mat';

S2MS = 1e3;
MS2S = 1/S2MS;
S2NS = 1e9;
NS2S = 1/S2NS;
MS2NS = 1e6;
NS2MS = 1/MS2NS;
US2NS = 1e3;
NS2US = 1/US2NS;

TAG = 'PreprocessorCoarseClip';
kRawFolderName = 'raw';
cDayZeroOClockAlignFolderName = 'dayZeroOClockAlign';

cPhoneMapNumber = ["GOOGLE_Pixel3" "HUAWEI_Mate30"];
% cPhoneMapNumber = ["GOOGLE_Pixel3" "HUAWEI_Mate30" "HUAWEI_P20"];
kPhoneMapNumberLength = length(cPhoneMapNumber);

% cDatasetFolderPath = 'C:\DoctorRelated\20230410重庆VDR数据采集';
cDatasetFolderPath = 'E:\DoctorRelated\20230410重庆VDR数据采集';
cDatasetCollectionDate = '2023_04_10';
cReorganizedFolderName = 'Reorganized';
cReorganizedFolderPath = fullfile(cDatasetFolderPath,cDatasetCollectionDate,cReorganizedFolderName);

cTrackSmartPhoneStatisticColumn = 6;

isRecomputeGroundTruthFile = true;
cTrackGroundTruthNavFileName = 'TrackGroundTruthNav.csv';
cTrackGroundTruthImuFileName = 'TrackGroundTruthImu.csv';
cTrackSynchronizedFileName = 'TrackSynchronized.csv';

cVisualizeCoarseClipData = 1;
cVisualizeFineClipData = 1;

cPreprocessTrackList = ["0008"];
cPreprocessTrackListLength = length(cPreprocessTrackList);

for i = 1:cPreprocessTrackListLength
    tTrackFolderNameStr = cPreprocessTrackList(i);
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
                    tDayZeroOClockAlignFolderPath = fullfile(tTrackSmartPhoneFolderPath,cDayZeroOClockAlignFolderName);
                    cTrackSynchronizedFilePath = fullfile(tDayZeroOClockAlignFolderPath,cTrackSynchronizedFileName);
                    if ~isfile(cTrackSynchronizedFilePath)
                        % Step: Visualize coarse clip
                        tTrackGroundTruthImuFilePath = fullfile(tDayZeroOClockAlignFolderPath,cTrackGroundTruthImuFileName);
                        plotGroundTruthImuData(cVisualizeCoarseClipData,tTrackGroundTruthImuFilePath);

                        tTrackSmartPhoneSensorGyroscopeUncalibratedFilePath = fullfile(tDayZeroOClockAlignFolderPath,kMotionSensorGyroscopeUncalibratedFileNameString);
                        tTrackSmartPhoneSensorAccelerometerUncalibratedFilePath = fullfile(tDayZeroOClockAlignFolderPath,kMotionSensorAccelerometerUncalibratedFileNameString);
                        plotSmartPhoneImuData(cVisualizeCoarseClipData,tTrackSmartPhoneSensorGyroscopeUncalibratedFilePath,tTrackSmartPhoneSensorAccelerometerUncalibratedFilePath);

                        % Step: Visualize fine clip
                        groundTruthImuData = readmatrix(tTrackGroundTruthImuFilePath);
                        smartPhoneImuGyroscopeData = readmatrix(tTrackSmartPhoneSensorGyroscopeUncalibratedFilePath);
                        smartPhoneImuAccelerometerData = readmatrix(tTrackSmartPhoneSensorAccelerometerUncalibratedFilePath);

                        fineClipReferenceHeadTime = max(min(smartPhoneImuGyroscopeData(:,2)),min(smartPhoneImuAccelerometerData(:,2)));
                        fineClipReferenceTailTime = min(max(smartPhoneImuGyroscopeData(:,2)),max(smartPhoneImuAccelerometerData(:,2)));
                        fineClipHeadTime = floor(fineClipReferenceHeadTime / 60) * 60;
                        fineClipTailTime = ceil(fineClipReferenceTailTime / 60) * 60;
                        fineClipGroundTruthImuData = groundTruthImuData(groundTruthImuData(:,1) >= fineClipHeadTime & groundTruthImuData(:,1) <= fineClipTailTime,:);
                        plotComparedImuData(cVisualizeFineClipData,fineClipGroundTruthImuData,smartPhoneImuGyroscopeData,smartPhoneImuAccelerometerData);

                        % Step: Visualize synchronized sensor data
                        resampleHeadTime = ceil(fineClipReferenceHeadTime);
                        resampleTailTime = floor(fineClipReferenceTailTime);
                        resampleRate = 200;
                        resampleInterval = 1 / resampleRate;
                        resampleTime = (resampleHeadTime:resampleInterval:resampleTailTime)';
                        resampleTimeSize = size(resampleTime,1);

                        resampledGroundTruthAccelerometerData = interp1(fineClipGroundTruthImuData(:,1),fineClipGroundTruthImuData(:,2:4),resampleTime);
                        resampledSmartPhoneAccelerometerData = interp1(smartPhoneImuAccelerometerData(:,2),smartPhoneImuAccelerometerData(:,4:6),resampleTime);
                        plotComparedResampledData(1,resampleTime,resampledGroundTruthAccelerometerData,resampledSmartPhoneAccelerometerData);

                        globalSynchronizeTimeIndex = -0;
                        analysisGlobalSynchronizeTimeIndexRadius = 10;
                        analysisGlobalSynchronizeTimeIndexListHead = globalSynchronizeTimeIndex - analysisGlobalSynchronizeTimeIndexRadius;
                        analysisGlobalSynchronizeTimeIndexListTail = globalSynchronizeTimeIndex + analysisGlobalSynchronizeTimeIndexRadius;
                        if analysisGlobalSynchronizeTimeIndexListHead >= 1 && analysisGlobalSynchronizeTimeIndexListTail <= resampleTimeSize
                            analysisGlobalSynchronizeTimeIndexList = (analysisGlobalSynchronizeTimeIndexListHead:analysisGlobalSynchronizeTimeIndexListTail)';
                            analysisGlobalSynchronizeTimeIndexListSize = size(analysisGlobalSynchronizeTimeIndexList,1);
                            globalSynchronizeTimeIndexStatistic = zeros(analysisGlobalSynchronizeTimeIndexListSize,5);
                            for k = 1:analysisGlobalSynchronizeTimeIndexListSize
                                tGlobalSynchronizeTimeIndex = analysisGlobalSynchronizeTimeIndexList(k);
                                xcorrDataX = resampledGroundTruthAccelerometerData(-tGlobalSynchronizeTimeIndex:resampleTimeSize,3);
                                xcorrDataY = resampledSmartPhoneAccelerometerData(1:(resampleTimeSize+tGlobalSynchronizeTimeIndex+1),3);
                                [xcorrDataR,xcorrDataLags] = xcorr(xcorrDataX,xcorrDataY,'normalized');
                                xcorrDataRMax = max(xcorrDataR);
                                xcorrDataRMaxIndex = find(xcorrDataR == xcorrDataRMax);
                                xcorrDataRMaxLag = xcorrDataLags(xcorrDataRMaxIndex);
                                %                         figure;
                                %                         stem(xcorrDataLags,xcorrDataR);
                                globalSynchronizeTimeIndexStatistic(k,1) = tGlobalSynchronizeTimeIndex;
                                globalSynchronizeTimeIndexStatistic(k,2) = xcorrDataRMaxLag;
                                globalSynchronizeTimeIndexStatistic(k,3) = tGlobalSynchronizeTimeIndex-xcorrDataRMaxLag;
                                globalSynchronizeTimeIndexStatistic(k,4) = xcorrDataRMax;
                            end

                            figure;
                            subPlotRows = 2;
                            subPlotColumns = 1;
                            subplot(subPlotRows,subPlotColumns,1);
                            plot(globalSynchronizeTimeIndexStatistic(:,1),globalSynchronizeTimeIndexStatistic(:,3));
                            subplot(subPlotRows,subPlotColumns,2);
                            plot(globalSynchronizeTimeIndexStatistic(:,1),globalSynchronizeTimeIndexStatistic(:,4));
                        else
                            logMsg = sprintf('Out of resampled range');
                            log2terminal('E',TAG,logMsg);
                        end

                        analysisCorrelationTimeLength = 4;
                        analysisCorrelationSampleLength = analysisCorrelationTimeLength * resampleRate;
                        analysisSampleHeadTime = 25899;
                        analysisSampleHeadIndex = find(resampleTime == analysisSampleHeadTime);
                        analysisSampleTailIndex = analysisSampleHeadIndex + analysisCorrelationSampleLength - 1;
                        analysisSampleIndex = analysisSampleHeadIndex:analysisSampleTailIndex;
                        analysisResampleTime = resampleTime(analysisSampleIndex,:);
                        analysisResampledGroundTruthAccelerometerData = resampledGroundTruthAccelerometerData(analysisSampleIndex,:);

                        % Analyze the xcorr value around the synchronization offset
                        synchronizeTimeIndex = -0;
                        analysisSynchronizeTimeIndexRadius = 10;
                        analysisSynchronizeTimeIndexListHead = synchronizeTimeIndex - analysisSynchronizeTimeIndexRadius;
                        analysisSynchronizeTimeIndexListTail = synchronizeTimeIndex + analysisSynchronizeTimeIndexRadius;
                        analysisSynchronizeTimeIndexList = (analysisSynchronizeTimeIndexListHead:analysisSynchronizeTimeIndexListTail)';
                        analysisSynchronizeTimeIndexListSize = size(analysisSynchronizeTimeIndexList,1);
                        synchronizeTimeIndexStatistic = zeros(analysisSynchronizeTimeIndexListSize,5);
                        for k = 1:analysisSynchronizeTimeIndexListSize
                            tSynchronizeTimeIndex = analysisSynchronizeTimeIndexList(k);
                            analysisResampledSmartPhoneAccelerometerData = resampledSmartPhoneAccelerometerData(analysisSampleIndex+tSynchronizeTimeIndex,:);



                            analysisXCorrDataX = analysisResampledGroundTruthAccelerometerData(:,3);
                            analysisXCorrDataY = analysisResampledSmartPhoneAccelerometerData(:,3);
                            [analysisXCorrDataR,analysisXCorrDataLags] = xcorr(analysisXCorrDataX,analysisXCorrDataY,'normalized');

                            if tSynchronizeTimeIndex == 0
                                plotComparedResampledData(1,analysisResampleTime,analysisResampledGroundTruthAccelerometerData,analysisResampledSmartPhoneAccelerometerData);
                                figure;
                                stem(analysisXCorrDataLags,analysisXCorrDataR);
                                titleText = sprintf('%d',tSynchronizeTimeIndex);
                                title(titleText);
                            end

                            analysisXCorrDataRMax = max(analysisXCorrDataR);
                            analysisXCorrDataRMaxIndex = find(analysisXCorrDataR == analysisXCorrDataRMax);
                            analysisXCorrDataRMaxLag = analysisXCorrDataLags(analysisXCorrDataRMaxIndex);

                            synchronizeTimeIndexStatistic(k,1) = tSynchronizeTimeIndex;
                            synchronizeTimeIndexStatistic(k,2) = analysisXCorrDataRMaxLag;
                            synchronizeTimeIndexStatistic(k,3) = tSynchronizeTimeIndex-analysisXCorrDataRMaxLag;
                            synchronizeTimeIndexStatistic(k,4) = analysisXCorrDataRMax;
                        end

                        figure;
                        subPlotRows = 2;
                        subPlotColumns = 1;
                        subplot(subPlotRows,subPlotColumns,1);
                        plot(synchronizeTimeIndexStatistic(:,1),synchronizeTimeIndexStatistic(:,3));
                        subplot(subPlotRows,subPlotColumns,2);
                        plot(synchronizeTimeIndexStatistic(:,1),synchronizeTimeIndexStatistic(:,4));

                        % Interpolate train data
                        tTrackGroundTruthNavFilePath = fullfile(tDayZeroOClockAlignFolderPath,cTrackGroundTruthNavFileName);
                        tTrackGroundTruthNavData = readmatrix(tTrackGroundTruthNavFilePath);
                        synchronizeTimeBias = 118;
                        synchronizedData = zeros(resampleTimeSize,1+6+6+9+3+3);
                        synchronizedData(:,1) = resampleTime + synchronizeTimeBias * resampleInterval;
                        synchronizedData(:,2:4) = interp1(smartPhoneImuGyroscopeData(:,2),smartPhoneImuGyroscopeData(:,4:6),synchronizedData(:,1));
                        synchronizedData(:,5:7) = interp1(smartPhoneImuAccelerometerData(:,2),smartPhoneImuAccelerometerData(:,4:6),synchronizedData(:,1));
                        synchronizedData(:,8:10) = interp1(fineClipGroundTruthImuData(:,1),fineClipGroundTruthImuData(:,5:7),synchronizedData(:,1));
                        synchronizedData(:,11:13) = interp1(fineClipGroundTruthImuData(:,1),fineClipGroundTruthImuData(:,2:4),synchronizedData(:,1));
                        interpGroundTruthData = interpolateSpanRawData(tTrackGroundTruthNavData,synchronizedData(:,1));
                        synchronizedData(:,14:28) = interpGroundTruthData;
                        writematrix(synchronizedData,cTrackSynchronizedFilePath);
                    end

                    logMsg = sprintf('D');
                    log2terminal('D',TAG,logMsg);
                end
            end
        end
        % Tail statistic of track
        logMsg = sprintf('Statistic track %s', tTrackFolderNameStr);
        log2terminal('I',TAG,logMsg);

    else
        logMsg = sprintf('Not have track %s on %s',tTrackFolderNameSt,cDatasetCollectionDater);
        log2terminal('W',TAG,logMsg);
    end
end

