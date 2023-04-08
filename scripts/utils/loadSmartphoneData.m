function [outputArg1] = loadSmartphoneData(filePath,skipLines)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明

fid = fopen(filePath);
gnssClockDataFormatSpec = '';
gnssClockDataFormatSpec = strcat(gnssClockDataFormatSpec, '%d64');      % systemCurrentTimeMillis
gnssClockDataFormatSpec = strcat(gnssClockDataFormatSpec, ', %d64');    % systemClockElapsedRealtimeNanos
gnssClockDataFormatSpec = strcat(gnssClockDataFormatSpec, ', %d64');    % localGnssClockOffsetNanos
gnssClockDataFormatSpec = strcat(gnssClockDataFormatSpec, ', %d64');    % gnssClock.getTimeNanos()
gnssClockDataFormatSpec = strcat(gnssClockDataFormatSpec, ', %f64');    % gnssClock.getTimeUncertaintyNanos()
gnssClockDataFormatSpec = strcat(gnssClockDataFormatSpec, ', %d64');    % gnssClock.getFullBiasNanos()
gnssClockDataFormatSpec = strcat(gnssClockDataFormatSpec, ', %f64');    % gnssClock.getBiasNanos()
gnssClockDataFormatSpec = strcat(gnssClockDataFormatSpec, ', %f64');    % gnssClock.getBiasUncertaintyNanos()
gnssClockDataFormatSpec = strcat(gnssClockDataFormatSpec, ', %d64');    % gnssClock.getElapsedRealtimeNanos()
gnssClockDataFormatSpec = strcat(gnssClockDataFormatSpec, ', %f64');    % gnssClock.getElapsedRealtimeUncertaintyNanos()
gnssClockDataFormatSpec = strcat(gnssClockDataFormatSpec, ', %d64');    % gnssClock.getLeapSecond()
gnssClockDataFormatSpec = strcat(gnssClockDataFormatSpec, ', %f64');    % gnssClock.getDriftNanosPerSecond()
gnssClockDataFormatSpec = strcat(gnssClockDataFormatSpec, ', %f64');    % gnssClock.getDriftUncertaintyNanosPerSecond()
gnssClockDataFormatSpec = strcat(gnssClockDataFormatSpec, '\n');
gnssClockData = textscan(fid,gnssClockDataFormatSpec,-1,'HeaderLines',skipLines);
fclose(fid);

outputArg1 = gnssClockData;
end