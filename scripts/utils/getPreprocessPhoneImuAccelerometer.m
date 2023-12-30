function [preprocessPhoneImuAccelerometer] = getPreprocessPhoneImuAccelerometer(preprocessRawFlatData)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明

preprocessPhoneImuAccelerometer = preprocessRawFlatData(:,5:7);

end