function [preprocessGroundTruthNavPosition] = getPreprocessGroundTruthNavPosition(preprocessRawFlatData)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明

preprocessGroundTruthNavPosition = preprocessRawFlatData(:,23:25);

end