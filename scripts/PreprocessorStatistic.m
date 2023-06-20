%% 按照日期统计预处理数据的元数据，生成报表
% 训练轨迹数据起止时间，时长，长度，最小外包矩形长宽，同步偏移时间
close all;
clear;
addpath(genpath(pwd));

TAG = 'PreprocessorStatistic';


% TODO: S1.1: 配置数据集存储文件夹 根目录
cDatasetProjectFolderPath = 'E:\DoctorRelated\20230410重庆VDR数据采集';

% TODO: S1.1: 配置数据集存储文件夹 根目录
cIsRecomputeIntradayTrainDataStatisticFile = true;
cMultidayTrainDataStatisticFileName = 'MultidayTrainDataStatistic.csv';
cIntradayTrainDataStatisticFileName = 'IntradayTrainDataStatistic.csv';

cTrackStatisticMetaInfoCount = 8;

cDateTimeMapNumber = ["2023_04_10" "2023_04_11" "2023_04_13" "2023_04_15"];
cReorganizedFolderName = 'Reorganized';
cPhoneMapNumber = ["GOOGLE_Pixel3" "HUAWEI_Mate30" "HUAWEI_P20"];
cDayZeroOClockAlignFolderName = 'dayZeroOClockAlign';
cTrackSynchronizedFileName = 'TrackSynchronized.csv';
cResampledSynchronizationTimeOffsetFileName = 'ResampledSynchronizationTimeOffset.txt';

if ~isfolder(cDatasetProjectFolderPath)
    logMsg = sprintf('Illegal dataset root folder path %s',cDatasetProjectFolderPath);
    log2terminal('E',TAG,logMsg);
else

    tMultidayTrainDataStatistic = [];
    tDatasetProjectFolderDir = dir(cDatasetProjectFolderPath);
    tDatasetProjectFolderDirLength = length(tDatasetProjectFolderDir);
    for i = 1:tDatasetProjectFolderDirLength
        tDatasetDateTimeFolderName = tDatasetProjectFolderDir(i).name;
        tDatasetDateTimeNumber = find(cDateTimeMapNumber==tDatasetDateTimeFolderName);
        tDatasetDateTimeFolderPath = fullfile(cDatasetProjectFolderPath,tDatasetDateTimeFolderName);

        if isfolder(tDatasetDateTimeFolderPath)
            if ~strcmp(tDatasetDateTimeFolderName,'.') && ~strcmp(tDatasetDateTimeFolderName,'..')
                
                tDatasetDateTimeReorganizedFolderPath = fullfile(tDatasetDateTimeFolderPath,cReorganizedFolderName);
                if ~isfolder(tDatasetDateTimeReorganizedFolderPath)
                    logMsg = sprintf('Illegal folder path %s',tDatasetDateTimeReorganizedFolderPath);
                    log2terminal('E',TAG,logMsg);
                else
                    % 当前位于采集日期所在文件夹
                    tIntradayTrainDataStatisticFilePath = fullfile(tDatasetDateTimeReorganizedFolderPath,cIntradayTrainDataStatisticFileName);
                    if isfile(cIntradayTrainDataStatisticFileName) && ~cIsRecomputeIntradayTrainDataStatisticFile
                        tIntradayTrainDataStatistic = readmatrx(tIntradayTrainDataStatisticFilePath);
                    else
                        % 统计单日轨迹后处理情况
                        tIntradayTrainDataStatistic = [];
                        tDatasetDateTimeReorganizedFolderDir = dir(tDatasetDateTimeReorganizedFolderPath);
                        tDatasetDateTimeReorganizedFolderDirLength = length(tDatasetDateTimeReorganizedFolderDir);
                        for j = 1:tDatasetDateTimeReorganizedFolderDirLength
                            tDatasetDateTimeTrackFolderName = tDatasetDateTimeReorganizedFolderDir(j).name;
                            tDatasetDateTimeTrackNumber = str2double(tDatasetDateTimeTrackFolderName);
                            tDatasetDateTimeTrackFolderPath = fullfile(tDatasetDateTimeReorganizedFolderPath,tDatasetDateTimeTrackFolderName);
                            % 
                            if isfolder(tDatasetDateTimeTrackFolderPath)
                                if ~strcmp(tDatasetDateTimeTrackFolderName,'.') && ~strcmp(tDatasetDateTimeTrackFolderName,'..')
                                    % 当前位于轨迹编号命名的文件夹
                                    tDatasetDateTimeTrackFolderDir = dir(tDatasetDateTimeTrackFolderPath);
                                    tDatasetDateTimeTrackFolderDirLength = length(tDatasetDateTimeTrackFolderDir);
                                    for k = 1:tDatasetDateTimeTrackFolderDirLength
                                        tDatasetDateTimeTrackPhoneFolderName = tDatasetDateTimeTrackFolderDir(k).name;
                                        tDatasetDateTimeTrackPhoneNumber = find(cPhoneMapNumber == tDatasetDateTimeTrackPhoneFolderName);
                                        tDatasetDateTimeTrackPhoneFolderPath = fullfile(tDatasetDateTimeTrackFolderPath,tDatasetDateTimeTrackPhoneFolderName);
                                        %
                                        if isfolder(tDatasetDateTimeTrackPhoneFolderPath)
                                            if ~strcmp(tDatasetDateTimeTrackPhoneFolderName,'.') && ~strcmp(tDatasetDateTimeTrackPhoneFolderName,'..')
                                                % 当前位于手机命名的文件夹                                                
                                                tDatasetDateTimeTrackPhonePreprocessorFolderPath = fullfile(tDatasetDateTimeTrackPhoneFolderPath,cDayZeroOClockAlignFolderName);
                                                
                                                % 统计tDatasetDateTimeTrackFolderName轨迹tDatasetDateTimeTrackPhoneFolderName手机训练数据
                                                cTrackStatisticMetaInfo = zeros(1,cTrackStatisticMetaInfoCount);
                                                % 当前位于预处理文件夹
                                                cTrackSynchronizedFilePath = fullfile(tDatasetDateTimeTrackPhonePreprocessorFolderPath,cTrackSynchronizedFileName);
                                                if isfile(cTrackSynchronizedFilePath)
                                                    tTrackSynchronizedData = readmatrix(cTrackSynchronizedFilePath);
                                                    tTrackSynchronizedDataSize = size(tTrackSynchronizedData,1);
                                                    tTrackSynchronizedDataHeadTime = tTrackSynchronizedData(1,1);
                                                    tTrackSynchronizedDataTailTime = tTrackSynchronizedData(tTrackSynchronizedDataSize,1);
                                                    tTrackSynchronizedDataDuration = tTrackSynchronizedDataTailTime - tTrackSynchronizedDataHeadTime;
                                                    tTrackSynchronizedDataCoordinate = tTrackSynchronizedData(:,23:25);
                                                    tTrackSynchronizedDataCoordinateXMin = min(tTrackSynchronizedDataCoordinate(:,1));
                                                    tTrackSynchronizedDataCoordinateXMax = max(tTrackSynchronizedDataCoordinate(:,1));
                                                    tTrackSynchronizedDataCoordinateXLength = tTrackSynchronizedDataCoordinateXMax - tTrackSynchronizedDataCoordinateXMin;
                                                    tTrackSynchronizedDataCoordinateYMin = min(tTrackSynchronizedDataCoordinate(:,2));
                                                    tTrackSynchronizedDataCoordinateYMax = max(tTrackSynchronizedDataCoordinate(:,2));
                                                    tTrackSynchronizedDataCoordinateYLength = tTrackSynchronizedDataCoordinateYMax - tTrackSynchronizedDataCoordinateYMin;
                                                    tTrackSynchronizedDataCoordinateZMin = min(tTrackSynchronizedDataCoordinate(:,3));
                                                    tTrackSynchronizedDataCoordinateZMax = max(tTrackSynchronizedDataCoordinate(:,3));
                                                    tTrackSynchronizedDataCoordinateZLength = tTrackSynchronizedDataCoordinateZMax - tTrackSynchronizedDataCoordinateZMin;
                                                    tTrackSynchronizedDataDistance = getTrackDistance(tTrackSynchronizedDataCoordinate);

                                                    cTrackStatisticMetaInfo(1,1) = tTrackSynchronizedDataHeadTime;
                                                    cTrackStatisticMetaInfo(1,2) = tTrackSynchronizedDataTailTime;
                                                    cTrackStatisticMetaInfo(1,3) = tTrackSynchronizedDataDuration;
                                                    cTrackStatisticMetaInfo(1,4) = tTrackSynchronizedDataDistance;
                                                    cTrackStatisticMetaInfo(1,5) = tTrackSynchronizedDataCoordinateXLength;
                                                    cTrackStatisticMetaInfo(1,6) = tTrackSynchronizedDataCoordinateYLength;
                                                    cTrackStatisticMetaInfo(1,7) = tTrackSynchronizedDataCoordinateZLength;

                                                    tTrackSynchronizedDataHeadTimeString = convertDaySecondsToString(tTrackSynchronizedDataHeadTime,0);
                                                    tTrackSynchronizedDataTailTimeString = convertDaySecondsToString(tTrackSynchronizedDataTailTime,0);
                                                    logMsg = sprintf('DateTime %s Track %s Phone %s from %s to %s, duration %.3f s, distance %.3f m', ...
                                                        tDatasetDateTimeFolderName,tDatasetDateTimeTrackFolderName,tDatasetDateTimeTrackPhoneFolderName, ...
                                                        tTrackSynchronizedDataHeadTimeString,tTrackSynchronizedDataTailTimeString,cTrackStatisticMetaInfo(1,3),cTrackStatisticMetaInfo(1,4));
                                                    log2terminal('I',TAG,logMsg);
                                                end

                                                cResampledSynchronizationTimeOffsetFilePath = fullfile(tDatasetDateTimeTrackPhonePreprocessorFolderPath,cResampledSynchronizationTimeOffsetFileName);
                                                if isfile(cResampledSynchronizationTimeOffsetFilePath)
                                                    tResampledSynchronizationTimeOffsetData = readmatrix(cResampledSynchronizationTimeOffsetFilePath);
                                                    cTrackStatisticMetaInfo(1,8) = tResampledSynchronizationTimeOffsetData;
                                                end

                                                tSingleTrainDataStatistic = [tDatasetDateTimeTrackNumber,tDatasetDateTimeTrackPhoneNumber,cTrackStatisticMetaInfo];
                                                tIntradayTrainDataStatistic = [tIntradayTrainDataStatistic;tSingleTrainDataStatistic];

                                            end
                                        end
                                    end
                                end
                            end
                        end

                        writematrix(tIntradayTrainDataStatistic,tIntradayTrainDataStatisticFilePath);
                    end

                    % 完成单日的统计
                    tIntradayTrainDataStatisticSize = size(tIntradayTrainDataStatistic,1);
                    tIntradayTrainDataStatisticDateTimeNumber = ones(tIntradayTrainDataStatisticSize,1) * tDatasetDateTimeNumber;
                    tIntradayTrainDataStatisticAppendDateTime = [tIntradayTrainDataStatisticDateTimeNumber,tIntradayTrainDataStatistic];
                    tMultidayTrainDataStatistic = [tMultidayTrainDataStatistic;tIntradayTrainDataStatisticAppendDateTime];
                    logMsg = sprintf('Complete statistics on %s',tDatasetDateTimeFolderName);
                    log2terminal('I',TAG,logMsg);

                end
            end
        end
    end

    cMultidayTrainDataStatisticFilePath = fullfile(cDatasetProjectFolderPath,cMultidayTrainDataStatisticFileName);
    writematrix(tMultidayTrainDataStatistic,cMultidayTrainDataStatisticFilePath);
end

