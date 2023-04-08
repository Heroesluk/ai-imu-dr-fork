clearvars;
close all;
dbstop error;
% clc;
addpath(genpath(pwd));

TAG = 'CustomViewerCoSlam';

cReferenceDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_02_28\REF\CoSLAM-2023-02-28-19-37-48';
cReferenceDatasetPosFileName = 'CoSLAM-2023-02-28-19-37-48.txt';

% cReferenceDatasetFolderPath = 'C:\Users\QIAN LONG\Downloads\2023_02_28\REF\CoSLAM-2023-02-28-19-21-39';
% cReferenceDatasetPosFileName = 'CoSLAM-2023-02-28-19-21-39.txt';

cReferenceDatasetPosFilePath = fullfile(cReferenceDatasetFolderPath,cReferenceDatasetPosFileName);
referencePosRawData = readmatrix(cReferenceDatasetPosFilePath);
referencePosRawDataSize = size(referencePosRawData,1);

headTimeUtc = referencePosRawData(1,1);
headTimeDateTime = datetime(headTimeUtc,'ConvertFrom','posixtime','TimeZone','Asia/Shanghai');
headTimeDateStr = datestr(headTimeDateTime,'yyyy-mm-dd HH:MM:ss.FFF');
tailTimeUtc = referencePosRawData(referencePosRawDataSize,1);
tailTimeDateTime = datetime(tailTimeUtc,'ConvertFrom','posixtime','TimeZone','Asia/Shanghai');
tailTimeDateStr = datestr(tailTimeDateTime,'yyyy-mm-dd HH:MM:ss.FFF');
duration = tailTimeUtc - headTimeUtc;
logMsg = sprintf('Data log from %s to %s, duration %.3f s',headTimeDateStr,tailTimeDateStr,duration);
log2terminal('I',TAG,logMsg);

[referenceZeroOClockDateTime, referenceZeroOClockClockOffset] = getUtcTimeMapZeroOClockTime(referencePosRawData(1,1));
logMsg = sprintf('Zero O''Clock clock based date: %s, time offset %f s', datestr(referenceZeroOClockDateTime,'yyyy-mm-dd HH:MM:ss.FFF'),referenceZeroOClockClockOffset);
log2terminal('I',TAG,logMsg);


referencePosData = cell(referencePosRawDataSize,2);
for i=1:referencePosRawDataSize
    poseT = referencePosRawData(i,2:4);
    rawQuat = referencePosRawData(i,5:8);
    norQuat = quatnormalize(rawQuat);
    poseR = quat2dcm(norQuat);
    poseR = [0 1 0; 1 0 0; 0 0 1] * poseR;
    referencePosData{i,1} = referencePosRawData(i,1) - referenceZeroOClockClockOffset;
    referencePosData{i,2} = [poseR poseT';0 0 0 1];
end

plotPose(referencePosData);
