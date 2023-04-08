function [outputArg1,outputArg2,outputArg3,outputArg4] = convertGpsWeekWeekSecondToUtcDateTime(gpsWeek,gpsWeekSecond)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明

SECONDS_ONE_WEEK = 7 * 24 * 60 * 60;

secondsOffset = SECONDS_ONE_WEEK * gpsWeek + gpsWeekSecond;

rGpsReferenceDateTime = datetime(1980,1,6);
rGpsReferencePosixTime = convertTo(rGpsReferenceDateTime,'posixtime');
gpsTimePosixTimeSecond = rGpsReferencePosixTime + secondsOffset;
gpsTimeDateTime = datetime(gpsTimePosixTimeSecond,'ConvertFrom','posixtime','TimeZone','Asia/Shanghai');

gpsTimeZeroOClockTimeDateTime = datetime(gpsTimeDateTime.Year,gpsTimeDateTime.Month,gpsTimeDateTime.Day);
gpsTimeZeroOClockTimeDateTimeLeapseconds = getZeroOClockTimeGpsTimeLeapseconds(gpsTimeZeroOClockTimeDateTime);
utcTimePosixTimeSecond = gpsTimePosixTimeSecond - gpsTimeZeroOClockTimeDateTimeLeapseconds;
utcTimeDateTime = datetime(utcTimePosixTimeSecond,'ConvertFrom','posixtime','TimeZone','Asia/Shanghai');

gpsTimeZeroOClockTimePosixTime = convertTo(gpsTimeZeroOClockTimeDateTime,'posixtime');
zTime = utcTimePosixTimeSecond - gpsTimeZeroOClockTimePosixTime;

outputArg1 = utcTimeDateTime;
outputArg2 = gpsTimeZeroOClockTimeDateTime;
outputArg3 = gpsTimeZeroOClockTimePosixTime;
outputArg4 = zTime;
end