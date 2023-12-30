function [] = saveFilterStateIntegratedGroundTruth(folderPath,filterState)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

% 定义输出
cFilterResultFileName = 'IntegratedGroundTruthFilterState.mat';
cFilterResultFilePath = fullfile(folderPath,'dayZeroOClockAlign',cFilterResultFileName);

sIntegratedGroundTruthFilterState = filterState;
save(cFilterResultFilePath,"sIntegratedGroundTruthFilterState");
end