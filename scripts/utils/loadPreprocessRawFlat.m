function [rPreprocessRawFlatData] = loadPreprocessRawFlat(folderPath)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明

cPreprocessRawFlatFolderName = "dayZeroOClockAlign";
cPreprocessRawFlatFileName = "TrackSynchronized.csv";
tPreprocessRawFlatFilePath = fullfile(folderPath,cPreprocessRawFlatFolderName,cPreprocessRawFlatFileName);
rPreprocessRawFlatData = readmatrix(tPreprocessRawFlatFilePath);

end