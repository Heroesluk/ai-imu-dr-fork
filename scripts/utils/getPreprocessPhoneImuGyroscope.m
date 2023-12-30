function [preprocessPhoneImuGyroscope] = getPreprocessPhoneImuGyroscope(preprocessRawFlatData)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明

preprocessPhoneImuGyroscope = preprocessRawFlatData(:,2:4);

end