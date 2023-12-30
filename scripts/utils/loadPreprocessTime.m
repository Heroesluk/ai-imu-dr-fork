function [preprocessTime] = loadPreprocessTime(folderPath)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明

preprocessRawFlatData = loadPreprocessRawFlat(folderPath);
preprocessTime = preprocessRawFlatData(:,1);

end