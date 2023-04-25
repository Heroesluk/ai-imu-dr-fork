function [outputArg1] = loadJzMins200DataWithZeroOClockTime(jzMins200DataFilePath,gpsWeek,dataCollectionDateStr)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明
addpath(genpath(pwd));
TAG = 'loadSpanPostDataWithZeroOClockTime';

% Filter data in collection day
SECONDS_ONE_DAY = 24 * 60 * 60;
SECONDS_ONE_WEEK = 7 * SECONDS_ONE_DAY;
secondsOffset = SECONDS_ONE_WEEK * gpsWeek;
rGpsReferenceDateTime = datetime(1980,1,6);
rGpsReferencePosixTime = convertTo(rGpsReferenceDateTime,'posixtime');
gpsTimePosixTimeSecond = rGpsReferencePosixTime + secondsOffset;
dataCollecttionDateStrSplit = strsplit(dataCollectionDateStr,'_');
dataCollecttionDateDoubleSplit = str2double(dataCollecttionDateStrSplit);
dataCollectionDateTime = datetime(dataCollecttionDateDoubleSplit(1),dataCollecttionDateDoubleSplit(2),dataCollecttionDateDoubleSplit(3));
dataCollectionPosixTime = convertTo(dataCollectionDateTime,'posixtime');
dataCollectionDayGpsWeekSecondHead = dataCollectionPosixTime - gpsTimePosixTimeSecond;
dataCollectionDayGpsWeekSecondTail = dataCollectionDayGpsWeekSecondHead + SECONDS_ONE_DAY;


jzMins200PostRawData = readmatrix(jzMins200DataFilePath);
jzMins200PostData = jzMins200PostRawData(jzMins200PostRawData(:,1)>=dataCollectionDayGpsWeekSecondHead&jzMins200PostRawData(:,1)<=dataCollectionDayGpsWeekSecondTail,:);
jzMins200PostDataSize = size(jzMins200PostData,1);

jzMins200PostDataGpsWeek = ones(jzMins200PostDataSize,1) * gpsWeek;
jzMins200PostDataGpsWeekSecond = jzMins200PostData(:,1);
[jzMins200PostUtcTimeDateTime,jzMins200PostUtcTimeZeroOClockTimeDateTime,jzMins200PostUtcTimeZeroOClockTimePosixTime,jzMins200PostTime] = convertGpsWeekWeekSecondToUtcDateTime(jzMins200PostDataGpsWeek,jzMins200PostDataGpsWeekSecond);

logHeadTimeDateTime = jzMins200PostUtcTimeDateTime(1,1);
logHeadTimeDateStr = datestr(logHeadTimeDateTime,'yyyy-mm-dd HH:MM:ss.FFF');
logHeadSpanTime = jzMins200PostTime(1,1);
logTailTimeDateTime =jzMins200PostUtcTimeDateTime(jzMins200PostDataSize,1);
logTailTimeDateStr = datestr(logTailTimeDateTime,'yyyy-mm-dd HH:MM:ss.FFF');
logTailSpanTime = jzMins200PostTime(jzMins200PostDataSize,1);
duration = logTailSpanTime - logHeadSpanTime;
logMsg = sprintf('JZ-MINE200 post data log from %s to %s, duration %.3f s',logHeadTimeDateStr,logTailTimeDateStr,duration);
log2terminal('I',TAG,logMsg);

jzMins200PostUtcTimeZeroOClockTimeDateStr = datestr(jzMins200PostUtcTimeZeroOClockTimeDateTime(1,1),'yyyy-mm-dd HH:MM:ss.FFF');
logMsg = sprintf('JZ-MINE200 post data zero O''Clock clock based date: %s, time offset %f s', jzMins200PostUtcTimeZeroOClockTimeDateStr,jzMins200PostUtcTimeZeroOClockTimePosixTime(1,1));
log2terminal('I',TAG,logMsg);

jzMins200PostDataSampleTimeInterval = jzMins200PostTime(2:jzMins200PostDataSize,1) - jzMins200PostTime(1:(jzMins200PostDataSize-1),1);
jzMins200PostDataMeanSampleTimeInterval = mean(jzMins200PostDataSampleTimeInterval);
jzMins200PostDataMaxSampleTimeInterval = max(jzMins200PostDataSampleTimeInterval);
jzMins200PostDataMinSampleTimeInterval = min(jzMins200PostDataSampleTimeInterval);
jzMins200PostDataSampleRate = 1 / jzMins200PostDataMeanSampleTimeInterval;
logMsg = sprintf('JZ-MINE200 post data sample interval mean %.3f s, min %.3f s, max %.3f s, estimated sample rate %.0f Hz', jzMins200PostDataMeanSampleTimeInterval,jzMins200PostDataMinSampleTimeInterval,jzMins200PostDataMaxSampleTimeInterval,jzMins200PostDataSampleRate);
log2terminal('I',TAG,logMsg);

jzMins200PostData(:,1) = jzMins200PostTime;

outputArg1 = jzMins200PostData;

end