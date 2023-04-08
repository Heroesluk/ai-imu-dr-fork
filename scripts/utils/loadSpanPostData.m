function [outputArg1] = loadSpanPostData(spanPostDataFilePath,gpsWeek)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明
addpath(genpath(pwd));
TAG = 'loadSpanPostData';

spanPostData = readmatrix(spanPostDataFilePath);
spanPostDataSize = size(spanPostData,1);

spanPostDataGpsWeek = ones(spanPostDataSize,1) * gpsWeek;
spanPostDataGpsWeekSecond = spanPostData(:,1);
[spanPostUtcTimeDateTime,spanPostUtcTimeZeroOClockTimeDateTime,spanPostUtcTimeZeroOClockTimePosixTime,spanPostTime] = convertGpsWeekWeekSecondToUtcDateTime(spanPostDataGpsWeek,spanPostDataGpsWeekSecond);

logHeadTimeDateTime = spanPostUtcTimeDateTime(1,1);
logHeadTimeDateStr = datestr(logHeadTimeDateTime,'yyyy-mm-dd HH:MM:ss.FFF');
logHeadSpanTime = spanPostTime(1,1);
logTailTimeDateTime =spanPostUtcTimeDateTime(spanPostDataSize,1);
logTailTimeDateStr = datestr(logTailTimeDateTime,'yyyy-mm-dd HH:MM:ss.FFF');
logTailSpanTime = spanPostTime(spanPostDataSize,1);
duration = logTailSpanTime - logHeadSpanTime;
logMsg = sprintf('SPAN post data log from %s to %s, duration %.3f s',logHeadTimeDateStr,logTailTimeDateStr,duration);
log2terminal('I',TAG,logMsg);

spanPostUtcTimeZeroOClockTimeDateStr = datestr(spanPostUtcTimeZeroOClockTimeDateTime(1,1),'yyyy-mm-dd HH:MM:ss.FFF');
logMsg = sprintf('SPAN post data zero O''Clock clock based date: %s, time offset %f s', spanPostUtcTimeZeroOClockTimeDateStr,spanPostUtcTimeZeroOClockTimePosixTime(1,1));
log2terminal('I',TAG,logMsg);

spanPostDataSampleTimeInterval = spanPostTime(2:spanPostDataSize,1) - spanPostTime(1:(spanPostDataSize-1),1);
spanPostDataMeanSampleTimeInterval = mean(spanPostDataSampleTimeInterval);
spanPostDataMaxSampleTimeInterval = max(spanPostDataSampleTimeInterval);
spanPostDataMinSampleTimeInterval = min(spanPostDataSampleTimeInterval);
spanPostDataSampleRate = 1 / spanPostDataMeanSampleTimeInterval;
logMsg = sprintf('SPAN post data sample interval mean %.3f s, min %.3f s, max %.3f s, estimated sample rate %.0f Hz', spanPostDataMeanSampleTimeInterval,spanPostDataMinSampleTimeInterval,spanPostDataMaxSampleTimeInterval,spanPostDataSampleRate);
log2terminal('I',TAG,logMsg);

spanPostData(:,1) = spanPostTime;
spanPose = convertSpanToPose(spanPostData);

plotSEPose(spanPose(:,7));
% plotSE2Pose(spanPose);

outputArg1 = spanPose;

end