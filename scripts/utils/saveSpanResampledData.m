function [outputArg1] = saveSpanResampledData(savePath,spanPostData,spanRawImuData)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明
addpath(genpath(pwd));
TAG = 'saveSpanResampledData';

spanPosDataTime = cell2mat(spanPostData(:,1));
spanImuDataTime = spanRawImuData{1,1};

spanPosDataTimeSize = size(spanPosDataTime,1);
spanImuDataTimeSize = size(spanImuDataTime,1);

intersectionHeadTime = max(spanPosDataTime(1,1),spanImuDataTime(1,1));
intersectionTailTime = min(spanPosDataTime(spanPosDataTimeSize,1),spanImuDataTime(spanImuDataTimeSize,1));

resampledHeadTime = ceil(intersectionHeadTime);
resampledTailTime = floor(intersectionTailTime);

resampledRate = 50;
resampledInterval = 1 / resampledRate;
resampledTimeSeries = (resampledHeadTime:resampledInterval:resampledTailTime)';

resampledSpanPoseData = interpolatePose(spanPostData(:,7),cell2mat(spanPostData(:,1)),resampledTimeSeries);
resampledSpanEnuVelocityData = interp1(spanPosDataTime,cell2mat(spanPostData(:,3)),resampledTimeSeries);
resampledSpanImuData = interp1(spanImuDataTime,spanRawImuData{1,2}(:,3:9),resampledTimeSeries);

resampledTimeSeriesSize = size(resampledTimeSeries,1);
spanResampledData = cell(resampledTimeSeriesSize,4);
for i = 1:resampledTimeSeriesSize
    spanResampledData{i,1} = resampledTimeSeries(i);
    spanResampledData{i,2} = resampledSpanPoseData{i};
    spanResampledData{i,3} = resampledSpanEnuVelocityData(i,1:3);
    spanResampledData{i,4} = resampledSpanImuData(i,1:3);
    spanResampledData{i,5} = resampledSpanImuData(i,4:6);
end


cSpanDatasetResampledDataFileName = 'ResampledInsData.mat';
cSpanDatasetResampledDataFilePath = fullfile(savePath,cSpanDatasetResampledDataFileName);
save(cSpanDatasetResampledDataFilePath,"spanResampledData");

outputArg1 = spanResampledData;

end