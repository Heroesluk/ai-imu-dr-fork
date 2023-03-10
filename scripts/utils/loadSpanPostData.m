function [outputArg1] = loadSpanPostData(spanRawImuDataFilePath)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明

TAG = 'loadSpanRawImuData';

spanPostData = readmatrix(spanRawImuDataFilePath);

addpath(genpath(pwd));
spanPose = convertSpanToPose(spanPostData);

outputArg1 = spanPose;


end