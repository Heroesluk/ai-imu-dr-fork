function [outputArg1] = loadCoSlamImuData(filePath,skipLines)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明

fid = fopen(filePath);
coSlamImuDataFormatSpec = '';
coSlamImuDataFormatSpec = strcat(coSlamImuDataFormatSpec, ' %f64');    % 
coSlamImuDataFormatSpec = strcat(coSlamImuDataFormatSpec, ' %f64');    % 
coSlamImuDataFormatSpec = strcat(coSlamImuDataFormatSpec, ' %f64');    % 
coSlamImuDataFormatSpec = strcat(coSlamImuDataFormatSpec, ' %f64');    % 
coSlamImuDataFormatSpec = strcat(coSlamImuDataFormatSpec, ' %f64');    % 
coSlamImuDataFormatSpec = strcat(coSlamImuDataFormatSpec, ' %f64');    % 
coSlamImuDataFormatSpec = strcat(coSlamImuDataFormatSpec, ' %f64');    % 
coSlamImuDataFormatSpec = strcat(coSlamImuDataFormatSpec, '\n');
coSlamImuData = textscan(fid,coSlamImuDataFormatSpec,-1,'HeaderLines',skipLines);
fclose(fid);

outputArg1 = coSlamImuData;
end