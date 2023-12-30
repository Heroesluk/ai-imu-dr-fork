function [filterState] = loadFilterStateIntegratedGroundTruth(folderPath)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

cFilterResultFileName = 'IntegratedGroundTruthFilterState.mat';
tFilterResultFilePath = fullfile(folderPath,'dayZeroOClockAlign',cFilterResultFileName);
load(tFilterResultFilePath,'sIntegratedGroundTruthFilterState');
filterState = sIntegratedGroundTruthFilterState;

end