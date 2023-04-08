clearvars;
% close all;
dbstop error;
% clc;
addpath(genpath(pwd));

SCRIPT_MODE = 0;

TAG = 'CustomViewerSpan';

cSpanDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\20230301\车载数据';
cSpanDatasetResampledDataFileName = 'ResampledInsData.mat';
cSpanDatasetResampledDataFilePath = fullfile(cSpanDatasetFolderPath,'SPAN',cSpanDatasetResampledDataFileName);
load(cSpanDatasetResampledDataFilePath);



plotIndex = 1:1500;
plotSESubscript4Bracket3Pose(spanResampledData(plotIndex,1),spanResampledData(plotIndex,2),spanResampledData(plotIndex,3),spanResampledData(plotIndex,4),spanResampledData(plotIndex,5));