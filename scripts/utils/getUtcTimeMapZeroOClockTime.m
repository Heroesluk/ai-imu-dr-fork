function [outputArg1,outputArg2] = getUtcTimeMapZeroOClockTime(utcTime)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明
utcTimeDateTime = datetime(utcTime,'ConvertFrom','posixtime','TimeZone','Asia/Shanghai');
utcTimeZeroOClockTimeDateTime = datetime(utcTimeDateTime.Year,utcTimeDateTime.Month,utcTimeDateTime.Day);
utcTimeZeroOClockTimePosixTime = convertTo(utcTimeZeroOClockTimeDateTime,'posixtime');
dUtcTimeZeroOClockTimeOffset = utcTimeZeroOClockTimePosixTime;

outputArg1 = utcTimeZeroOClockTimeDateTime;
outputArg2 = dUtcTimeZeroOClockTimeOffset;
end