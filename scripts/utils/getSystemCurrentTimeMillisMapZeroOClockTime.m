function [outputArg1,outputArg2] = getSystemCurrentTimeMillisMapZeroOClockTime(systemCurrentTimeMillis)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明
systemCurrentTimeSecond = systemCurrentTimeMillis * 1e-3;
systemCurrentTimeDateTime = datetime(systemCurrentTimeSecond,'ConvertFrom','posixtime','TimeZone','Asia/Shanghai');
systemZeroOClockTimeDateTime = datetime(systemCurrentTimeDateTime.Year,systemCurrentTimeDateTime.Month,systemCurrentTimeDateTime.Day);
systemZeroOClockTimePosixTime = convertTo(systemZeroOClockTimeDateTime,'posixtime');
dSystemZeroOClockTimeOffset = systemZeroOClockTimePosixTime;

outputArg1 = systemZeroOClockTimeDateTime;
outputArg2 = dSystemZeroOClockTimeOffset;
end